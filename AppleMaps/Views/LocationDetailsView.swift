//
//  LocationDetailsView.swift
//  AppleMaps
//
//  Created by Quien on 2023-10-15.
//

import SwiftUI
import MapKit

struct LocationDetailsView: View {
  // MARK: - Properties
  @State private var lookAroundScene: MKLookAroundScene?
  @Binding var selectedMapItem: MKMapItem?
  @Binding var isShowing: Bool
  @Binding var isShowingRoute: Bool
  
  // MARK: - Body
  var body: some View {
    ScrollView {
      HStack {
        VStack(alignment: .leading) {
          Text(selectedMapItem?.placemark.name ?? "")
            .font(.title2)
            .fontWeight(.semibold)
          
          Text(selectedMapItem?.placemark.title ?? "")
            .font(.footnote)
            .foregroundStyle(.gray)
            .lineLimit(2)
            .padding(.trailing)
        }
        
        Spacer()
        
        Button {
          isShowing = false
          selectedMapItem = nil
        } label: {
          Image(systemName: "xmark.circle.fill")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(.gray, Color(.systemGray6))
        }
      } //: HStack
      .padding(.horizontal, 12)
      
      HStack(spacing: 24) {
        Button {
          if let selectedMapItem {
            selectedMapItem.openInMaps()
          }
        } label: {
          Text("Open in Maps")
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: 170, height: 48)
            .background(.green)
            .cornerRadius(12)
        }
        
        Button {
          isShowingRoute = true
        } label: {
          Text("Get Directions")
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: 170, height: 48)
            .background(.blue)
            .cornerRadius(12)
        }
      }
      
      if let scene = lookAroundScene {
        LookAroundPreview(initialScene: scene)
          .frame(height: 200)
          .cornerRadius(12)
          .padding()
      } else {
        ContentUnavailableView("No preview available", systemImage: "eye.slash")
      }
      
      Spacer()
    } //: VStack
    .onAppear {
      fetchLookAroundPreview()
    }
    .onChange(of: selectedMapItem) {
      fetchLookAroundPreview()
    }
  }
}

extension LocationDetailsView {
  // MARK: - Functions
  
  func fetchLookAroundPreview() {
    if let selectedMapItem {
      lookAroundScene = nil
      Task {
        let request = MKLookAroundSceneRequest(mapItem: selectedMapItem)
        lookAroundScene = try? await request.scene
      }
    }
  }
  
}

#Preview {
  LocationDetailsView(selectedMapItem: .constant(nil), isShowing: .constant(false), isShowingRoute: .constant(false))
}
