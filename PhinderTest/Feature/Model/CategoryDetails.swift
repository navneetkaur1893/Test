//
//  CategoriesDetailModel.swift
//  PhinderTest
//
//  Created by Navneet Kaur on 6/1/21.
//

import UIKit

struct CategoryDetails {
    var cameraImage: UIImage? = nil
    var photoImage: UIImage? = nil
    var fullName: String = ""
    var telephone: String = ""
    var dob: String = ""
    var gender = Gender()
    var favColor = FavoriteColor()
    var categories: [Category]
}

enum GenderType: String, CaseIterable {
    case male = "Male"
    case female = "Female"
}

struct Gender {
    let options = GenderType.allCases
    var selected: GenderType? = nil
}

enum ColorType: String, CaseIterable {
    case blue = "Blue"
    case pink = "Pink"
    case green = "Green"
    case red = "Red"
    case gray = "Gray"
}

struct FavoriteColor {
    let options = ColorType.allCases
    var selected: ColorType? = nil
}
