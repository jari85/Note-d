//
//  LoginViewModel.swift
//  Note'd
//
//  Created by Ariel on 12/24/22.
//

import SwiftUI
import Firebase

class LoginViewModel: ObservableObject{
    
    //Signup variables
    @Published var isNewUser = false
    @Published var registerEmail = ""
    @Published var registerPassword = ""
    @Published var reEnterPassword = ""

    //Login variables
    @Published var email = ""
    @Published var password = ""
    
    @Published var errorMsg = ""
    @Published var error = false
    @AppStorage("log_Status") var status = false
    
    func loginUser(){
        
        Auth.auth().signIn(withEmail: email, password: password) { [self] (result, err) in
            if let error = err{
                errorMsg = error.localizedDescription
                self.error.toggle()
                return
            }
            
            guard let _ = result else {
                errorMsg = "Please try again Later !"
                error.toggle()
                return
            }
            
            print("Sucess")
            withAnimation{status = true}
        }
        
    }
    
    func resetPassword(){
        Auth.auth().sendPasswordReset(withEmail: email) {[self] (err) in
            if let error = err{
                errorMsg = error.localizedDescription
                self.error.toggle()
                return
            }
            errorMsg = "Reset Link sent successfully!"
            error.toggle()
        }
    }
    
    func registerUser(){
        //checks that passwords match
        if reEnterPassword == registerPassword{
            Auth.auth().createUser(withEmail: registerEmail, password: reEnterPassword) { [self]
                (result, err) in
                
                if let error = err{
                    errorMsg = error.localizedDescription
                    self.error.toggle()
                    return
                }
                
                guard let _ = result else {
                    errorMsg = "Please try again Later !"
                    error.toggle()
                    return
                }
                
                print("Sucess")
                errorMsg = "Account Created!"
                error.toggle()
                withAnimation{isNewUser = false}
            }
          }
        else {
            errorMsg="Passwords do not match"
            error.toggle()
        }
    }
}

