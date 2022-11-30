//
//  GalleryVC.swift
//  travelscrapbookapp
//
//  Created by Spencer Todd on 11/29/22.
//

import Foundation
import UIKit

class GalleryVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    @IBOutlet weak var grid: UICollectionView!
    @IBOutlet weak var trashButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.updateTrashVisibility()
        self.grid.allowsSelection = true
        self.grid.allowsSelectionDuringEditing = true
        self.grid.allowsMultipleSelection = true
        self.grid.allowsMultipleSelectionDuringEditing = true
        TripStore.shared.propertyNotifier.addObserver(
            self,
            selector: #selector(tripStoreObserver(_:)),
            name: TripStore.shared.propertyName,
            object: nil
        )
    }

    @objc private func tripStoreObserver(_ event: NSNotification) {
        DispatchQueue.main.async {
            self.updateTrashVisibility()
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
        cell.selectedIcon.isHidden = true
        return cell
    }

    // view for supplementary element
    // for data source
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cell = self.grid.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "GalleryTripTitle", for: indexPath) as? GalleryTripTitle else {
            fatalError("GalleryVC: no reuseable supplementary cell")
        }

        let trip = TripStore.shared.trips[indexPath.section]
        cell.tripTitle.text = trip.title
        return cell
    }

    // did select item at
    // for collection delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard self.isEditing else { return }
        print("selecting image: ", indexPath)
        let cell = self.grid.cellForItem(at: indexPath) as! GalleryImageCell
        cell.selectedIcon.isHidden = false
        self.updateTrashVisibility()
    }

    // did de-select item at
    // for collection delegate
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard self.isEditing else { return }
        print("deselecting image: ", indexPath)
        let cell = self.grid.cellForItem(at: indexPath) as! GalleryImageCell
        cell.selectedIcon.isHidden = true
        self.updateTrashVisibility()
    }

    private func updateTrashVisibility() {
        let isNoPhotoSelected: Bool = (self.grid.indexPathsForSelectedItems ?? []).isEmpty
        self.trashButton.isHidden = !self.isEditing || isNoPhotoSelected
    }

    @IBAction func deleteSelectedPhotos(_ sender: Any) {
        print("deleting selected photos")
        print("index paths for visible items: ", self.grid.indexPathsForSelectedItems ?? [])
        var photos: [(String, Int64)] = []

        for index in self.grid.indexPathsForSelectedItems ?? [] {
            let trip = TripStore.shared.trips[index.section]
            let photo = trip.photos[index.row]
            photos.append((photo.uId, trip.id))
        }

        TripStore.shared.deletePhotos(photos: photos)
        self.isEditing = false
    }
}

class GalleryTripTitle: UICollectionReusableView {
    @IBOutlet weak var tripTitle: UILabel!
}

class GalleryImageCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var selectedIcon: UIImageView!
}
