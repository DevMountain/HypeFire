//
//  HypeFireTableViewCell.swift
//  HypeFire
//
//  Created by Cameron Stuart on 7/13/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import UIKit

class HypeFireTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var cellsCustonView: UIView!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: HypeFireLabel!
    @IBOutlet weak var bodyTextLabel: HypeFireLabel!
    @IBOutlet weak var dateLabel: HypeFireLabelLight!
    
    //MARK: - Properties
    var hype: Hype? {
        didSet {
            profilePhotoImageView.image = nil
            self.backgroundColor = .spaceGray
            cellsCustonView.addCornerRadius(radius: 24)
            updateViews()
        }
    }
    
    //MARK: - Methods
    func updateViews() {
        guard let hype = self.hype else { return }
        UserController.shared.fetchUserProfileImage(authorID: hype.authorID) { (result) in
            switch result {
            case .success(let profileImage):
                DispatchQueue.main.async {
                    self.layoutIfNeeded()
                    self.profilePhotoImageView.image = profileImage
                    self.profilePhotoImageView.addCornerRadius(radius: self.profilePhotoImageView.frame.height / 2)
                    self.profilePhotoImageView.clipsToBounds = true
                    self.authorNameLabel.text = hype.authorUsername
                    self.bodyTextLabel.text = hype.body
                    self.dateLabel.text = hype.timestamp.dateAsString()
                }
            case .failure(let userError):
                print(userError.errorDescription)
            }
        }
    }
}
