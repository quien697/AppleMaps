//
//  ContentView.swift
//  AppleMaps
//
//  Created by Quien on 2023-10-15.
//

import SwiftUI
import MapKit

struct ContentView: View {
  // MARK: - Properties
  @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
  @State private var locationManager = LocationManager.shared
  @State private var selectedDetent: PresentationDetent = .fraction(0.15)
  @State private var searchQuery: String = ""
  @State private var isSearching: Bool = false
  @State private var mapItems: [MKMapItem] = []
  @State private var selectedMapItem: MKMapItem?
  @State private var visibleRegion: MKCoordinateRegion?
  @State private var isShowDetails = false
  @State private var route: MKRoute?
  @State private var isShowingRoute = false
  
  // MARK: - Body
  var body: some View {
    Map(position: $position, selection: $selectedMapItem) {
      UserAnnotation()
      
      ForEach(mapItems, id: \.self) { mapItem in
        if isShowingRoute {
          if mapItem == selectedMapItem {
            Marker(item: mapItem)
          }
        } else {
          Marker(item: mapItem)
        }
      }
      
      if let route {
        MapPolyline(route.polyline)
          .stroke(.blue, lineWidth: 5)
      }
    } //: Map
    .mapControls {
      MapCompass()
      MapPitchToggle()
      MapUserLocationButton()
    }
    .onMapCameraChange { context in
      visibleRegion = context.region
    }
    .task(id: isSearching) {
      // Call search function when isSearching = true
      if isSearching {
        await search()
      }
    }
    .task(id: isShowingRoute) {
      // Call requestCalculateDirections function when isShowingRoute = true
      if isShowingRoute {
        await requestCalculateDirections()
      }
    }
    .task(id: selectedMapItem) {
      // Display detail of sheet
      if selectedMapItem != nil {
        isShowDetails = true
      }
    }
    .sheet(isPresented: .constant(true)) {
      VStack {
        TextField("Search", text: $searchQuery)
          .textFieldStyle(.roundedBorder)
          .padding()
          .onSubmit {
            isSearching = true
          }
        
        SearchOptionsView { query in
          searchQuery = query
          isSearching = true
        }
        .padding(.leading, 10)
        
        Spacer()
      } //: VStack of sheet
      .presentationDetents(
        [.fraction(0.15), .medium, .large],
        selection: $selectedDetent
      )
      .presentationDragIndicator(.visible)
      .interactiveDismissDisabled()
      .presentationBackgroundInteraction(.enabled(upThrough: .medium))
      .sheet(isPresented: $isShowDetails, onDismiss: {
        route = nil
        isShowingRoute = false
      }, content: {
        LocationDetailsView(
          selectedMapItem: $selectedMapItem,
          isShowing: $isShowDetails,
          isShowingRoute: $isShowingRoute)
        .presentationDragIndicator(.visible)
        .presentationDetents([.fraction(0.15), .medium, .large])
        .interactiveDismissDisabled()
        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        .padding(.top, 20)
      }) //: sheet of LocationDetailsView
    } //: sheet
  }
}

extension ContentView {
  // MARK: - Functions
  
  private func search() async {
    do {
      self.mapItems = try await performSearch(searchQuery: searchQuery, visibleRegion: visibleRegion)
    } catch {
      self.mapItems = []
      print(error.localizedDescription)
    }
    self.isSearching = false
  }
  
  private func requestCalculateDirections() async {
    self.route = nil
    if let selectedMapItem {
      guard let currentUserLocation = locationManager.manager.location else { return }
      
      let startingMapItem = MKMapItem(placemark: MKPlacemark(coordinate: currentUserLocation.coordinate))
      self.route = await calculateDirections(from: startingMapItem, to: selectedMapItem)
    }
  }
  
}

#Preview {
  ContentView()
}
