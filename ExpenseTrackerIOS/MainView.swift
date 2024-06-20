//
//  MainView.swift
//  ExpenseTrackerIOS
//
//  Created by jaxon on 6/4/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @State private var selectedTab: String = "Transactions"
    var body: some View {
        TabView(selection: $selectedTab) {
            TransactionsView(selectedTab: $selectedTab)
                .tag("Transactions")
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("Transactions")
                }
            CategoriesView()
                .tag("Categories")
                .tabItem {
                    Image(systemName: "list.clipboard.fill")
                    Text("Categories")
                }
            ReportsView()
                .tag("Reports")
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("Reports")
                }
        }
    }
}

#Preview {
    MainView()
}
