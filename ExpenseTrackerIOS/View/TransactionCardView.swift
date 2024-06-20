//
//  TransactionCardView.swift
//  ExpenseTrackerIOS
//
//  Created by jaxon on 6/6/24.
//

import SwiftUI

struct TransactionCardView: View {
    @Bindable var transaction: Transaction
    var showTag: Bool = true
    
    var body: some View {
        HStack {
            if showTag {
                Rectangle()
                    .fill(Color.random.opacity(0.3))
                    .frame(width: 4)
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(transaction.title)
                        .font(.headline)
                    
                    // Display category if available
                    if let category = transaction.category {
                        Text(category.name)
                            .font(.footnote)
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                }
                Text(transaction.details)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            if !transaction.amount.isNaN {
                Text(transaction.currencyFormatted)
                    .font(.headline)
            } else {
                Text("$0.00")
                    .font(.headline)
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
    }
}
