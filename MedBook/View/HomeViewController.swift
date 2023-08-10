//
//  HomeViewController.swift
//  MedBook
//
//  Created by Yuvan Shankar on 08/08/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func tappedOnLogoutButton(_ sender: UIButton) {
        logoutUser()
    }
}

//MARK: - Private Methods
private extension HomeViewController {
    // Logout function
    func logoutUser() {
        
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        
        showAlertWithTimer(message: "Logged Out Successfully", duration: 1.0)
        
        navigateToLandingPage()
        
    }
    
    func navigateToLandingPage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "LandingViewController")
    
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                let navigationController = UINavigationController(rootViewController: homeVC)
                window.rootViewController = navigationController
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
