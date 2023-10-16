//
//  SearchBarView.swift
//  AppleMaps
//
//  Created by Quien on 2023-10-15.
//

import SwiftUI

struct SearchBarView: View {
  // MARK: - Properties
  @Binding var search: String
  @Binding var isSearching: Bool
  
  // MARK: - Body
  var body: some View {
    VStack(spacing: -10) {
      TextField("Search", text: $search)
        .textFieldStyle(.roundedBorder)
        .padding()
        .onSubmit {
          isSearching = true
        }
      
      SearchOptionsView { searchTerm in
        search = searchTerm
        isSearching = true
      }
      .padding(.leading, 10)
    }
  }
}

#Preview {
  SearchBarView(search: .constant("Coffee"), isSearching: .constant(true))
}
