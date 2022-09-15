//
//  Factories.swift
//  Dictionary
//
//  Created by Matheus Xavier on 14/09/22.
//

import Foundation
import UIKit

class Factories {
    
    func inputContainerView(withImage image: UIImage, textField: UITextField) -> UIView {
        let view = UIView()
        let imgvw = UIImageView(image: image)
        imgvw.tintColor = .systemGray2
        view.addSubview(imgvw)
        view.setDimensions(height: 50, width: nil)
        imgvw.setDimensions(height: 24, width: 24)
        imgvw.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        view.addSubview(textField)
        textField.anchor(left: imgvw.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)

        let dividerView = UIView()
        dividerView.backgroundColor = .systemGray2
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingRight: 8, height: 0.7)
        
        return view
    }
    
    func textField(withPlaceholder placeholder: String, isSecure: Bool? = false) -> UITextField {
        let tf = UITextField()
        if let isSecure = isSecure {
            tf.isSecureTextEntry = isSecure
        }
        tf.tintColor = .systemGray2
        tf.textColor = .systemGray2
        tf.font = .systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        return tf
    }
    
    func attributedButton(_ firstPart: String,_ secondPart: String) -> UIButton {
        let btn = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        attributedTitle.append(NSMutableAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.systemGray2]))
        btn.setAttributedTitle(attributedTitle, for: .normal)
        return btn
    }
    
    func createAlert(withTitle title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default Action"), style: .default))
        return alert
    }
}
