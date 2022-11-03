//
//  MapsVC.swift
//  swiftChatter
//
//  Created by Yuer Gao on 10/3/22.
//

import UIKit
import GoogleMaps

final class MapsVC: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    private var mapView: GMSMapView!
    var locmanager: CLLocationManager!
    
    var chatt: Chatt? = nil
    
    override func loadView() {
        mapView = GMSMapView()
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set self as the delegate for GMSMapView's infoWindow events
        mapView.delegate = self
        // put mylocation marker down; Google automatically asks for location permission
        mapView.isMyLocationEnabled = true
        // enable the location bull's eye button
        mapView.settings.myLocationButton = true
        var chattMarker: GMSMarker!
        
        if let chatt = chatt, let geodata = chatt.geodata {
            
            let coordinate = CLLocationCoordinate2D(latitude: geodata.lat, longitude: geodata.lon)
            chattMarker = GMSMarker(position: coordinate)
            chattMarker.map = mapView
            chattMarker.userData = chatt
            
            // move camera to chatt's location
            mapView.camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 16.0)
            
        } else {
            // set self as the delegate for CLLocationManager's events
            // and set up the location manager.
            locmanager.delegate = self
            
            // obtain user's current location so that we can
            // zoom the map to the current location
            locmanager.startUpdatingLocation()
            
            // Add a marker on the MapView for each chatt
            ChattStore.shared.chatts.forEach {
                if let geodata = $0.geodata {
                    chattMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: geodata.lat, longitude: geodata.lon))
                    chattMarker.map = mapView
                    chattMarker.userData = $0
                }
            }
        }
    }
}
            
