//
//  Photo.swift
//  travelscrapbookapp
//
//  Created by Spencer Todd on 11/9/22.
//

import Foundation
import UIKit
import Photos

struct Photo {
    var uId: String // unique identifier (since filename is not unique)
    var image: UIImage
    var date: Date
    var lat: Double
    var long: Double

    // return all photos in the user's photo library
    // discards photos that don't have a location or date
    static func getAllPhotos() async -> [Photo] {
        // accessing all photos https://stackoverflow.com/a/59858805
        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .fastFormat
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false /* latest first */)]

        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        guard results.count > 0 else {
            return []
        }

        let max = 1000
        let max2 = results.count < max ? results.count : max

        for i in 0 ..< max2 {
            print("\(i): \(results.object(at: i))")
        }

        let photosTask = Task { () -> [Photo] in
            var photos: [Photo] = []

            for i in 0 ..< max2 {
                let asset = results.object(at: i)
                let coordinate = asset.location?.coordinate
                guard coordinate != nil else {
                    continue
                }

                await withCheckedContinuation { (cont: CheckedContinuation<Void, Never>) in // sequentialize callback function
                    manager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: requestOptions) { (image, _) in
                        if let image = image {
                            if let date = asset.creationDate {
                                let photo = Photo(
                                    uId: asset.localIdentifier,
                                    image: image,
                                    date: date,
                                    lat: coordinate!.latitude,
                                    long: coordinate!.longitude
                                )
                                photos.append(photo)
                            } else {
                                print("\(i): bad date")
                            }
                        } else {
                            print("photo \(i): bad image")
                        }

                        cont.resume()
                    }
                }
            }

            return photos
        }

        return try! await photosTask.result.get()
    }

    // given an entire photo library, sort them into each trip
    static func sortPhotos(trips tripsIn: [Trip], photoIds: [[String]], photos: [Photo]) -> [Trip] {
        var trips = tripsIn

        for photo in photos {
            // note i is not trip id
            for i in 0..<trips.count {
                if photoIds[i].contains(photo.uId) {
                    trips[i].photos.append(photo)
                }
            }
        }

        return trips
    }
}
