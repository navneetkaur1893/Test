//
//  SelectedCategoriesViewModel.swift
//  PhinderTest
//
//  Created by Navneet Kaur on 6/1/21.
//

import UIKit

class SelectedCategoriesViewModel {
    
    // MARK: - Properties
    private let defaultRowCount = 1
    private var detailModel: CategoryDetails
    var reloadData: (() -> Void)?
    
    // MARK: - Init method
    init(value: [Category]) {
        detailModel = CategoryDetails(categories: value)
        fetchUserImage()
    }
    
    // Method to fetch image from the url
    func fetchUserImage() {
        DispatchQueue.global().async {
            let url = Constant.URL.profileUrl
            let downloadedImage = HTTPClient.shared.downloadImageFromURL(url) ?? UIImage(named: Constant.ImageName.user)
            DispatchQueue.main.async {
                let resizedImage = downloadedImage?.imageResize(sizeChange: CGSize(width: 300, height: 300))
                self.detailModel.photoImage = resizedImage
                self.reloadData?()
            }
        }
    }
    
    // MARK: - UITableView data
    func getTitleForHeader(for section: Int) -> String {
        return "  " + detailModel.categories[section].categoryType.rawValue
    }
    
    func getHeightForHeaderInSection(_ section: Int) -> CGFloat {
        return 40
    }
    
    func getHeightForRowAt(_ indexPath: IndexPath) -> CGFloat {
        return (indexPath.section == 0 || indexPath.section == 1) ? 114 : 44
    }
    
    func getNumberOfSections() -> Int {
        return detailModel.categories.count
    }
    
    func getNumberOfRows(for section: Int) -> Int {
        if detailModel.categories[section].categoryType == .gender {
            return detailModel.gender.options.count
        } else if detailModel.categories[section].categoryType == .favColor {
            return detailModel.favColor.options.count
        } else {
            return defaultRowCount
        }
    }
    
    // MARK: - Methods to get values from the model
    func getUserImage(for indexPath: IndexPath) -> UIImage? {
        let categoryType = detailModel.categories[indexPath.section].categoryType
        switch categoryType {
        case .camera:
            return detailModel.cameraImage
        case .photo:
            return detailModel.photoImage
        default:
            return nil
        }
    }
    
    func getUserTextValue(for indexPath: IndexPath) -> String {
        let categoryType = detailModel.categories[indexPath.section].categoryType
        switch categoryType {
        case .fullName:
            return detailModel.fullName
        case .telephone:
            return detailModel.telephone
        default:
            return ""
        }
    }
    
    func getUserDOB() -> String {
        return detailModel.dob
    }
    
    func getGenderOption(for row: Int) -> String {
        return detailModel.gender.options[row].rawValue
    }
    
    func getColorOption(for row: Int) -> String {
        return detailModel.favColor.options[row].rawValue
    }
    
    func getAccessoryType(for indexPath: IndexPath) -> UITableViewCell.AccessoryType {
        let categoryType = detailModel.categories[indexPath.section].categoryType
        switch categoryType {
        case .gender:
            return detailModel.gender.options[indexPath.row] == detailModel.gender.selected ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        case .favColor:
            return detailModel.favColor.options[indexPath.row] == detailModel.favColor.selected ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        default:
            return UITableViewCell.AccessoryType.none
        }
    }
    
    func getCategory(for indexPath: IndexPath) -> CategoryType {
        return detailModel.categories[indexPath.section].categoryType
    }
    
    // MARK: - Methods to update values in the model
    func setUserDOB(_ date: String) {
        detailModel.dob = date
        
        // Call block to reload tableview.
        self.reloadData?()
    }
    
    func setUserTextInput(_ value: String, _ categoryType: CategoryType) {
        switch categoryType {
        case .fullName:
            detailModel.fullName = value
        case .telephone:
            detailModel.telephone = value
        default: break
        }
        
        // Call block to reload tableview.
        self.reloadData?()
    }
    
    func setUserSelection(for indexPath: IndexPath) {
        let categoryType = detailModel.categories[indexPath.section].categoryType
        switch categoryType {
        case .gender:
            detailModel.gender.selected = GenderType.allCases[indexPath.row]
        case .favColor:
            detailModel.favColor.selected = ColorType.allCases[indexPath.row]
        default:
            break
        }
        
        // Call block to reload tableview.
        self.reloadData?()
    }
    
    func setUserCameraGalleryImage(_ image: UIImage) {
        DispatchQueue.main.async {
            let resizedImage = image.imageResize(sizeChange: CGSize(width: 300, height: 300))
            self.detailModel.cameraImage = resizedImage
            
            // Call block to reload tableview.
            self.reloadData?()
        }
    }
}
