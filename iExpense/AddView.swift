//
//  AddView.swift
//  iExpense
//
//  Created by Mykola Chaikovskyi on 12.09.2024.
//

import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var type = ""
    @State private var amount = 0.0
    
    var expenses: Expenses
    
    let types = ["Personal", "Business"]
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Expense", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
