//
//  Picture.swift
//  travelscrapbookapp
//
//  Created by Spencer Todd on 11/9/22.
//

import Foundation
import UIKit
import Photos

struct Picture {
    var uId: String // unique identifier (since filename is not unique)
    var data: Data
    var image: UIImage
    var date: Date?
    var lat: Double?
    var long: Double?

    static func getPhotos() async throws -> [Picture] {
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

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy:MM:dd HH:mm:ss"

        let photosTask = Task { () -> [Picture] in
            var pictures: [Picture] = []
            let max = 10
            let max2 = results.count < max ? results.count : max
            for i in 0 ..< max2 {
                let asset = results.object(at: i)
                let coordinate = asset.location?.coordinate
                let lat = coordinate != nil ? coordinate!.latitude : nil
                let long = coordinate != nil ? coordinate!.longitude : nil

                await withCheckedContinuation { (cont: CheckedContinuation<Void, Never>) in // sequentialize callback function
                    manager.requestImageDataAndOrientation(for: asset, options: requestOptions) { (data, _, _, _) in
                        if let data = data {
                            // ImageIO metadata https://stackoverflow.com/a/52024197
                            let options = [kCGImageSourceShouldCache as String: kCFBooleanFalse]
                            if let imgSrc = CGImageSourceCreateWithData(data as CFData, options as CFDictionary) {
                                let metadata = CGImageSourceCopyPropertiesAtIndex(imgSrc, 0, options as CFDictionary) as! [String: Any]
                                let date = (metadata["{TIFF}"] as? [String : Any])?["DateTime"] as? String
                                let image = UIImage(data: data as Data)!
                                let picture = Picture(
                                    uId: asset.localIdentifier,
                                    data: data,
                                    image: image,
                                    date: date != nil ? dateFormatter.date(from: date!) : nil,
                                    lat: lat,
                                    long: long
                                )
                                pictures.append(picture)
                            }
                        } else {
                            print("photo \(i): bad data")
                        }
                        cont.resume()
                    }
                }
            }

            return pictures
        }

        return try await photosTask.result.get()
    }
}
