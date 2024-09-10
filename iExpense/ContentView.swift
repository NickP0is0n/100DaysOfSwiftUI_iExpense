//
//  ContentView.swift
//  iExpense
//
//  Created by Mykola Chaikovskyi on 10.09.2024.
//

import SwiftUI

class User: ObservableObject {
    @Published var firstName = "David"
    @Published var lastName = "Tennant"
}

struct ContentView: View {
    @StateObject private var user = User()
    
    var body: some View {
        VStack {
            Text("Your name is \(user.firstName) \(user.lastName).")
            
            TextField("First name", text: $user.firstName)
            TextField("First name", text: $user.lastName)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
