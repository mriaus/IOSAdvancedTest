//
//  LoginViewModel.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 23/10/23.
//

import Foundation

class LoginViewModel: LoginViewControllerDelegate {
    var viewState: ((LoginViewState) -> Void)?
    
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    var charactersViewModel: CharactersViewControllerDelegate {
        CharactersViewModel(apiProvider: apiProvider, dataProvider: secureDataProvider, logged: true)
    }
    
    //    MARK: - Init -
    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        
        NotificationCenter.default.addObserver(self, selector: #selector(onLoginSucces),
                                               name: Notification.Name(NotificationCenter.APILOGINNOTIFICATION.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLoginFailed),
                                               name: Notification.Name(NotificationCenter.APILOGINFAILEDNOTIFICATION.rawValue), object: nil)
    }
    func onLoginPressed(email: String?, password: String?) {
        self.viewState?(.loading(true))
        
        DispatchQueue.global().async {
            guard self.isValid(email: email) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorEmail("Invalid email"))
                return
            }
            
            guard self.isValid(password: password)else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorPassword("Invalid password"))
                return
            }
            self.doLoginWith(email: email ?? "", password: password ?? "")
        }
    }
    
    @objc func onLoginSucces(_ notification: Notification) {
        //        Always before the function ends
        defer {
            viewState?(.loading(false))
        }
        
        guard let token = notification.userInfo?[NotificationCenter.TOKENKEY] as? String,
              !token.isEmpty else {
            return
        }
        
        secureDataProvider.save(token: token)
        NotificationCenter.default.removeObserver(self)
        viewState?(.navigateToNext)
    }
    
    @objc func onLoginFailed(_ notification: Notification){
        viewState?(.loading(false))
        guard let errorCode = notification.userInfo?[NotificationCenter.STATUSCODEERROR] as? Int else{
            viewState?(.showErrorLogin("Error trying to log in"))
            return
        }
        if(errorCode == 401){
            viewState?(.showErrorLogin("Wrong username or password"))
        }else{
            viewState?(.showErrorLogin("Unexpected error"))
        }
    }
    
    private func isValid(email: String?) -> Bool {
        email?.isEmpty == false && email?.contains("@") ?? false
    }
    
    private func isValid(password: String? ) -> Bool {
        password?.isEmpty == false && (password?.count ?? 0) >= 4
    }
    
    private func doLoginWith(email: String, password: String) {
        apiProvider.login(for: email, with: password)
    }
    
}
