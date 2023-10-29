//
//  ViewController.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 23/10/23.
//

import UIKit
import Lottie

protocol SplashViewControllerDelegate {
    var loginViewModel: LoginViewControllerDelegate {get}
    var charactersViewModel: CharactersViewControllerDelegate {get}
    var tabBarViewModel: TabBarViewControllerDelegate {get}
    func getToken()
    var viewState: ((SplashViewState) -> Void)? {get set}
}

enum SplashViewState {
    case navigateToLogin
    case navigateToList
}

class SplashViewController: UIViewController {
    @IBOutlet weak var lottieView: LottieAnimationView!
    var viewModel: SplashViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setObservers()
        initiViews()
        
    }
    
    private func initiViews() {
        lottieView.loopMode = .loop
        lottieView.animationSpeed = 1
        if(!lottieView.isAnimationPlaying){
            lottieView.play()

        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)){ [weak self] in
            self?.viewModel?.getToken()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lottieView.stop()
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
        case SegueIdentifiersValues.SPLASHtoTABS:
            guard let tabBarViewController = segue.destination as? TabBarViewController else {
                print("Error in splash_to_characters vm")
                return
            }
            
            tabBarViewController.viewModel = viewModel?.tabBarViewModel
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
                    self?.performSegue(withIdentifier: SegueIdentifiersValues.SPLASHtoTABS, sender: nil)
                }
            }
        }
    }
    


}

