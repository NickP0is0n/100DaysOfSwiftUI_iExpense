//
//  AddView.swift
//  iExpense
//
//  Created by Mykola Chaikovskyi on 12.09.2024.
//

import SwiftUI

struct AddView: View {
    @State private var name = "New expense"
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    let types = ["Personal", "Business"]
    var body: some View {
        NavigationStack {
            Form {                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Expense", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle($name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = Expense(name: name, type: type, amount: amount)
                        modelContext.insert(item)
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
