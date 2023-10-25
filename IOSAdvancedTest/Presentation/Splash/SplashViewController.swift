//
//  ViewController.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 23/10/23.
//

import UIKit

protocol SplashViewControllerDelegate {
    var loginViewModel: LoginViewControllerDelegate {get}
}

class SplashViewController: UIViewController {
    var viewModel: SplashViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        changeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier) {
        case SegueIdentifiersValues.SPLASHtoLOGIN:
            guard let loginViewController = segue.destination as? LoginViewController else {
                print("Error en el splash_to_login vm")
                return
            }
            loginViewController.viewModel = viewModel?.loginViewModel
        default: return
        }
    }
    
    func changeView (){
        self.performSegue(withIdentifier: SegueIdentifiersValues.SPLASHtoLOGIN  , sender: nil)
    }


}

