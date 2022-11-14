//
//  TripStore.swift
//  travelscrapbookapp
//
//  Created by Aidan Flynn on 11/10/22.
//

import Foundation

struct Trip {
    var id: Int64
    var title: String
    var start: Date
    var end: Date
    var photos: [Photo]
}

final class TripStore {
    static let shared = TripStore() // create one instance to share

    let propertyNotifier = NotificationCenter.default
    let propertyName = NSNotification.Name("TripStore")
    private(set) var trips = [Trip]() {
        didSet {
            propertyNotifier.post(name: propertyName, object: nil)
        }
    }

    private init() { // make constructor private, no other instances can be made
        Db.reset()
        Task {
            let (dbTrips, photoIds) = Db.shared.getAllTrips()
            let photos = await Photo.getAllPhotos()
            trips = Photo.sortPhotos(trips: dbTrips, photoIds: photoIds, photos: photos)
            print("initial trips:", trips)
        }
    }

    func addTrip(title: String, start: Date, end: Date) async {
        let photos = await Photo.getAllPhotos()
        print("photos:")
        print(photos)
        let photos2 = photos.filter { photo in
            let date = photo.date
            return start <= date && date <= end
        }
        print("photos2:")
        print(photos2)
        let tripId = Db.shared.insertTrip(title: title, start: start, end: end)
        for photo in photos {
            Db.shared.insertPhoto(photoId: photo.uId, tripId: tripId)
        }
        let trip = Trip(
            id: tripId,
            title: title,
            start: start,
            end: end,
            photos: photos2
        )
        print("new trip: \(trip)")
        trips.append(trip)
    }
}
