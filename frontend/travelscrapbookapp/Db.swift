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

        try! db.run(Db.trips.create(ifNotExists: true) { t in
            t.column(Db.tripId, primaryKey: .autoincrement)
            t.column(Db.tripStart)
            t.column(Db.tripEnd)
        })

        try! db.run(Db.photos.create(ifNotExists: true) { t in
            t.column(Db.photoId, primaryKey: true)
            t.column(Db.photoTripId, references: Db.trips, Db.tripId)
            t.foreignKey(Db.photoTripId, references: Db.trips, Db.tripId, delete: .cascade)
        })
    }

    static func reset() {
        try! FileManager.default.removeItem(atPath: Db.path)
    }

    func insertTrip(start: Date, end: Date) -> Int64 {
        return try! db.run(Db.trips.insert(Db.tripStart <- start, Db.tripEnd <- end))
    }

    func printTrips() {
        print("start print trips")
        for trip in try! db.prepare(Db.trips) {
            print("id: \(trip[Db.tripId])\tstart: \(trip[Db.tripStart])\tend: \(trip[Db.tripEnd])")
        }
        print("end print trips")
    }

    func insertPhoto(photoId: String, tripId: Int64) {
        try! db.run(Db.photos.insert(Db.photoId <- photoId, Db.photoTripId <- tripId))
    }

    // return photo ID for each photo in the given trip
    func getTripPhotos(tripId: Int64) -> [String] {
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

    static func demo() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy:MM:dd HH:mm:ss"

        Db.reset()
        Db.shared.printTrips()
        let start = dateFormatter.date(from: "2022:11:10 21:39:00")!
        let end = dateFormatter.date(from: "2022:12:01 12:00:00")!
        let tripId = Db.shared.insertTrip(start: start, end: end)
        print("inserted trip \(tripId)")
        Db.shared.printTrips()

        Db.shared.printPhotos()
        Db.shared.insertPhoto(photoId: "123ABC", tripId: tripId)
        Db.shared.printPhotos()
        let tripPhotos = Db.shared.getTripPhotos(tripId: tripId)
        print("trip \(tripId) photos: \(tripPhotos)")
    }
}
