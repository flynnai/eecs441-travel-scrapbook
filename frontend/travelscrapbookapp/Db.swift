//
//  DB.swift
//  travelscrapbookapp
//
//  Created by Spencer Todd on 11/10/22.
//
// https://github.com/stephencelis/SQLite.swift/blob/master/Documentation/Index.md

import Foundation
import SQLite

class Db {
    static let shared = Db()

    static let trips = Table("trips")
    static let tripId = Expression<Int64>("id")
    static let tripTitle = Expression<String>("title")
    static let tripStart = Expression<Date>("start")
    static let tripEnd = Expression<Date>("end")

    static let photos = Table("photos")
    static let photoId = Expression<String>("id")
    static let photoTripId = Expression<Int64>("tripId")

    static private var path: String {
        let Documents = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        return "\(Documents)/travelscrapbook.sqlite"
    }

    private var db: Connection

    private init() {
        db = try! Connection(Db.path)

// uncomment to delete db and reset
//        try! db.run(Db.trips.drop(ifExists: true))
        try! db.run(Db.trips.create(ifNotExists: true) { t in
            t.column(Db.tripId, primaryKey: .autoincrement)
            t.column(Db.tripTitle)
            t.column(Db.tripStart)
            t.column(Db.tripEnd)
        })
        
// uncomment to delete db and reset
//        try! db.run(Db.photos.drop(ifExists: true))
        try! db.run(Db.photos.create(ifNotExists: true) { t in
            t.column(Db.photoId)
            t.column(Db.photoTripId, references: Db.trips, Db.tripId)
            t.foreignKey(Db.photoTripId, references: Db.trips, Db.tripId, delete: .cascade)
            t.primaryKey(Db.photoId, Db.photoTripId)
        })
    }

    static func reset() {
        try? FileManager.default.removeItem(atPath: Db.path)
    }

    // insert a new trip into the db
    // returns the trip id of the new trip
    func insertTrip(title: String, start: Date, end: Date) -> Int64 {
        return try! db.run(Db.trips.insert(
            Db.tripTitle <- title,
            Db.tripStart <- start,
            Db.tripEnd <- end
        ))
    }

    func getAllTrips() -> ([Trip], [[String]]) {
        var trips: [Trip] = []
        var photoIds: [[String]] = []

        for trip in try! db.prepare(Db.trips) {
            let tripId = trip[Db.tripId]
            let trip = Trip(
                id: tripId,
                title: trip[Db.tripTitle],
                start: trip[Db.tripStart],
                end: trip[Db.tripEnd],
                photos: []
            )
            trips.append(trip)
            photoIds.append(getTripPhotos(tripId: tripId))
            print("PhotoIds ")
            print( photoIds)
        }

        return (trips, photoIds)
    }

    func printTrips() {
        print("start print trips")
        for trip in try! db.prepare(Db.trips) {
            print("id: \(trip[Db.tripId])\tstart: \(trip[Db.tripStart])\tend: \(trip[Db.tripEnd])")
        }
        print("end print trips")
    }

    func insertPhoto(photoId: String, tripId: Int64) {
        // print("Inserting" + photoId)
        try! db.run(Db.photos.insert(Db.photoId <- photoId, Db.photoTripId <- tripId))
    }

    // return photo ID for each photo in the given trip
    func getTripPhotos(tripId: Int64) -> [String] {
        print("fetching " + String(tripId))
        let query = Db.photos.select(Db.photoId).filter(Db.photoTripId == tripId)
        return try! db.prepare(query).map({ $0[Db.photoId] })
    }

    func printPhotos() {
        print("start print photos")
        for photo in try! db.prepare(Db.photos) {
            print("id: \(photo[Db.photoId])\ttrip: \(photo[Db.photoTripId])")
        }
        print("end print photos")
    }

    // pair of photo id and trip id
    func deletePhotos(photos: [(String, Int64)]) {
        for (photoId, tripId) in photos {
            try! db.run(Db.photos.filter(Db.photoId == photoId && Db.photoTripId == tripId).delete())
        }
    }
}
