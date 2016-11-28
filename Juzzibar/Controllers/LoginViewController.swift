/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
  
  
  // MARK: Constants
  let loginToList = "LoginToList"
  
  // MARK: Outlets
  @IBOutlet weak var textFieldLoginEmail: UITextField!
    
  @IBOutlet weak var textFieldLoginPassword: UITextField!
  
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
  let dataURL = "https://databasename.firebaseio.com"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    facebookLoginButton.delegate = self
    facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
    
    // 1
    FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
      // 2
      if user != nil {
        // 3
        self.performSegue(withIdentifier: self.loginToList, sender: nil)
      }
    }
  }
  
  // MARK: Actions
  
  /*
  func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError?) {
    if let error = error {
      print(error.localizedDescription)
      return
    }
    // ...
  }
 */
  
  public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    if let error = error {
      print(error.localizedDescription)
      return
    }
    
    let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
    
    FIRAuth.auth()?.signIn(with: credential) { (user, error) in
      // ...
      print("Signed in with Facebook")
    }
  }
  
  func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    print("User Logged Out")
  }
  
  /*
    @IBAction func facebookLogin(_ sender: UIButton) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self, handler:{(facebookResult, facebookError) -> Void in
            if facebookError != nil { print("Facebook login failed. Error \(facebookError)")
            } else if (facebookResult?.isCancelled)! { print("Facebook login was cancelled.")
            } else {
              print("You’re inz ;)")
          }
        });
    }
    */
  
  
  @IBAction func loginDidTouch(_ sender: AnyObject) {
    //performSegue(withIdentifier: loginToList, sender: nil)
    FIRAuth.auth()!.signIn(withEmail: textFieldLoginEmail.text!,
                           password: textFieldLoginPassword.text!)
  }
 
  
  @IBAction func signUpDidTouch(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Register",
                                  message: "Register",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default) { action in
                                    
                                    // 1
                                    let emailField = alert.textFields![0]
                                    let passwordField = alert.textFields![1]
                                    
                                    // 2
                                    FIRAuth.auth()!.createUser(withEmail: emailField.text!,
                                                               password: passwordField.text!) { user, error in
                                                                if error == nil {
                                                                  // 3
                                                                  FIRAuth.auth()!.signIn(withEmail: self.textFieldLoginEmail.text!,
                                                                                         password: self.textFieldLoginPassword.text!)
                                                                }
                                    }
                                    
    }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    alert.addTextField { textEmail in
      textEmail.placeholder = "Enter your email"
    }
    
    alert.addTextField { textPassword in
      textPassword.isSecureTextEntry = true
      textPassword.placeholder = "Enter your password"
    }
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  
}

extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == textFieldLoginEmail {
      textFieldLoginPassword.becomeFirstResponder()
    }
    if textField == textFieldLoginPassword {
      textField.resignFirstResponder()
    }
    return true
  }
  
}
