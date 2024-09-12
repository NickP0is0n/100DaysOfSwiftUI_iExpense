//
//  ContentView.swift
//  iExpense
//
//  Created by Mykola Chaikovskyi on 10.09.2024.
//

import SwiftUI

struct SmallExpense: View {
    let item: ExpenseItem
    
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
    let item: ExpenseItem
    
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
    let item: ExpenseItem
    
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
    @StateObject private var expenses = Expenses()
    
    @State private var showingAddExpense = false
    
    var totalPersonal: Double {
        var total = 0.0
        for expense in expenses.items.filter({ $0.type == "Personal" }) {
            total += expense.amount
        }
        return total
    }
    
    var totalBusiness: Double {
        var total = 0.0
        for expense in expenses.items.filter({ $0.type == "Business" }) {
            total += expense.amount
        }
        return total
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal expenses") {
                    ForEach(expenses.items.filter { $0.type == "Personal" }) { item in
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
                    ForEach(expenses.items.filter { $0.type == "Business" }) { item in
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
                Button  {
                    showingAddExpense = true
                } label: {
                    Label("Add expense", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(filterBy: String, at offsets: IndexSet) {
        let filteredExpenses = expenses.items.filter { $0.type == filterBy }
        for offset in offsets {
            expenses.items.removeAll { item in
                filteredExpenses[offset].id == item.id
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
