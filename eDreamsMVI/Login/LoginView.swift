//
//  ContentView.swift
//  eDreamsMVI
//
//  Created by santiago.franco on 15/07/2020.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
}

struct LoginState {
    var valid: Bool = false
    var usernameError: String = ""
    var passwordError: String = ""
    var formError: String = ""
    var showPassword: Bool = false
}

struct LoginView: View {
    
    @ObservedObject private var presenter: LoginPresenter
    @ObservedObject var viewModel = LoginViewModel()
    
    var usernamePublisher: AnyPublisher<LoginPresenter.Intent, Never> {
        return viewModel.$username
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { LoginPresenter.Intent.introduceUsername($0) }
            .eraseToAnyPublisher()
    }
    
    var passwordPublisher: AnyPublisher<LoginPresenter.Intent, Never> {
        return viewModel.$password
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { LoginPresenter.Intent.introducePassword($0) }
            .eraseToAnyPublisher()
    }
    
    
    init(presenter: LoginPresenter) {
        self.presenter = presenter
    }
            
    var body: some View {
        switch presenter.state {
        case .form(let state):
            return formView(state: state)
        case .loading:
            return loadingView
        }
    }
    
    var loadingView: AnyView {
        AnyView(
            ProgressView {
                Text("Loading...")
            }
        )
    }
    
    func formView(state: LoginState) -> AnyView {
        return AnyView(
            VStack {
                Text("Login").font(.largeTitle)
                Form {
                    Section {
                        TextField("Username", text: $viewModel.username)
                            .onReceive(usernamePublisher) { presenter.intentSubject.send($0) }
                        if !state.usernameError.isEmpty {
                            Text(state.usernameError)
                        }
                        
                        HStack {
                            if state.showPassword {
                                TextField("Password", text: $viewModel.password)
                                    .onReceive(passwordPublisher) { presenter.intentSubject.send($0) }
                            } else {
                                SecureField("Password", text: $viewModel.password)
                                    .onReceive(passwordPublisher) { presenter.intentSubject.send($0) }
                            }
                            Button(action: {
                                let intent: LoginPresenter.Intent = state.showPassword ? .hidePassword : .showPassword
                                presenter.intentSubject.send(intent)
                            }, label: {
                                Image(systemName: "shuffle")
                            })
                        }
                    
                        if !state.passwordError.isEmpty {
                            Text(state.passwordError)
                        }
                    }
                    
                    Section {
                        Button("Log In") {
                            presenter.intentSubject.send(.login)
                        }.disabled(!state.valid)
                        
                    }
                }
                
                if !state.formError.isEmpty {
                    Text(state.formError)
                        .foregroundColor(.red)
                        .font(.headline)
                }
        })
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(presenter: LoginPresenter())
    }
}
