//
//  ContentView.swift
//  iExpense
//
//  Created by Mykola Chaikovskyi on 10.09.2024.
//

import SwiftData
import SwiftUI

struct SmallExpense: View {
    let item: Expense
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline.italic())
                Text(item.type)
            }
            
            Spacer()
        
            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        }
    }
}

struct NormalExpense: View {
    let item: Expense
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.type)
            }
            
            Spacer()
        
            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        }
    }
}

struct HugeExpense: View {
    let item: Expense
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                    .fontWeight(.heavy)
                Text(item.type)
            }
            
            Spacer()
        
            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        }
    }
}

struct ContentView: View {
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
        NavigationStack {
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
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink  {
                    AddView()
                        .navigationBarBackButtonHidden()
                } label: {
                    Label("Add expense", systemImage: "plus")
                }
            }
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
        return ContentView()
            .modelContainer(container)
    } catch {
        return Text("Cannot create model container for Expense.")
    }
}
