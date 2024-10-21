//
//  Expense.swift
//  iExpense
//
//  Created by Mykola Chaikovskyi on 12.09.2024.
//

import SwiftData
import SwiftUI

@Model
class Expense {
    var id: UUID
    var name: String
    var type: String
    var amount: Double
    
    init(id: UUID = UUID(), name: String, type: String, amount: Double) {
        self.id = id
        self.name = name
        self.type = type
        self.amount = amount
    }
}
