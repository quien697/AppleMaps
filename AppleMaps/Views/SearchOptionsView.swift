//
//  SearchOptionsView.swift
//  AppleMaps
//
//  Created by Quien on 2023-10-15.
//

import SwiftUI

struct SearchOptionsView: View {
  // MARK: - Properties
  let searchOptions =  [
    "Restaurants": "fork.knife",
    "Hotels": "bed.double.fill",
    "Coffee": "cup.and.saucer.fill",
    "Gas": "fuelpump.fill"
  ]
  let onSelected: (String) -> Void
  
  // MARK: - Body
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(searchOptions.sorted(by: >), id: \.0) { key, value in
          Button {
            onSelected(key)
          } label: {
            HStack {
              Image(systemName: value)
              Text(key)
            }
          }
          .buttonStyle(.borderedProminent)
          .tint(Color(red: 236/255, green: 240/255, blue: 241/255, opacity: 1.0))
          .foregroundStyle(.black)
          .padding(4)
        }
      }
    }
  }
}

#Preview {
  SearchOptionsView(onSelected: { _ in })
}
