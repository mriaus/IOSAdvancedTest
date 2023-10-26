//
//  ViewController.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 23/10/23.
//

import UIKit

protocol SplashViewControllerDelegate {
    var loginViewModel: LoginViewControllerDelegate {get}
    var charactersViewModel: CharactersViewControllerDelegate {get}
    func getToken()
    var viewState: ((SplashViewState) -> Void)? {get set}
}

enum SplashViewState {
    case navigateToLogin
    case navigateToList
}

class SplashViewController: UIViewController {
    var viewModel: SplashViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setObservers()
        initiViews()
        
    }
    
    private func initiViews() {
        viewModel?.getToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier) {
        case SegueIdentifiersValues.SPLASHtoLOGIN:
            guard let loginViewController = segue.destination as? LoginViewController else {
                print("Error in splash_to_login vm")
                return
            }
            loginViewController.viewModel = viewModel?.loginViewModel
        case SegueIdentifiersValues.SPLASHtoCHARACTERS:
            guard let charactersViewController = segue.destination as? CharactersViewController else {
                print("Error in splash_to_characters vm")
                return
            }
            charactersViewController.viewModel = viewModel?.charactersViewModel
        default: return
        }
    }
    
    private func setObservers() {
        viewModel?.viewState = {[weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .navigateToLogin:
                    self?.performSegue(withIdentifier: SegueIdentifiersValues.SPLASHtoLOGIN, sender: nil)
                    return
                case .navigateToList:
                    self?.performSegue(withIdentifier: SegueIdentifiersValues.SPLASHtoCHARACTERS, sender: nil)
                }
            }
        }
    }
    


}

