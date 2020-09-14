//
//  SignUpViewController.swift
//  HypeFire
//
//  Created by Cameron Stuart on 7/11/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var photoPickerContainerView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var usernamePasswordsSV: UIStackView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var enterPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var faqButton: UIButton!
    @IBOutlet weak var signMeUpButton: UIButton!
    
    //MARK: - Properties
    var image: UIImage?
    let db = Firestore.firestore()
    var viewsLaidOut = false
    var statusIsSignUp = true
    let defaults = UserDefaults.standard
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        enterPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        usernameTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if viewsLaidOut == false {
            self.setupViews()
            viewsLaidOut = true
            self.checkForUser()
        }
    }
    //MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: Any) {
        if let username = defaults.value(forKey: "savedUsername") as? String {
            toggleToLogin(username: username)
        } else {
            toggleToLogin(username: nil)
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        toggleToSignUp()
    }
    
    func checkForUser() {
        guard let username = defaults.value(forKey: "savedUsername") as? String else { return }
            
        toggleToLogin(username: username)
    }
    
    @IBAction func signMeUpButtonTapped(_ sender: Any) {
        guard let usernameText = usernameTextField.text, !usernameText.isEmpty,
            let passwordText = enterPasswordTextField.text, !passwordText.isEmpty else { return }
        
        if statusIsSignUp == true {
            guard let confirmPasswordText = confirmPasswordTextField.text,
                passwordText == confirmPasswordText,
                let image = self.image else { return }
            UserController.shared.createAndSaveUser(username: usernameText, password: passwordText, profilePhoto: image) { (result) in
                switch result {
                case .success(let user):
                    UserController.shared.currentUser = user
                    self.defaults.set(UserController.shared.currentUser?.username, forKey: "savedUsername")
                    self.presentHypFireVC()
                case .failure(let userError):
                    print(userError.errorDescription)
                }
            }
        } else {
            UserController.shared.fetchUser(username: usernameText, password: passwordText) { (result) in
                switch result {
                case .success(let fetchedUser):
                    UserController.shared.currentUser = fetchedUser
                    self.defaults.set(UserController.shared.currentUser?.username, forKey: "savedUsername")
                    self.presentHypFireVC()
                case .failure(let userError):
                    print(userError.errorDescription)
                }
            }
        }
    }
    
    //MARK: - Methods
    func setupViews() {
        self.view.backgroundColor = .spaceGray
        photoPickerContainerView.addCornerRadius(radius: photoPickerContainerView.frame.height / 2)
        photoPickerContainerView.clipsToBounds = true
        logInButton.rotate()
        signUpButton.rotate()
        signUpButton.tintColor = .mainText
        logInButton.tintColor = .subtleText
        enterPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        helpButton.setTitleColor(.mainText, for: .normal)
        faqButton.setTitleColor(.greenAccent, for: .normal)
    }
    
    func presentHypFireVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "HypeFire", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func toggleToLogin(username: String?) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.photoPickerContainerView.isHidden = true
                self.statusIsSignUp = false
                self.confirmPasswordTextField.isHidden = true
                self.usernamePasswordsSV.spacing = 24
                self.logInButton.tintColor = .mainText
                self.signUpButton.tintColor = .subtleText
                self.signMeUpButton.setTitle("Log Me In!", for: .normal)
                self.helpButton.setTitle("Forgot?", for: .normal)
                self.faqButton.setTitle("Hint", for: .normal)
                self.usernameTextField.text = username ?? ""
                self.enterPasswordTextField.text = ""
                self.confirmPasswordTextField.text = ""
                self.usernameTextField.becomeFirstResponder()
            }
        }
    }
    
    func toggleToSignUp() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.photoPickerContainerView.isHidden = false
                self.statusIsSignUp = true
                self.usernamePasswordsSV.spacing = 8
                self.usernamePasswordsSV.alignment = .fill
                self.confirmPasswordTextField.isHidden = false
                self.logInButton.tintColor = .subtleText
                self.signUpButton.tintColor = .mainText
                self.signMeUpButton.setTitle("Sign Me Up!", for: .normal)
                self.helpButton.setTitle("Help", for: .normal)
                self.faqButton.setTitle("FAQ", for: .normal)
                self.usernameTextField.text = ""
                self.enterPasswordTextField.text = ""
                self.confirmPasswordTextField.text = ""
                self.usernameTextField.becomeFirstResponder()
            }
        }
    }
    
    func tempBypassOfLoginScreen() {
        UserController.shared.fetchUser(username: "brittani", password: "ILoveStuff") { (result) in
            switch result {
            case .success(let fetchedUser):
                UserController.shared.currentUser = fetchedUser
                self.presentHypFireVC()
            case .failure(let userError):
                print(userError.errorDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPickerVC" {
            let destinationVC = segue.destination as? PhotoPickerViewController
            destinationVC?.delegate = self
        }
    }
}

extension SignUpViewController: PhotoSelectorDelegate {
    func photoPickerSelected(image: UIImage) {
        self.image = image
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
