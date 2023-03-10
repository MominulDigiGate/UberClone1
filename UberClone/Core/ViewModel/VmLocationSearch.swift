//
//  VmLocationSearch.swift
//  UberClone
//
//  Created by Mac Mini 5 on 1/2/23.
//

import Foundation
import MapKit

class VmLocationSearch: NSObject, ObservableObject{
    //MARK: - Properties
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedLocationCoordinate : CLLocationCoordinate2D?
    
    private let searchCompleter = MKLocalSearchCompleter()
    
    var queryFragment: String = ""{
        didSet{
//            print("DEBUG: Query fragment is \(queryFragment)")
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    //MARK: - Helpers
    func selectLocation(_ location: MKLocalSearchCompletion){
        locationSearch(forLocalSearchCompletion: location){  response, error in
            
            if let error  = error {
                print("DEBUG: Error \(error)")
                return
            }
            guard let item = response?.mapItems.first else { return }
            
            let coordinate = item.placemark.coordinate
            self.selectedLocationCoordinate = coordinate
            
//            print("DEBUG: Location coordinates \(coordinate)")
        }
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion,
                        completion: @escaping MKLocalSearch.CompletionHandler){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)
        
    }
}

    //MARK: - MKLocalSearchCompleterDelegate
extension VmLocationSearch: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
