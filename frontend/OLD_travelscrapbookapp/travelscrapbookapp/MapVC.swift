/*
 * Copyright 2020 Google Inc. All rights reserved.
 *
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
 * file except in compliance with the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

import UIKit
import GoogleMaps
import GoogleMapsUtils

// for resizing photos
extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}


class ViewController: UIViewController, GMSMapViewDelegate {
    private var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Create a GMSCameraPosition that tells the map to display the
        // se default coordinates and zoom level .
        let camera = GMSCameraPosition.camera(withLatitude: 47.60, longitude: -122.33, zoom: 4.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)

        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        let image = UIImage(named: "cat.jpg")
        let resizedImage = image?.resized(to: CGSize(width: 70, height: 70))
        marker.icon = resizedImage
        
        // Set up the cluster manager with the supplied icon generator and
        // renderer.
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                    clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                                          renderer: renderer)

        // Register self to listen to GMSMapViewDelegate events.
        clusterManager.setMapDelegate(self)
        
        // add places markers
          let position1 = CLLocationCoordinate2D(latitude: 47.60, longitude: -122.33)
          let marker1 = GMSMarker(position: position1)
        marker1.map = mapView
        marker1.icon = resizedImage
        
          let position2 = CLLocationCoordinate2D(latitude: 47.60, longitude: -122.46)
          let marker2 = GMSMarker(position: position2)
        marker2.map = mapView
        marker2.icon = resizedImage
        
          let position3 = CLLocationCoordinate2D(latitude: 47.30, longitude: -122.46)
          let marker3 = GMSMarker(position: position3)
        marker3.map = mapView
        marker3.icon = resizedImage

          let position4 = CLLocationCoordinate2D(latitude: 47.20, longitude: -122.23)
          let marker4 = GMSMarker(position: position4)
        marker4.map = mapView
        marker4.icon = resizedImage
        
          // clusters markers
          let markerArray = [marker, marker1, marker2, marker3, marker4]
          clusterManager.add(markerArray)
          clusterManager.cluster()
        
        // draw paths
         draw(src: position1, dst: position2, mapView: mapView )
         draw(src: position2, dst: position3, mapView: mapView )
         draw(src: position3, dst: position4, mapView: mapView )
        
        
  }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
      // center the map on tapped marker
      mapView.animate(toLocation: marker.position)
      // check if a cluster icon was tapped
      if marker.userData is GMUCluster {
        // zoom in on tapped cluster
        mapView.animate(toZoom: mapView.camera.zoom + 1)
        NSLog("Did tap cluster")
        return true
      }

      NSLog("Did tap a normal marker")
      return false
    }
    

    func draw(src: CLLocationCoordinate2D, dst: CLLocationCoordinate2D, mapView: GMSMapView) {
        let path = GMSMutablePath()
        path.add(src)
        path.add(dst)

        let polyline = GMSPolyline(path: path)
        polyline.map = mapView
        polyline.strokeColor = UIColor.red
        polyline.strokeWidth = 3
    }

}

      
