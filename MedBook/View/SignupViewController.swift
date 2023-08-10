//
//  SignupViewController.swift
//  MedBook
//
//  Created by Yuvan Shankar on 08/08/23.
//

import UIKit

class SignupViewController: UIViewController {
    
    // Outlet Properties
    @IBOutlet weak var ibEmailTextField: BottomLineTextField!
    @IBOutlet weak var ibPasswordTextField: BottomLineTextField!
    @IBOutlet weak var ibLetsGoBtnHolderView: UIView!
    @IBOutlet weak var ibEightCharactersCheckBoxView: UIImageView!
    @IBOutlet weak var ibUpperCaseCheckBoxView: UIImageView!
    @IBOutlet weak var ibSpecialCharCheckBoxView: UIImageView!
    @IBOutlet weak var ibPickerView: UIPickerView!
    
    let apiRequest = APIRequest()
    var countryData: CountryInfo?
    var selectedCountryLabel: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuretheView()
        fetchCountry()
        configureViewGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - IB Actions
    @IBAction func tappedOnLetsGoButton(_ sender: UIButton) {
        guard let enteredEmail = ibEmailTextField.text else { return }
        
        guard isValidEmail(email: enteredEmail) else {
            alterMessageWithTitle(message: "Please enter the valid email id")
            return
        }
        
        guard let password = ibPasswordTextField.text else {
            self.alterMessageWithTitle(message: "Please enter the password", title: "Error")
            return
        }
        
        let validationMessages = validatePassword(password)
        
        if validationMessages.isEmpty {
            print("Password is valid")
            createUser(username: enteredEmail, password: password, country: selectedCountryLabel ?? "")
            // Optionally, you can handle successful sign-in here
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
            self.navigationController?.pushViewController(loginVC, animated: true)
            
        } else {
            for message in validationMessages {
                print(message)
                // Update UI to display each validation error message
                alterMessageWithTitle(message: "\(message)", title: "Error")
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - Private Methods
private extension SignupViewController {
    
    // Sign-up function
    func createUser(username: String, password: String, country: String) {
        let newUser = User(context: CoreDataStack.shared.context)
        newUser.username = username
        newUser.password = password
        newUser.country = country
        
        CoreDataStack.shared.saveContext()
    }
    
    func updateCheckboxes(_ validationMessages: [String]) {
        
        ibEightCharactersCheckBoxView.image = validationMessages.contains("Password must be at least 8 characters long") ? UIImage(systemName: "") : UIImage(systemName: "checkmark.square.fill")
        
        ibUpperCaseCheckBoxView.image = validationMessages.contains("Password must contain at least one uppercase letter") ? UIImage(systemName: "") : UIImage(systemName: "checkmark.square.fill")
        
        ibSpecialCharCheckBoxView.image = validationMessages.contains("Password must contain at least one special character") ? UIImage(systemName: "") : UIImage(systemName: "checkmark.square.fill")
    }
    
    func validatePassword(_ password: String) -> [String] {
        var validationMessages: [String] = []
        
        if password.count < 8 {
            validationMessages.append("Password must be at least 8 characters long")
        }
        
        let uppercaseRegex = ".*[A-Z].*"
        if !NSPredicate(format: "SELF MATCHES %@", uppercaseRegex).evaluate(with: password) {
            validationMessages.append("Password must contain at least one uppercase letter")
        }
        
        let specialCharRegex = ".*[!@#$%^&*()_+\\-=\\[\\]{};':\",./<>?].*"
        if !NSPredicate(format: "SELF MATCHES %@", specialCharRegex).evaluate(with: password) {
            validationMessages.append("Password must contain at least one special character")
        }
        
        return validationMessages
    }
    
    func isValidEmail(email: String) -> Bool {
        // Regular expression pattern to validate email format
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func configuretheView() {
        [ibEmailTextField, ibPasswordTextField].forEach { txtField in
            txtField?.delegate = self
            txtField?.bottomLineColor = UIColor("#B5B5B5")
            txtField?.bottomLineWidth = 2.0
        }
        
        [ibEightCharactersCheckBoxView, ibUpperCaseCheckBoxView, ibSpecialCharCheckBoxView].forEach { imgView in
            imgView.layer.cornerRadius = 4
            imgView.layer.borderWidth = 2.0
            imgView.layer.borderColor = UIColor.black.cgColor
        }
        
        ibLetsGoBtnHolderView.layer.cornerRadius = 12
        ibLetsGoBtnHolderView.layer.borderWidth = 1
        ibLetsGoBtnHolderView.layer.borderColor = UIColor("0A0A0A").cgColor
        
        ibPickerView.dataSource = self
        ibPickerView.delegate = self
    }
    
    func configureViewGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
}

//MARK: - API Request
private extension SignupViewController {
    func fetchCountry() {
        apiRequest.requestAPIInfo { [weak self] result in
            switch result {
            case .success(let data):
                self?.countryData = data
                DispatchQueue.main.async {
                    self?.ibPickerView.reloadAllComponents()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - TextField Delegate
extension SignupViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == ibEmailTextField {
            if let enteredEmail = ibEmailTextField.text {
                if isValidEmail(email: enteredEmail) {
                    
                } else {
                    // Invalid email format
                    self.alterMessageWithTitle(message: "Please enter a valid email id", title: "Error")
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = ibPasswordTextField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            let validationMessages = validatePassword(updatedText)
            updateCheckboxes(validationMessages)
        }
        return true
    }
}

 
//MARK: - PickerView Delegate and Data Source
extension SignupViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryData?.data?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let sortedCountryKeys = countryData?.data?.keys.sorted() ?? []
        let countryKey = sortedCountryKeys[row]
        return countryData?.data?[countryKey]?.country
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sortedCountryKeys = countryData?.data?.keys.sorted() ?? []
        let countryKey = sortedCountryKeys[row]
        selectedCountryLabel = "\(countryData?.data?[countryKey]?.country ?? "")"
    }
}
