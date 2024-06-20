//
//  EditExpenseView.swift
//  ExpenseTrackerIOS
//
//  Created by jaxon on 6/7/24.
//

import SwiftUI

struct EditExpenseView: View {
    @Environment(\.modelContext) private var context
    @State private var title: String
    @State private var subTitle: String
    @State private var amount: Double
    @State private var date: Date
    var expense: Expense
    
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    
    init(expense: Expense) {
        self.expense = expense
        _title = State(initialValue: expense.title)
        _subTitle = State(initialValue: expense.subTitle)
        _amount = State(initialValue: expense.amount)
        _date = State(initialValue: expense.date)
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Details") {
                    TextField("Title", text: $title)
                    TextField("Subtitle", text: $subTitle)
                    TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("Edit Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        context.rollback()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        do {
                            expense.title = title
                            expense.subTitle = subTitle
                            expense.amount = amount
                            expense.date = date
                            try context.save()
                        } catch {
                            errorMessage = error.localizedDescription
                            showErrorAlert = true
                        }
                    }
                }
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}
