//
//  File.swift
//  
//
//  Created by Alessio Rubicini on 13/08/21.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    
    @Binding var centerCoordinate: CLLocationCoordinate2D

    let mapView = MKMapView()

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.centerCoordinate = self.centerCoordinate
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude)
        
        mapView.addAnnotation(annotation)

        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        //print(#function)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: MapView

        var gRecognizer = UITapGestureRecognizer()

        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            self.gRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
            self.gRecognizer.delegate = self
            self.parent.mapView.addGestureRecognizer(gRecognizer)
        }

        @objc func tapHandler(_ gesture: UITapGestureRecognizer) {
            
            // position on the screen, CGPoint
            let location = gRecognizer.location(in: self.parent.mapView)
            // position on the map, CLLocationCoordinate2D
            let coordinate = self.parent.mapView.convert(location, toCoordinateFrom: self.parent.mapView)
            
            withAnimation {
                let clObject = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                parent.centerCoordinate = clObject
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = clObject
                
                withAnimation {
                    parent.mapView.removeAnnotations(parent.mapView.annotations)
                    parent.mapView.addAnnotation(annotation)
                }
                
            }
            
        }
    }
}
