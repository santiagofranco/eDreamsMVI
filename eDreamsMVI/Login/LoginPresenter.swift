//
//  LoginPresenter.swift
//  eDreamsMVI
//
//  Created by santiago.franco on 15/07/2020.
//

import Foundation
import Combine

class LoginPresenter: ObservableObject, Identifiable {
    
    enum Intent {
        case login
        case introduceUsername(String)
        case introducePassword(String)
        case showPassword
        case hidePassword
    }
    
    enum State {
        case form(LoginState)
        case loading
    }
    
    var loginState = LoginState()
    var username: String = ""
    var password: String = ""
    @Published var state: State = .form(LoginState())
    let intentSubject = PassthroughSubject<Intent, Never>()
    private var intentCancellable: AnyCancellable?
    
    
    init() {
        intentCancellable = intentSubject.sink {
            switch $0 {
            case .login:
                self.state = .loading
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    if self.username == "Santi" && self.password == "Pass" {
                        //TODO: implement navigation here
                        return
                    }
                    
                    self.loginState.formError = "Wrong credentials"
                    self.updateStateForm()
                }
            case .introduceUsername(let username):
                self.username = username
                self.validateState()
                self.updateStateForm()
            case .introducePassword(let password):
                self.password = password
                self.validateState()
                self.updateStateForm()
            case .showPassword:
                self.loginState.showPassword = true
                self.updateStateForm()
            case .hidePassword:
                self.loginState.showPassword = false
                self.updateStateForm()
            }
        }
    }
    
    private func validateState() {
        loginState.valid = !username.isEmpty && !password.isEmpty
    }
    
    private func updateStateForm() {
        state = .form(loginState)
    }
}
