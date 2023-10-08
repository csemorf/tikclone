//
//  SignUpViewController.swift
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

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var usernameContainerView: UIView!
    
    
    var image:UIImage? = nil
    
    func validateFields() {
        guard let username = usernameTextfield.text, !username.isEmpty else {
            ProgressHUD.showError("please enter username")
            return
        }
        guard let email = emailTextfield.text, !email.isEmpty else {
            ProgressHUD.showError("please enter email")
            return
        }
        guard let password = passwordTextfield.text, !password.isEmpty else {
            ProgressHUD.showError("please enter password")
            return
        }
    }
    
    @IBAction func signUpDidTapped(_ sender: Any) {
        validateFields()
        signUp {
            let scene =  UIApplication.shared.connectedScenes.first
            if let sceneDelegate = (scene?.delegate as? SceneDelegate) {
                sceneDelegate.setupInitialViewController()
            }

        } onError: { errorMessage in
            ProgressHUD.showError(errorMessage)
        }

        
    }
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var signupButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupEmailTextfield()
        setupUsernameTextfield()
        setupPasswordTextfield()
        setupView()
    }
    
    func setupEmailTextfield() {
        emailContainerView.layer.borderColor = CGColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.8)
        emailContainerView.layer.borderWidth = 1
        emailContainerView.clipsToBounds = true
        emailContainerView.layer.cornerRadius = 20
        emailTextfield.borderStyle = .none
    }
    func setupUsernameTextfield() {
        usernameContainerView.layer.borderColor = CGColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.8)
        usernameContainerView.layer.borderWidth = 1
        usernameContainerView.clipsToBounds = true
        usernameContainerView.layer.cornerRadius = 20
        usernameTextfield.borderStyle = .none
    }
    func setupPasswordTextfield() {
        passwordContainerView.layer.borderColor = CGColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.8)
        passwordContainerView.layer.borderWidth = 1
        passwordContainerView.clipsToBounds = true
        passwordContainerView.layer.cornerRadius = 20
        passwordTextfield.borderStyle = .none
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Create new account"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func setupView() {
        avatar.layer.cornerRadius = 75
        signupButton.layer.cornerRadius = 18
        avatar.isUserInteractionEnabled = true
        avatar.clipsToBounds = true
        avatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentPicker)))
    }

}

extension SignUpViewController: PHPickerViewControllerDelegate {
    @objc func presentPicker(){
        var config  = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker,animated:true)
       
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for image in results {
            image.itemProvider.loadObject(ofClass: UIImage.self) { image, err in
                if let imageSelected = image as? UIImage {
                    
                    DispatchQueue.main.async {
                        self.avatar.image = imageSelected
                        self.image = imageSelected
                    }
                }
            }
            
        }
        dismiss(animated: true)
    }
}
extension SignUpViewController {
    func signUp(onSuccess:@escaping()->Void,onError:@escaping(_ errorMessage:String)->Void) {
        ProgressHUD.show("Loading...")
        Api.User.signUp(with: usernameTextfield.text!, email: emailTextfield.text!, password: passwordTextfield.text!, image: self.image) {
            ProgressHUD.dismiss()
            onSuccess()
        } onError: { errorMessage in
            onError(errorMessage)
        }

    }
}
