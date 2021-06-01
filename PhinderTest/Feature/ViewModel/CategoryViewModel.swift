//
//  CategoryViewModel.swift
//  PhinderTest
//
//  Created by Navneet Kaur on 6/1/21.
//

import UIKit

class CategoryViewModel {
    
    // MARK: - Properties
    private var categories: [Category] = CategoryType.allCases.compactMap({ Category(categoryType: $0) })
    
    // MARK: - Methods
    func getSelectedCategoriesViewModel() -> SelectedCategoriesViewModel {
        return SelectedCategoriesViewModel(value: categories.filter({ $0.isSelected }))
    }
    
    // MARK: - UITableView data
    func getAccessoryType(for indexPath: IndexPath) -> UITableViewCell.AccessoryType {
        return categories[indexPath.row].isSelected ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
    }
    
    func getNumberOfRows() -> Int {
        return categories.count
    }
    
    func getCategory(for indexPath: IndexPath) -> CategoryType {
        return categories[indexPath.row].categoryType
    }
    
    func getSelectedCategoriesCount() -> Int {
        return categories.filter({ $0.isSelected }).count
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        categories[indexPath.row].isSelected.toggle()
    }
}
