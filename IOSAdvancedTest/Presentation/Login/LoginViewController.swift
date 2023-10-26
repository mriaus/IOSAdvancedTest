//
//  LoginViewController.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 23/10/23.
//

import UIKit

protocol LoginViewControllerDelegate {
    var viewState: ((LoginViewState) ->Void)? {get set}
    func onLoginPressed(email: String?, password: String?)
    var charactersViewModel: CharactersViewControllerDelegate { get }

}

enum LoginViewState {
    case loading(_ loading: Bool)
    case showErrorEmail(_ error: String?)
    case showErrorPassword(_ error: String?)
    case navigateToNext
    case showErrorLogin(_ error: String?)
}

class LoginViewController: UIViewController {
    var viewModel: LoginViewControllerDelegate?
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var mailInput: UITextField!
    
    @IBOutlet weak var mailErrorLabel: UILabel!
    
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var loginErrorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initiView()
        setObservers()
    }
    
    private func initiView() {
        mailInput.delegate = self
        passwordInput.delegate = self
        
        view.addGestureRecognizer(
            UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        ))
    }
//    MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == SegueIdentifiersValues.LOGINtoCHARACTERS,
              let charactersViewController = segue.destination as? CharactersViewController else {
            return
        }
        charactersViewController.viewModel = viewModel?.charactersViewModel
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
//    MARK: Add the observers (triggers when the viewStateChange)
    private func setObservers() {
        viewModel?.viewState = {[weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                    self?.loadingView.isHidden = !isLoading
                    return
                case .showErrorEmail(let error):
                    self?.mailErrorLabel.text = error
                    self?.mailErrorLabel.isHidden = (error == nil || error?.isEmpty == true)
                    
                case .showErrorPassword(let error):
                    self?.passwordErrorLabel.text = error
                    self?.passwordErrorLabel.isHidden = (error == nil || error?.isEmpty == true)
                case .navigateToNext:
                    self?.mailErrorLabel.isHidden = true
                    self?.passwordErrorLabel.isHidden = true
                    self?.loginErrorLabel.isHidden = true
                    self?.loadingView.isHidden = true
                    self?.performSegue(withIdentifier: SegueIdentifiersValues.LOGINtoCHARACTERS, sender: nil)
                    return
                case .showErrorLogin(let error):
                    self?.loginErrorLabel.text = error
                    self?.loginErrorLabel.isHidden = (error == nil || error?.isEmpty == true)
                }
            }
        }
    }
    
    
    @IBAction func onLoginPressed(_ sender: Any) {
        viewModel?.onLoginPressed(email: mailInput.text, password: passwordInput.text)
    }
}

//MARK: When you end to edit the text, this triggers
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if mailInput == textField {
            mailErrorLabel.isHidden = true
        } else if passwordInput == textField {
            passwordErrorLabel.isHidden = true
        }
    }
}
