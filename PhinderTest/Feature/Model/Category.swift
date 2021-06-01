//
//  Category.swift
//  PhinderTest
//
//  Created by Navneet Kaur on 6/1/21.
//

import Foundation

enum CategoryType: String, CaseIterable {
    case camera = "Camera"
    case photo = "Photo"
    case fullName = "Full name"
    case telephone = "Telephone number"
    case dob = "Date of birth"
    case gender = "Sex (Male / Female)"
    case favColor = "Favorite Color"
}

struct Category {
    var categoryType: CategoryType
    var isSelected: Bool = false
}
