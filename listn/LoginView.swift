//
//  LoginView.swift
//  listn
//
//  Created by Pierre Rodgers on 23/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel : LoginViewModel
    
    var body: some View {
        VStack {
            Button(action: {self.viewModel.logIn(username: "test", password: "test")}, label: {Text("Log In")})
            if viewModel.hasError {
                Text("Error \(viewModel.error!)")
            }
        }
        
    }
}
/*
struct LoginView_Previews: PreviewProvider {
    
    /*let loginService = MongoLoginService(app: app)
    let viewModel = LoginViewModel(loginService: loginService)*/
    static var previews: some View {
        //LoginView(viewModel: viewModel)
    }
}
*/
