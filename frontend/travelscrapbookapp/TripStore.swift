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
    private(set) var trips = [Trip]()

    private init() { // make constructor private, no other instances can be made
        Task {
            let (dbTrips, photoIds) = Db.shared.getAllTrips()
            let photos = await Photo.getAllPhotos()
            trips = Photo.sortPhotos(trips: dbTrips, photoIds: photoIds, photos: photos)
        }
    }

    func addTrip(title: String, start: Date, end: Date) {
        // TODO
        // 1. get all photos
        // 2. filter based on date
        // 3. use Db.insertTrip
        // 4. use Db.insertPhoto on each remaining photo
        // 5. use this info to construct the final Trip struct and append it to trips array
    }
}
