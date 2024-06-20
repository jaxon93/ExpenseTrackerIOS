//
//  Transaction.swift
//  ExpenseTrackerIOS
//
//  Created by jaxon on 6/4/24.
//

import SwiftUI
import SwiftData

@Model
class Transaction {
    var title: String
    var details: String
    var amount: Double
    var date: Date
    var category: Category?
    
    init(title: String, details: String, amount: Double, date: Date, category: Category? = nil) {
        self.title = title
        self.details = details
        self.amount = amount
        self.date = date
        self.category = category
    }
    
    @Transient
    var currencyFormatted: String {
        if amount.isNaN {
            print("Error: Transaction amount is NaN for transaction: \(title)")
            return "$0.00"
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"  // Ensure the currency is formatted as USD
        return formatter.string(for: amount) ?? "$0.00"
    }
}
