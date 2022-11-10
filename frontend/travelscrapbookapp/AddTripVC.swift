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
    
    @IBOutlet weak var pickStartDate: UITextField!
    @IBOutlet weak var pickEndDate: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let dateStartPicker = UIDatePicker()
        dateStartPicker.datePickerMode = .date
        dateStartPicker.addTarget(self, action: #selector(dateStartChange(dateStartPicker:)), for: UIControl.Event.valueChanged)
        dateStartPicker.preferredDatePickerStyle = .wheels
        
        pickStartDate.inputView = dateStartPicker
        pickStartDate.text = formatDate(date: Date())  // Initialized with today's date
        
        let dateEndPicker = UIDatePicker()
        dateEndPicker.datePickerMode = .date
        dateEndPicker.addTarget(self, action: #selector(dateEndChange(dateEndPicker:)), for: UIControl.Event.valueChanged)
        dateEndPicker.preferredDatePickerStyle = .wheels
        
        pickEndDate.inputView = dateEndPicker
        pickEndDate.text = formatDate(date: Date())  // Initialized with today's date
    }
    
    @objc func dateStartChange(dateStartPicker: UIDatePicker){
        pickStartDate.text = formatDate(date: dateStartPicker.date)
        
    }
    
    @objc func dateEndChange(dateEndPicker: UIDatePicker){
        pickEndDate.text = formatDate(date: dateEndPicker.date)
        
    }
    
    func formatDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        return formatter.string(from: date)
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

