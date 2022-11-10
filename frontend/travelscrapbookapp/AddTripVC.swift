//
//  AddTripVC.swift
//  travelscrapbookapp
//
//  Created by Yuer Gao on 11/8/22.
//

//
//  ViewController.swift
//  swiftChatter
//
//  Created by Aidan on 9/11/22.
//

import UIKit

final class AddTripVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    weak var postImage: UIImageView!  // Probably chage this to whatever we want to store images in
    
    @IBAction func pickMedia(_ sender: Any) {
        presentPicker(.photoLibrary)
    }
    
    private func presentPicker(_ sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = ["public.image"]  // No videos allowed
        present(imagePickerController, animated: true, completion: nil)  // Why is this not presenting?
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            if mediaType  == "public.image" {
                postImage.image = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage ??
                                    info[UIImagePickerController.InfoKey.originalImage] as? UIImage)?
                    .resizeImage(targetSize: CGSize(width: 150, height: 181))
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

