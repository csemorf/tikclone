//
//  ViewController.swift
//  TiktokClone
//
//  Created by admin on 03/10/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func signUpDidTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    @IBAction func signInWithEmailDidTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    func setupView() {
        signupButton.layer.cornerRadius=15
        facebookButton.layer.cornerRadius=15
        googleButton.layer.cornerRadius=15
        loginButton.layer.cornerRadius=15
    }

}

