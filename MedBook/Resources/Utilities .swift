//
//  Utilities .swift
//  MedBook
//
//  Created by Yuvan Shankar on 09/08/23.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") { cString.removeFirst() }
        
        if cString.count != 6 {
            self.init("ff0000") // return red color for wrong hex input
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}


class CustomButton: UIButton {
    
    // MARK: - Properties
    
    private let iconImageView = UIImageView()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupIconImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupIconImageView()
    }
    
    // MARK: - Setup
    
    private func setupIconImageView() {
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        // Set constraints to position the image view on the right side of the text
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: titleLabel!.trailingAnchor, constant: 8),
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            iconImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6) // Adjust the multiplier as needed
        ])
    }
    
    // MARK: - Public method to set the image
    
    func setIcon(_ image: UIImage?) {
        iconImageView.image = image
    }
}


class BottomLineTextField: UITextField {
    
    @IBInspectable var bottomLineColor: UIColor = .black
    @IBInspectable var bottomLineWidth: CGFloat = 1.0
    
    var doneButtonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - bottomLineWidth, width: self.frame.width, height: bottomLineWidth)
        bottomLine.backgroundColor = bottomLineColor.cgColor
        self.layer.addSublayer(bottomLine)
    }
    
    private func commonInit() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: false)
        
        inputAccessoryView = toolbar
    }
    
    @objc private func doneButtonTapped() {
          resignFirstResponder()
    }
}


extension UIViewController {
    func alterMessage(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func alterMessageWithTitle(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlertWithTimer(message: String, duration: TimeInterval) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            self.dismiss(animated: true)
        }
    }
}
