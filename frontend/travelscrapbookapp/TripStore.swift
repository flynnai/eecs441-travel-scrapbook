//
//  TripStore.swift
//  travelscrapbookapp
//
//  Created by Aidan Flynn on 11/10/22.
//

import Foundation


struct DBTrip {
    var title: String
    var photoIds: [String]
}

final class TripStore {
    static let shared = TripStore() // create one instance to share
    private init() {} // make constructor private, no other instances can be made
    
    private(set) var trips = [Trip]()
    
    func getTrips(completion: ((Bool) -> ())?) {
        // TODO fetch trips, store in self.trips
        let dbTrips: [DBTrip] = [] // TODO fetch from DB
        
        for dbTrip in dbTrips {
            do {
                var localTrip = Trip(
                    title: dbTrip.title,
                    photos: try await Photo.getPhotos(dbTrip.photoIds)
                )
                self.trips.append(localTrip)
            } catch {
                print("Could not fetch photos for dbTrip with title: '\(dbTrip.title)'")
                print("Error below:")
                print(error)
            }
        }
        
    }
    
    func postTrip(_ trip: Trip) {
        // TODO send Trip to backend, then on success append to self.trips
    }
}
