//
//  GroupedExpenses.swift
//  ExpenseTrackerIOS
//
//  Created by jaxon on 6/5/24.
//

import SwiftUI

struct GroupedTransactions: Identifiable {
    var id: UUID = .init()
    var date: Date
    var transactions: [Transaction]
    
    var displayTitle: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            return date.formatted(date: .abbreviated, time: .omitted)
        }
    }
}
