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

final class AddTripVC: UIViewController {
    @IBOutlet weak var pickStartDate: UITextField!
    @IBOutlet weak var pickEndDate: UITextField!

    @IBAction func addTrip(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"

        Task {
            if let startText = pickStartDate.text, let endText = pickEndDate.text {
                let start = formatter.date(from: startText)
                let end = formatter.date(from: endText)
                if let start = start, let end = end {
                    await TripStore.shared.addTrip(title: "", start: start, end: end)
                    dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let dateStartPicker = UIDatePicker()
        dateStartPicker.datePickerMode = .date
        dateStartPicker.addTarget(self, action: #selector(dateStartChange(dateStartPicker:)), for: UIControl.Event.valueChanged)
        dateStartPicker.preferredDatePickerStyle = .wheels
        dateStartPicker.maximumDate = Date()
        
        pickStartDate.inputView = dateStartPicker
        //pickStartDate.text = formatDate(date: Date())  // Text field initialized with today's date
        
        let dateEndPicker = UIDatePicker()
        dateEndPicker.datePickerMode = .date
        dateEndPicker.addTarget(self, action: #selector(dateEndChange(dateEndPicker:)), for: UIControl.Event.valueChanged)
        dateEndPicker.preferredDatePickerStyle = .wheels
        dateEndPicker.maximumDate = Date()
        
        pickEndDate.inputView = dateEndPicker
        //pickEndDate.text = formatDate(date: Date())  // Text field initialized with today's date
    }
    
    // On change of the date picker value this function runs
    @objc func dateStartChange(dateStartPicker: UIDatePicker){
        pickStartDate.text = formatDate(date: dateStartPicker.date)
    }
    
    // On change of the date picker value this function runs
    @objc func dateEndChange(dateEndPicker: UIDatePicker){
        pickEndDate.text = formatDate(date: dateEndPicker.date)
    }
    
    // Use the pickStartDate.text and pickEndDate.text and store in a data structure/sql db
    // If either the pickStartDate.text and pickEndDate.text is not a date format don't let the Upload Photos button do anything
    
    func formatDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        return formatter.string(from: date)
    }
}

