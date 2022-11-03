//
//  ViewController.swift
//  swiftChatter
//
//  Created by Yuer Gao on 9/1/22.
//

import UIKit
import GoogleMaps

    
final class PostVC: UIViewController, CLLocationManagerDelegate  {
    private var usernameLabel: UILabel!
    private var messageTextView: UITextView!
    var locmanager: CLLocationManager!
    private var lat = 0.0
    private var lon = 0.0
    private var speed = -1.0
    private var heading = 0.0
    private var geodata: GeoData!
    
    override func loadView() {
        let postView = PostView()
        usernameLabel = postView.usernameLabel
        messageTextView = postView.messageTextView
        view = postView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let submitButton = UIBarButtonItem(
            image: UIImage(systemName: "paperplane"),
            primaryAction:UIAction(handler: submitChatt))
        self.navigationItem.rightBarButtonItem = submitButton
        self.navigationItem.title = "Post"
        
        // Do any additional setup after loading the view.
        // handles location manager updates
        locmanager.delegate = self
        // and start getting user's current location and heading
        locmanager.startUpdatingLocation()
        locmanager.startUpdatingHeading()
    }
    
    func submitChatt(_ sender: Any) {
        geodata = GeoData(lat: lat, lon: lon, facing: convertHeading(), speed: convertSpeed())
        convertLocation {
            ChattStore.shared.postChatt(Chatt(username: self.usernameLabel.text,
                                              message: self.messageTextView.text,
                                              geodata: self.geodata))
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // Get user's location
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
            speed = location.speed
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.magneticHeading
    }
    
    
    
    func convertHeading() -> String {
        let compass = ["North", "NE", "East", "SE", "South", "SW", "West", "NW", "North"]
        let index = Int(round(heading.truncatingRemainder(dividingBy: 360) / 45))
        return compass[index]
    }
    
    func convertSpeed() -> String {
        switch speed {
        case 1.2..<5:
            return "walking"
        case 5..<7:
            return "running"
        case 7..<13:
            return "cycling"
        case 13..<90:
            return "driving"
        case 90..<139:
            return "in train"
        case 139..<225:
            return "flying"
        default:
            return "resting"
        }
    }
    
    func convertLocation(_ completion: @escaping () -> ()) {
        // Reverse geocode to get user's city name
        GMSGeocoder().reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: lat, longitude: lon)) { response, _ in
            if let address = response?.firstResult(), let lines = address.lines {
                // get city name from the first address returned
                self.geodata.loc = lines[0].components(separatedBy: ", ")[1]
            }
            completion()
        }
    }
    
    override func viewWillDisappear(_ anim: Bool) {
        super.viewWillDisappear(anim)
        
        locmanager.stopUpdatingLocation()
        locmanager.stopUpdatingHeading()
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
            
            guard let chatt = marker.userData as? Chatt else {
                return nil
            }
            
            let infoView = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 150))
            infoView.translatesAutoresizingMaskIntoConstraints = false
            infoView.backgroundColor = UIColor.white
            infoView.layer.cornerRadius = 6
            
            let timestamp = UILabel(frame: CGRect.init(x: 10, y: 10, width: infoView.frame.size.width - 16, height: 15))
            timestamp.translatesAutoresizingMaskIntoConstraints = false
            timestamp.text = chatt.timestamp
            timestamp.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            timestamp.textColor = .systemBlue
            
            let username = UILabel(frame: CGRect.init(x: timestamp.frame.origin.x, y: timestamp.frame.origin.y + timestamp.frame.size.height + 5, width: infoView.frame.size.width - 16, height: 15))
            username.translatesAutoresizingMaskIntoConstraints = false
            username.text = chatt.username
            username.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            username.textColor = .black
            
            let message = UILabel(frame: CGRect.init(x: username.frame.origin.x, y: username.frame.origin.y + username.frame.size.height + 10, width: infoView.frame.size.width - 16, height: 15))
            message.translatesAutoresizingMaskIntoConstraints = false
            message.text = chatt.message
            message.textColor = .darkGray

            infoView.addSubview(timestamp)
            infoView.addSubview(username)
            infoView.addSubview(message)

            guard let geodata = chatt.geodata else {
                return infoView
            }
            
            let infoLabel = UILabel(frame: CGRect.init(x: message.frame.origin.x, y: message.frame.origin.y + message.frame.size.height + 30, width: infoView.frame.size.width - 16, height: 40))
            infoLabel.translatesAutoresizingMaskIntoConstraints = false
            infoLabel.font = UIFont.systemFont(ofSize: 16)
            infoLabel.numberOfLines = 0
            infoLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            infoLabel.textColor = .black
            infoLabel.text = "Posted from " + geodata.loc + ", while facing " + geodata.facing + " moving at " + geodata.speed + " speed."
            infoLabel.highlight(searchedText: geodata.loc, geodata.facing, geodata.speed)
            
            infoView.addSubview(infoLabel)
            
            return infoView
        }
    
}

