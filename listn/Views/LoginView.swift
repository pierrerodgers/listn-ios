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
    
    
    var body: some View {
        
        return VStack {
            if viewModel.isLoggedIn {
                if !viewModel.finishedSignUp {
                    AnyView(completeSignUpView)
                }
                else {
                    AnyView(
                        HStack{
                            Text("Logged in!")
                            Button(action: {self.viewModel.logOut()}, label: {Text("Log out")})
                        }
                    
                    )
                }
            }
            else if viewModel.signingUp {
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
            .frame(height:70)
            
            FloatingLabelTextField($password, placeholder: "Password")
            .isSecureTextEntry(true)
            .frame(height:70)
            
            Button(action:{
                self.viewModel.signUp(username: self.email, password: self.password)
                
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
            // do whatever you want here
        })
        
        return VStack{
            Text("Welcome to Rave").font(.largeTitle).bold()
            
            Text("Finish signing up:").font(.title)
            
            
            FloatingLabelTextField($name, placeholder: "Name")
            .addValidations([.init(condition: name.isValid(.name), errorMessage: "Invalid name"), .init(condition: name.count >= 2, errorMessage: "Enter your full name")])
            .isShowError(true)
            .errorColor(.red)
            .frame(height:70)
            
            FloatingLabelTextField(bindingUsername, placeholder: "Username") {
                self.viewModel.checkUsername(self.username)
            }
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
            TextField("Username", text: $username)
            SecureField("Password", text: $password)
            Button(action: {self.viewModel.logIn(username: self.username, password: self.password)}, label: {Text("Log In")})
            if viewModel.hasError {
                Text("Error \(viewModel.error!)")
            }
            Button(action: {self.viewModel.signingUp = true}, label: {Text("Sign up")})
            if viewModel.hasError {
                Text("Error \(viewModel.error!)")
            }
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
