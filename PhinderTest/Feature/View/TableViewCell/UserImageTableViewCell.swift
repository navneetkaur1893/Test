//
//  UserImageTableViewCell.swift
//  PhinderTest
//
//  Created by Navneet Kaur on 6/1/21.
//

import UIKit

class UserImageTableViewCell: UITableViewCell, ReusableView, NibLoadableView {
    
    // MARK: - IBOutlet
    @IBOutlet weak var userImageView: UIImageView!
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set imageview border color and width
        userImageView.setBorder(color: .black, width: 4)
        // Set imageview corner rounded
        userImageView.setCornerRounded()
    }
    
    // configure data in the cell
    func configureData(_ image: UIImage?) {
        if let userImage = image {
            userImageView.image = userImage
        } else {
            userImageView.image = UIImage(named: Constant.ImageName.user)
        }
    }
}
