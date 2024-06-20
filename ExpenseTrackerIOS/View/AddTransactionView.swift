//
//  AddTransactionView.swift
//  ExpenseTrackerIOS
//
//  Created by jaxon on 6/5/24.
//

import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Query(animation: .snappy) private var allCategories: [Category]
    
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var amount: Double = 0.0
    @State private var date: Date = .init()
    @State private var category: Category?
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Transaction Info").font(.headline).foregroundColor(.blue)) {
                    TextField("Title", text: $title)
                        .padding(10)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    
                    TextField("Details", text: $details)
                        .padding(10)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    
                    HStack {
                        Text("$")
                            .foregroundColor(.gray)
                        TextField("Amount", value: $amount, format: .number)
                            .keyboardType(.decimalPad)
                            .padding(10)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                }
                .padding(.vertical, 8)
                
                Section(header: Text("Category").font(.headline).foregroundColor(.blue)) {
                    Picker("Category", selection: $category) {
                        Text("Uncategorized")
                            .tag(nil as Category?)
                        ForEach(allCategories) { category in
                            Text(category.name)
                                .tag(Optional(category))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(10)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        let newTransaction = Transaction(
                            title: title,
                            details: details,
                            amount: amount,
                            date: date,
                            category: category
                        )
                        context.insert(newTransaction)
                        dismiss()
                    }
                    .bold()
                    .disabled(title.isEmpty || amount <= 0)
                }
            }
        }
    }
}

#Preview {
    AddTransactionView()
}
