//
//  CreateAccountViewController.swift
//  travelscrapbookapp
//
//  Created by Emir Erben on 11/9/22.
//

import UIKit
import FirebaseAuth

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //UNCOMMENT LATER!!!!!!!
    
    @IBAction func signupClicked(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        Auth.auth().createUser(withEmail: email, password: password) { firebaseResult, error in
            guard firebaseResult != nil, error == nil else{
                return
                // self.performSegue(withIdentifier: "goToNext", sender: self)
            }
            self.performSegue(withIdentifier: "goToLogin", sender: self)
            
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
