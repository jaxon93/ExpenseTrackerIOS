//
// ReportsView.swift
// ExpenseTrackerIOS
//
// Created by jaxon on 6/7/24.
//

import SwiftUI
import Charts
import SwiftData

struct ReportsView: View {
    @Query(sort: [
        SortDescriptor(\Transaction.date, order: .reverse)
    ]) private var allTransactions: [Transaction]
    
    @State private var selectedReportType: ReportType = .monthly
    @State private var categoryColors: [String: Color] = [:]
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Select Report", selection: $selectedReportType) {
                    ForEach(ReportType.allCases, id: \.self) { reportType in
                        Text(reportType.rawValue.capitalized).tag(reportType)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if let chartData = generateChartData() {
                    ZStack {
                        Chart {
                            ForEach(chartData) { data in
                                SectorMark(
                                    angle: .value("Value", data.value),
                                    innerRadius: .ratio(0.6),
                                    outerRadius: .ratio(1.0)
                                )
                                .foregroundStyle(categoryColors[data.category, default: assignColor(to: data.category)])
                                .annotation(position: .overlay) {
                                    VStack {
                                        Text(data.category)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                        Text(data.value.formatted(.currency(code: "USD")))
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                        .chartLegend(.visible)
                        .padding()
                        
                        VStack {
                            Text(totalSpent(chartData).formatted(.currency(code: "USD")))
                                .font(.largeTitle.bold())
                            Text("Total Spent")
                                .font(.headline)
                        }
                    }
                } else {
                    ContentUnavailableView {
                        Label("No Data", systemImage: "tray.fill")
                    }
                }
            }
            .navigationTitle("Reports")
        }
    }
    
    private func generateChartData() -> [ChartData]? {
        let calendar = Calendar.current
        var filteredTransactions: [Transaction] = []
        
        switch selectedReportType {
        case .weekly:
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
            filteredTransactions = allTransactions.filter { $0.date >= weekAgo }
        case .monthly:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: Date())!
            filteredTransactions = allTransactions.filter { $0.date >= monthAgo }
        case .yearly:
            let yearAgo = calendar.date(byAdding: .year, value: -1, to: Date())!
            filteredTransactions = allTransactions.filter { $0.date >= yearAgo }
        }

        guard !filteredTransactions.isEmpty else { return nil }

        let categoryTotals = Dictionary(grouping: filteredTransactions, by: { $0.category?.name ?? "Uncategorized" })
            .mapValues { expenses in
                expenses.reduce(0) { $0 + $1.amount }
            }
        
        return categoryTotals.map { ChartData(category: $0.key, value: $0.value) }
    }
    
    private func totalSpent(_ chartData: [ChartData]) -> Double {
        return chartData.reduce(0) { $0 + $1.value }
    }

    private func assignColor(to category: String) -> Color {
        if let existingColor = categoryColors[category] {
            return existingColor
        } else {
            let newColor = Color.random
            categoryColors[category] = newColor
            return newColor
        }
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}

enum ReportType: String, CaseIterable {
    case weekly, monthly, yearly
}

struct ChartData: Identifiable {
    var id: String { category }
    let category: String
    let value: Double
}

#Preview {
    ReportsView()
}
