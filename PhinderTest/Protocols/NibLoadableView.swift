//
//  NibLoadableView.swift
//  PhinderTest
//
//  Created by Navneet Kaur on 6/1/21.
//

import UIKit
import Foundation

protocol NibLoadableView: AnyObject {
    /// Represents the class name of a xib file
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    /// Set the nib name to be equal to the class name
    static var nibName: String {
        return String(describing: self)
    }
}

extension NibLoadableView where Self: UIViewController {
    /// Set the nib name to be equal to the class name
    static var nibName: String {
        return String(describing: self)
    }
}
