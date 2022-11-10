//
//  TripStore.swift
//  travelscrapbookapp
//
//  Created by Aidan Flynn on 11/10/22.
//

import Foundation


final class TripStore {
    static let shared = TripStore() // create one instance to share
    private init() {} // make constructor private, no other instances can be made
    
    private(set) var trips = [Trip]()
    
    func getTrips(completion: ((Bool) -> ())?) {
        // TODO fetch trips, store in self.trips
    }
    
    func postTrip(_ trip: Trip) {
        // TODO send Trip to backend, then on success append to self.trips
    }
}
