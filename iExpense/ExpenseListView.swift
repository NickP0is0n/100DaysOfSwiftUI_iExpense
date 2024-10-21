//
//  ExpenseListView.swift
//  iExpense
//
//  Created by Mykola Chaikovskyi on 22.10.2024.
//

import SwiftData
import SwiftUI

struct ExpenseListView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var expenses: [Expense]
    
    var totalPersonal: Double {
        var total = 0.0
        for expense in expenses.filter({ $0.type == "Personal" }) {
            total += expense.amount
        }
        return total
    }
    
    var totalBusiness: Double {
        var total = 0.0
        for expense in expenses.filter({ $0.type == "Business" }) {
            total += expense.amount
        }
        return total
    }
    
    var body: some View {
        List {
            Section("Personal expenses") {
                ForEach(expenses.filter { $0.type == "Personal" }) { item in
                    if item.amount <= 10 {
                        SmallExpense(item: item)
                    } else if item.amount <= 100 {
                        NormalExpense(item: item)
                    } else {
                        HugeExpense(item: item)
                    }
                }
                .onDelete { indexSet in
                    removeItems(filterBy: "Personal", at: indexSet)
                }
            }
            
            Section("Business expenses") {
                ForEach(expenses.filter { $0.type == "Business" }) { item in
                    if item.amount <= 10 {
                        SmallExpense(item: item)
                    } else if item.amount <= 100 {
                        NormalExpense(item: item)
                    } else {
                        HugeExpense(item: item)
                    }
                }
                .onDelete { indexSet in
                    removeItems(filterBy: "Business", at: indexSet)
                }
            }
            
            Section("Total") {
                HStack {
                    Text("Personal")
                        .font(.headline)
                    Spacer()
                    Text(totalPersonal, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
                
                HStack {
                    Text("Business")
                        .font(.headline)
                    Spacer()
                    Text(totalBusiness, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
        }
    }
    
    init(filter: FilterType, sort sortOrder: [SortDescriptor<Expense>]) {
        switch(filter) {
        case .all:
            _expenses = Query(sort: sortOrder)
        case .personal:
            _expenses = Query(filter: #Predicate<Expense> { item in
                item.type == "Personal"
            }, sort: sortOrder)
        case .business:
            _expenses = Query(filter: #Predicate<Expense> { item in
                item.type == "Business"
            }, sort: sortOrder)
        }
    }
    
    func removeItems(filterBy: String, at offsets: IndexSet) {
        let filteredExpenses = expenses.filter { $0.type == filterBy }
        
        for offset in offsets {
            let expenseToRemove = filteredExpenses[offset]
            modelContext.delete(expenseToRemove)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Expense.self, configurations: config)
        return ExpenseListView(filter: .all, sort: [
            SortDescriptor(\Expense.name),
            SortDescriptor(\Expense.amount)
        ])
            .modelContainer(container)
    } catch {
        return Text("Cannot create model container for Expense.")
    }
}
