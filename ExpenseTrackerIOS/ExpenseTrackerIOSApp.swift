//
//  ExpenseTrackerIOSApp.swift
//  ExpenseTrackerIOS
//
//  Created by jaxon on 6/4/24.
//
           
import SwiftUI
import SwiftData

@main
struct ExpenseTrackerIOSApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: [Transaction.self, Category.self])
    }
}
