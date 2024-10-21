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

enum FilterType {
    case all, personal, business
}

struct ContentView: View {
    @State private var sortOrder = [
        SortDescriptor(\Expense.name),
        SortDescriptor(\Expense.amount)
    ]
    
    @State private var currentFilterType = FilterType.all
    
    var body: some View {
        NavigationStack {
            ExpenseListView(filter: currentFilterType, sort: sortOrder)
            .navigationTitle("iExpense")
            .toolbar {
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $sortOrder) {
                        Text("Sort by name")
                            .tag([
                                    SortDescriptor(\Expense.name),
                                    SortDescriptor(\Expense.amount)
                                ])
                        Text("Sort by amount")
                            .tag([
                                    SortDescriptor(\Expense.amount),
                                    SortDescriptor(\Expense.name)
                                ])
                    }
                }
                
                Menu("Filter", systemImage: "eye") {
                    Picker("Sort", selection: $currentFilterType) {
                        Text("All expenses")
                            .tag(FilterType.all)
                        Text("Personal expenses")
                            .tag(FilterType.personal)
                        Text("Business expenses")
                            .tag(FilterType.business)
                    }
                }
                
                NavigationLink  {
                    AddView()
                        .navigationBarBackButtonHidden()
                } label: {
                    Label("Add expense", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
