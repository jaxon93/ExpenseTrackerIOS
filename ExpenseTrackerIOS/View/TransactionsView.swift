//
//  TransactionView.swift
//  ExpenseTrackerIOS
//
//  Created by jaxon on 6/4/24.
//
import SwiftUI
import SwiftData

struct TransactionsView: View {
    @Binding var selectedTab: String
    @Query(sort: [
        SortDescriptor(\Transaction.date, order: .reverse)
    ], animation: .snappy) private var allTransactions: [Transaction]
    @Environment(\.modelContext) private var context
    
    @State private var groupedTransactions: [GroupedTransactions] = []
    @State private var originalGroupedTransactions: [GroupedTransactions] = []
    @State private var addTransaction: Bool = false
    @State private var searchQuery: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($groupedTransactions) { $group in
                    Section(group.displayTitle) {
                        ForEach(group.transactions) { transaction in
                            TransactionCardView(transaction: transaction)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button {
                                        context.delete(transaction)
                                        withAnimation {
                                            group.transactions.removeAll(where: { $0.id == transaction.id })
                                            if group.transactions.isEmpty {
                                                groupedTransactions.removeAll(where: { $0.id == group.id })
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .tint(.red)
                                }
                        }
                    }
                }
            }
            .navigationTitle("Transactions")
            .searchable(text: $searchQuery, placement: .navigationBarDrawer, prompt: Text("Search"))
            .overlay {
                if allTransactions.isEmpty || groupedTransactions.isEmpty {
                    ContentUnavailableView {
                        Label("No Transactions", systemImage: "tray.fill")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addTransaction.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
        }
        .onChange(of: searchQuery, initial: false) { oldValue, newValue in
            if !newValue.isEmpty {
                filterTransactions(newValue)
            } else {
                groupedTransactions = originalGroupedTransactions
            }
        }
        .onChange(of: allTransactions, initial: true) { oldValue, newValue in
            if newValue.count > oldValue.count || groupedTransactions.isEmpty || selectedTab == "Categories" {
                groupTransactions(newValue)
            }
        }
        .sheet(isPresented: $addTransaction) {
            AddTransactionView()
                .interactiveDismissDisabled()
        }
    }
    
    func filterTransactions(_ text: String) {
        Task.detached(priority: .high) {
            let query = text.lowercased()
            let filteredTransactions = originalGroupedTransactions.compactMap { group -> GroupedTransactions? in
                let filtered = group.transactions.filter { transaction in
                    return transaction.title.lowercased().contains(query)
                }
                if filtered.isEmpty {
                    return nil
                }
                return GroupedTransactions(date: group.date, transactions: filtered)
            }

            await MainActor.run {
                groupedTransactions = filteredTransactions
            }
        }
    }
    
    func groupTransactions(_ transactions: [Transaction]) {
        Task.detached(priority: .high) {
            let groupedDict = Dictionary(grouping: transactions) { transaction in
                Calendar.current.dateComponents([.day, .month, .year], from: transaction.date)
            }

            let sortedDict = groupedDict.sorted { lhs, rhs in
                let date1 = Calendar.current.date(from: lhs.key) ?? Date()
                let date2 = Calendar.current.date(from: rhs.key) ?? Date()
                return date1 > date2
            }

            let newGroupedTransactions = sortedDict.compactMap { dict -> GroupedTransactions? in
                let date = Calendar.current.date(from: dict.key) ?? Date()
                return GroupedTransactions(date: date, transactions: dict.value)
            }

            await MainActor.run {
                groupedTransactions = newGroupedTransactions
                originalGroupedTransactions = newGroupedTransactions
            }
        }
    }
}

#Preview {
    MainView()
}
