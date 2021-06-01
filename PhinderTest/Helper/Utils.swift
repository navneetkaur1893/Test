//
//  Utils.swift
//  PhinderTest
//
//  Created by Navneet Kaur on 6/1/21.
//

import Foundation

class Utils {
    // MARK: - TextField Validations
    static func isValidName(_ input: String) -> Bool {
        let allowedCharacter = CharacterSet.letters
        let allowedCharacter1 = CharacterSet.whitespaces
        let characterSet = CharacterSet(charactersIn: input)
        return allowedCharacter.isSuperset(of: characterSet) || allowedCharacter1.isSuperset(of: characterSet)
    }
    
    static func isValidNumber(_ input: String) -> Bool {
        let allowedCharacter = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: input)
        return allowedCharacter.isSuperset(of: characterSet)
    }
}
