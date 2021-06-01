//
//  ReusableView.swift
//  PhinderTest
//
//  Created by Navneet Kaur on 6/1/21.
//

import UIKit

protocol ReusableView: AnyObject {
    /// Represents the reusesable identifier for a cell
    static var reuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    /// Set the reuse identifier to be equal to the class name
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
