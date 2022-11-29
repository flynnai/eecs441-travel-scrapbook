//
//  GalleryVC.swift
//  travelscrapbookapp
//
//  Created by Spencer Todd on 11/29/22.
//

import Foundation
import UIKit

class GalleryVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var grid: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        TripStore.shared.propertyNotifier.addObserver(
            self,
            selector: #selector(tripStoreObserver(_:)),
            name: TripStore.shared.propertyName,
            object: nil
        )
    }

    @objc private func tripStoreObserver(_ event: NSNotification) {
        DispatchQueue.main.async {
            self.grid.reloadData()
        }
    }

    // for data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return TripStore.shared.trips.count
    }

    // number of items in section (trip)
    // for data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TripStore.shared.trips[section].photos.count
    }

    // cell for item at
    // for data source
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.grid.dequeueReusableCell(withReuseIdentifier: "GalleryImageCell", for: indexPath) as? GalleryImageCell else {
            fatalError("GalleryVC: no reusable cell")
        }

        let trip = TripStore.shared.trips[indexPath.section]
        cell.image.image = trip.photos[indexPath.row].image
        return cell
    }
}
