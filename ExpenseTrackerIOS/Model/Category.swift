//
//  Category.swift
//  ExpenseTrackerIOS
//
//  Created by jaxon on 6/4/24.
//

import SwiftUI
import SwiftData

@Model
class Category {
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \Transaction.category)
    var transactions: [Transaction]?
    
    init(name: String) {
        self.name = name
    }
}
