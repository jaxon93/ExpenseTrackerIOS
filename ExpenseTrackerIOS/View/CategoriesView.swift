//
//  CategoriesView.swift
//  ExpenseTrackerIOS
//
//  Created by jaxon on 6/4/24.
//

import SwiftUI
import SwiftData

struct CategoriesView: View {
    @Query(animation: .snappy) private var allCategories: [Category]
    @Environment(\.modelContext) private var context
    
    @State private var addCategory: Bool = false
    @State private var categoryName: String = ""
    @State private var deleteAlert: Bool = false
    @State private var categoryToDelete: Category?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(allCategories.sorted(by: {
                    ($0.transactions?.count ?? 0) > ($1.transactions?.count ?? 0)
                })) { category in
                    DisclosureGroup {
                        if let transactions = category.transactions, !transactions.isEmpty {
                            ForEach(transactions) { transaction in
                                TransactionCardView(transaction: transaction, showTag: false)
                                    .padding(.vertical, 4)
                            }
                        } else {
                            HStack {
                                Spacer()
                                Text("No Transactions")
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                    } label: {
                        HStack {
                            Text(category.name)
                                .font(.headline)
                            Spacer()
                            Text("\(category.transactions?.count ?? 0) Transactions")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            deleteAlert.toggle()
                            categoryToDelete = category
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Categories")
            .overlay {
                if allCategories.isEmpty {
                    VStack {
                        Label("No Categories", systemImage: "tray.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                        Text("Add a new category to get started.")
                            .foregroundColor(.gray)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addCategory.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $addCategory) {
                categoryName = ""
            } content: {
                addCategoryView
                    .interactiveDismissDisabled()
            }
            .alert("Are you sure you want to delete this category?", isPresented: $deleteAlert) {
                Button("Delete", role: .destructive) {
                    withAnimation {
                        if let categoryToDelete = categoryToDelete {
                            context.delete(categoryToDelete)
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
    
    @ViewBuilder
    var addCategoryView: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Category Info")) {
                        TextField("Category Name", text: $categoryName)
                            .padding(10)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(.systemGroupedBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                
                HStack {
                    Button("Cancel") {
                        addCategory.toggle()
                    }
                    .padding()
                    .foregroundColor(.red)
                    
                    Spacer()
                    
                    Button("Done") {
                        let newCategory = Category(name: categoryName)
                        context.insert(newCategory)
                        addCategory.toggle()
                    }
                    .padding()
                    .bold()
                    .disabled(categoryName.isEmpty)
                    .background(categoryName.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("New Category")
        }
    }
}

#Preview {
    CategoriesView()
}
