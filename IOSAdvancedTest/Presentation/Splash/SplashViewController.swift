//
//  ViewController.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 23/10/23.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        changeView()
    }
    
    func changeView (){
        self.performSegue(withIdentifier: "SPLASH_TO_LOGIN" , sender: nil)
    }


}

