//
//  LoginViewController.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 23/10/23.
//

import UIKit



class LoginViewController: UIViewController {
    
    @IBOutlet weak var mailInput: UITextField!
    @IBOutlet weak var mailErrorLabel: UILabel!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
  
    @IBOutlet weak var loginButton: UIButton!



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func onLoginPressed(_ sender: Any) {
    }
}
