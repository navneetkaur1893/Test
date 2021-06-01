//
//  UserTextTableViewCell.swift
//  PhinderTest
//
//  Created by Navneet Kaur on 6/1/21.
//

import UIKit

protocol UserTextDelegate: AnyObject {
    func didEnterText(value: String, for categoryType: CategoryType)
}

class UserTextTableViewCell: UITableViewCell, ReusableView, NibLoadableView {
    
    // MARK: - IBOutlet
    @IBOutlet weak var userTextField: UITextField!
    
    // MARK: - Properties
    weak var delegate: UserTextDelegate?
    var categoryType: CategoryType?
    var maximumTextLength = 10
    
    // MARK: - Methods
    func configureData(value: String, for categoryType: CategoryType) {
        self.categoryType = categoryType
        switch categoryType {
        case .fullName:
            self.userTextField.keyboardType = .alphabet
            maximumTextLength = 35
        case .telephone:
            self.userTextField.keyboardType = .numberPad
            maximumTextLength = 10
        default: break
        }
        
        if value == "" {
            self.userTextField.placeholder = "\(Constant.PlaceholderText.pleaseEnter) \(categoryType.rawValue.lowercased())"
        } else {
            self.userTextField.text = value
        }
    }
}

// MARK: - UITextFieldDelegate
extension UserTextTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else { return }
        guard let category = categoryType else { return }
        delegate?.didEnterText(value: text, for: category)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let preText = textField.text as NSString?,
              preText.replacingCharacters(in: range, with: string).count <= maximumTextLength else {
            return false
        }
        
        switch categoryType {
        case .fullName:
            return Utils.isValidName(string)
        case .telephone:
            return Utils.isValidNumber(string)
        default:
            return true
        }
    }
}
