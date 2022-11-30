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


class MapVC: UIViewController, GMSMapViewDelegate {
    private var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    @IBOutlet var addTrip: UIButton!
    @IBOutlet var gallery: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Create a GMSCameraPosition that tells the map to display the
        // se default coordinates and zoom level .
        let camera = GMSCameraPosition.camera(withLatitude: 43.60, longitude: -100, zoom: 3.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        self.view.addSubview(gallery)
        self.view.addSubview(addTrip)

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
        
        
        TripStore.shared.propertyNotifier.addObserver(
            self,
            selector: #selector(propertyObserver(_:)),
            name: TripStore.shared.propertyName,
            object: nil
        )
    }

    func drawTrips() {
        for trip in TripStore.shared.trips {
            // var prevPosition: CLLocationCoordinate2D? = nil
            var markerArray = [GMSMarker]()
            print("my path")
            let path = GMSMutablePath()
            var count = 0
            print(path)
            print("trip!")
            outerloop: for photo in trip.photos {
                count += 1
                if count > 10 {
                    break
                }
                print("drawing photo \(photo.image): \(photo.lat), \(photo.long)")
                let position = CLLocationCoordinate2D(latitude: photo.lat, longitude: photo.long)
                print("position")
                print(position)
                let marker = GMSMarker(position: position)
                marker.map = mapView
                marker.icon = photo.image.resized(to: CGSize(width: 90, height: 90))
                marker.userData = (photo.uId, trip.id)
                print("drawing line between this photo and previous")
                path.add(position)
                // prevPosition = position
                markerArray.append(marker)
            }
            draw(mapView: mapView, path: path)
            clusterManager.add(markerArray)
        }

        clusterManager.cluster()
    }

    @objc private func propertyObserver(_ event: NSNotification) {
        DispatchQueue.main.async {
            print("MapVC: observing updated TripStore")
            self.drawTrips()
        }
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
      // center the map on tapped marker
      mapView.animate(toLocation: marker.position)
      // check if a cluster icon was tapped
      if marker.userData is GMUCluster {
        // zoom in on tapped cluster
        mapView.animate(toZoom: mapView.camera.zoom + 3)
        NSLog("Did tap cluster")
        return true
      }

      NSLog("Did tap a normal marker")
      marker.title = "tap here to delete photo"
      return false
    }

    func draw(mapView: GMSMapView, path: GMSMutablePath) {
        let polyline = GMSPolyline(path: path)
        polyline.map = mapView
        polyline.strokeColor = UIColor.red
        polyline.strokeWidth = 5
    }

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf markerDelete: GMSMarker) {
        mapView.clear()
        let (photoId, tripId) = markerDelete.userData as! (String, Int64)
        TripStore.shared.deletePhotos(photos: [(photoId, tripId)])
        markerDelete.icon = nil
        markerDelete.map = nil
        markerDelete.opacity = 0
        print("did tap info window")
    }
}
