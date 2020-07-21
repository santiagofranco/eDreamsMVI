//
//  eDreamsMVIApp.swift
//  eDreamsMVI
//
//  Created by santiago.franco on 15/07/2020.
//

import SwiftUI

@main
struct eDreamsMVIApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView(presenter: LoginPresenter())
        }
    }
}
