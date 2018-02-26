//
//  ViewController.swift
//  AC-iOS-Final
//
//  Created by C4Q  on 2/22/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, email != "", let password = passwordTextField.text, password != "" else {return}
        FirebaseAPIClient.manager.creatNewAccout(email: email, password: password, completionHandler: {(user, error) in
            if let error = error {
                print("create new account error: \(error)")
                self.showAlert(title: "Error creating account", message: error.localizedDescription)
            }
            if let _ = user {
                self.showAlert(title: "Success", message: "Account has been created. Click 'login' to log in.")
            }
            
        })
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, email != "", let password = passwordTextField.text, password != "" else {return}
        FirebaseAPIClient.manager.loginUser(email: email, password: password, completionHandler:{(user, error) in
            if let error = error {
                self.showAlert(title: "Error login", message: error.localizedDescription)
            }
            if let _ = user {
             // let tabBarCotroller = UITabBarController()
                // let narVC = UINavigationController(rootViewController: FeedViewController())
               // self.present(narVC, animated: true, completion: nil)
               self.performSegue(withIdentifier: "presentTabBarController", sender: self)
            }
        })
    }
    public static func storyboardInstance() -> LoginViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        return loginViewController
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

