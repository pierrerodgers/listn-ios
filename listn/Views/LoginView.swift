//
//  LoginView.swift
//  listn
//
//  Created by Pierre Rodgers on 23/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import FloatingLabelTextFieldSwiftUI

struct LoginView: View {
    @ObservedObject var viewModel : LoginViewModel
    
    
    @State var username : String = ""
    @State var password : String = ""
    @State var name : String = ""
    @State var email : String = ""
    
    @State var signingUp : Bool = false
    
    
    var body: some View {
        
        return VStack {
            if viewModel.isAuthenticated {
                AnyView(completeSignUpView)
            }
            else if signingUp{
                AnyView(signUpView)
            }
            else {
                AnyView(loginView)
            }
            if viewModel.error != nil {
                Text(viewModel.error!).foregroundColor(.red).font(.callout).bold()
            }
            Spacer()
        }
        
        
    }
    
    var signUpView : some View {
        VStack (alignment:.center) {
            
            FloatingLabelTextField($email, placeholder: "Email address")
            .addValidation(.init(condition: email.isValid(.email), errorMessage: "Please enter a valid email"))
            .isShowError(true).errorColor(.red)
            .textColor(.primary)
            .frame(height:70)
            
            FloatingLabelTextField($password, placeholder: "Password")
            .isSecureTextEntry(true)
            .textColor(.primary)
            .frame(height:70)
            
            Button(action:{
                self.viewModel.signUp(email: self.email, password: self.password)
                
            }) {
                Text("Sign up")
            }
            Spacer()
            
            
        }
    }
    
    var completeSignUpView : some View {
        let bindingUsername = Binding<String>(get: {
            self.username
        }, set: {
            self.username = $0
            self.viewModel.checkUsername(self.username)
        })
        
        return VStack{
            Text("Welcome to Rave").font(.largeTitle).bold()
            
            Text("Finish signing up:").font(.title)
            
            
            FloatingLabelTextField($name, placeholder: "Name")
            .addValidations([.init(condition: name.isValid(.name), errorMessage: "Invalid name"), .init(condition: name.count >= 2, errorMessage: "Enter your full name")])
            .textColor(.primary)
            .isShowError(true)
            .errorColor(.red)
            .frame(height:70)
            
            FloatingLabelTextField(bindingUsername, placeholder: "Username")
            .textColor(.primary)
            .addValidations([.init(condition:viewModel.usernameFree, errorMessage:"Username already exists"), .init(condition:isValidUsername(username: username), errorMessage: "Username is not valid")])
            .isShowError(true)
            .errorColor(.red)
            .frame(height:70)
            
            
            Button(action: {
                self.viewModel.completeSignUp(name:self.name, username:self.username)
            } ) {
                Text("Finish signing up")
            }.disabled(!isValidInput())
            Spacer()
        }
    }
    
    var loginView : some View {
        VStack {
            Text("log in")
            FloatingLabelTextField($email, placeholder: "Email address")
            .textColor(.primary)
            .frame(height:70)
            
            FloatingLabelTextField($password, placeholder: "Password")
            .textColor(.primary)
            .isSecureTextEntry(true)
            .frame(height:70)
            
            Button(action: {self.viewModel.logIn(email: self.email, password: self.password)}, label: {Text("Log In")})
            if (viewModel.error != nil) {
                Text("Error logging in: \(viewModel.error!)")
            }
            
            Button(action: {self.signingUp = true}, label: {Text("Sign up")})
        }
    }
    
    func isValidInput() -> Bool {
        return name.isValid(.name) && isValidUsername(username: username) && viewModel.usernameFree && !viewModel.checkingUsername
    }
    
    func isValidUsername(username :String ) -> Bool {
        let regex = #"^(?!.*\.\.)(?!.*\.$)[^\W][\w.]{0,29}$"#
        
        return username.range(of: regex, options: .regularExpression) != nil
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
