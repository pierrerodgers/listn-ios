//
//  LoginView.swift
//  listn
//
//  Created by Pierre Rodgers on 23/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI
import FloatingLabelTextFieldSwiftUI
import ActivityIndicatorView

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
        }.disabled(viewModel.isLoading).overlay(ActivityIndicatorView(isVisible: $viewModel.isLoading, type: .default).frame(width:50, height:50))
        
        
    }
    
    var signUpView : some View {
        VStack (alignment:.center) {
            Text("Rave").font(.largeTitle).bold()
            Text("Sign up to rave").font(.title)
            
            
            FloatingLabelTextField($email, placeholder: "Email address")
                .addValidation(.init(condition: email.isValid(.email), errorMessage: "Please enter a valid email"))
                .isShowError(true).errorColor(.red)
                .textColor(.primary)
                .frame(height:70)
                .padding(.horizontal)
            
            FloatingLabelTextField($password, placeholder: "Password")
                .isSecureTextEntry(true)
                .textColor(.primary)
                .frame(height:70)
                .padding(.horizontal)
            
            
            LoginButton(action:{
                self.viewModel.signUp(email: self.email, password: self.password)
            }, buttonType: .signup)
            
            Button(action:{self.signingUp = false} ) {
                Text("Log in")
            }.padding(.top)
            
            
            
        }
    }
    
    var completeSignUpView : some View {
        let bindingUsername = Binding<String>(get: {
            self.username
        }, set: {
            self.username = $0
            self.viewModel.checkUsername(self.username)
        })
        
        
        
        return VStack {
            Text("Welcome to Rave").font(.largeTitle).bold()
            
            Text("Finish signing up:").font(.title)
            
            
            FloatingLabelTextField($name, placeholder: "Name")
            .addValidations([.init(condition: name.isValid(.name), errorMessage: "Invalid name"), .init(condition: name.count >= 2, errorMessage: "Enter your full name")])
            .textColor(.primary)
            .isShowError(true)
            .errorColor(.red)
            .frame(height:70)
                .padding(.horizontal)
            
            FloatingLabelTextField(bindingUsername, placeholder: "Username")
            .textColor(.primary)
            .addValidations([.init(condition:viewModel.usernameFree, errorMessage:"Username already exists"), .init(condition:isValidUsername(username: username), errorMessage: "Username is not valid")])
            .isShowError(true)
            .errorColor(.red)
                .frame(height:70)
                .padding(.horizontal)
            
            
            Button(action: {
               self.viewModel.completeSignUp(name:self.name, username:self.username)
            } ) {
                Text("Finish signing up").padding().background(Color.blue).foregroundColor(.white)
            }.disabled(!isValidInput())
        }
    }
    
    var loginView : some View {
        VStack {
            Text("Rave").font(.largeTitle).bold()
            
            Text("Log in or sign up").font(.title)
            
            FloatingLabelTextField($email, placeholder: "Email address")
            .textColor(.primary)
            .frame(height:70)
                .padding(.horizontal)
            
            FloatingLabelTextField($password, placeholder: "Password")
            .textColor(.primary)
            .isSecureTextEntry(true)
            .frame(height:70)
                .padding(.horizontal)
            
            
            HStack {
                Spacer()
                LoginButton(action: { self.viewModel.logIn(email: self.email, password: self.password) }, buttonType: .login)
                
                Button(action: {self.viewModel.logInWithFacebook() }) {
                    Text("Log in with Facebook")
                }
                
                LoginButton(action:{
                    self.signingUp = true
                    self.viewModel.error = nil
                }, buttonType: .signup)
                Spacer()
            }.padding(.vertical)
            
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

struct LoginButton : View {
    enum LoginButtonType : String {
        case signup = "Sign up", login = "Log in"
    }
    
    let action : () -> Void
    
    let buttonType : LoginButtonType
    
    
    var body : some View {
        Button(action: action) {
            Text(buttonType.rawValue).padding().background(Color.blue).foregroundColor(.white).cornerRadius(5)
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
