//
//  Expense.swift
//  iExpense
//
//  Created by Mykola Chaikovskyi on 12.09.2024.
//

import SwiftUI

struct ExpenseItem: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Double
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]()
}
