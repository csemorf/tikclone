//
//  SignInViewController.swift
//  TiktokClone
//
//  Created by admin on 04/10/2023.
//

import PhotosUI
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD

class SignInViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmailTextfield()
        setupPasswordTextfield()
        setupNavigationBar()
        setupView()
        // Do any additional setup after loading the view.
    }
    func setupEmailTextfield() {
        emailContainerView.layer.borderColor = CGColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.8)
        emailContainerView.layer.borderWidth = 1
        emailContainerView.clipsToBounds = true
        emailContainerView.layer.cornerRadius = 20
        emailTextfield.borderStyle = .none
    }
    func setupPasswordTextfield() {
        passwordContainerView.layer.borderColor = CGColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.8)
        passwordContainerView.layer.borderWidth = 1
        passwordContainerView.clipsToBounds = true
        passwordContainerView.layer.cornerRadius = 20
        passwordTextfield.borderStyle = .none
    }
    func setupNavigationBar() {
        navigationItem.title = "Sign In"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func setupView() {
        
        signInButton.layer.cornerRadius = 18
    }

    @IBAction func signInDidTapped(_ sender: Any) {
        validateFields()
        
        signIn(email: emailTextfield.text!, password: passwordTextfield.text!) {
//            
        } onError: { errorMessage in
            ProgressHUD.showError(errorMessage)
        }

    }
    
    
    func validateFields() {
   
        guard let email = emailTextfield.text, !email.isEmpty else {
            ProgressHUD.showError("please enter email")
            return
        }
        guard let password = passwordTextfield.text, !password.isEmpty else {
            ProgressHUD.showError("please enter password")
            return
        }
    }
    
    


}
extension SignInViewController {
    func signIn(email:String,password:String,onSuccess:@escaping()->Void,onError:@escaping(_ errorMessage:String)->Void) {
        
        ProgressHUD.show()
        self.view.endEditing(true)
        Api.User.signIn(with: emailTextfield.text!, password: passwordTextfield.text!) {
            
            ProgressHUD.dismiss()
            onSuccess()
        } onError: { errorMessage in
            onError(errorMessage)
        }

    }
}
