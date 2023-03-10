//
//  UberMapViewRepresentable.swift
//  UberClone
//
//  Created by Mac Mini 5 on 1/2/23.
//

import SwiftUI
import MapKit

struct UberMapViewRepresentable: UIViewRepresentable {
    let mapView = MKMapView()
    let locationManager = LocationManager()
    @Binding var mapState : MapViewState
    @EnvironmentObject var vmLocationSearch : VmLocationSearch
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("DEBUG: mapState is \(mapState)")
        
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterUserLocation()
            break
            
        case .searchingForLocation:
            
            break
            
        case .locationSelected:
            if let coordinate = vmLocationSearch.selectedLocationCoordinate{
                //                print("DEBUG: Selected location coordinate \(coordinate)")
                
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configPolyline(withDestinationCoordinate: coordinate)
            }
            break
            
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    
}


extension UberMapViewRepresentable
{
    class MapCoordinator: NSObject, MKMapViewDelegate
    {
        //MARK:- Properties
        let parent : UberMapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        //MARK: - MKMapViewDelegate
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:  userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            self.currentRegion = region
            parent.mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let poliline = MKPolylineRenderer(overlay: overlay)
            poliline.strokeColor = .systemBlue
            poliline.lineWidth = 6
            return poliline
        }
        
        //MARK: - Helpers
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            let anno =  MKPointAnnotation()
            anno.coordinate = coordinate
            parent.mapView.addAnnotation(anno)
            parent.mapView.selectAnnotation(anno, animated: true)
//            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        
        func configPolyline( withDestinationCoordinate coordinate: CLLocationCoordinate2D){
            guard let userLocationCoordinate  = self.userLocationCoordinate else {return}
            
            getDestinationRoute(from: userLocationCoordinate, to: coordinate){ route in
                self.parent.mapView.addOverlay(route.polyline)
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,
                                                               edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                
            }
        }
        
        
        func getDestinationRoute(from userLocation: CLLocationCoordinate2D,
                                 to destinationLocation: CLLocationCoordinate2D,
                                 completion: @escaping(MKRoute) -> Void){
            let userPlaceMark = MKPlacemark(coordinate: userLocation)
            let destPlaceMark = MKPlacemark(coordinate: destinationLocation)
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlaceMark)
            request.destination = MKMapItem(placemark: destPlaceMark)
            
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                if let error{
                    print("DEBUG: - Failed to get direction \(error.localizedDescription)")
                    return
                }
                guard let route = response?.routes.first else {return}
                
                completion(route)
            }
        }
        
        
        func clearMapViewAndRecenterUserLocation(){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
        
    }
}

