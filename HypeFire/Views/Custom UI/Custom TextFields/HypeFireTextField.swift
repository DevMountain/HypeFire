//
//  HypeFireTextField.swift
//  HypeFire
//
//  Created by Cameron Stuart on 7/11/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import UIKit

class HypeFireTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        setupPlaceholderText()
        updateFontTo(font: FontNames.latoRegular)
        self.addCornerRadius(radius: 10)
        self.addAccentBorder()
        self.textColor = .mainText
        self.backgroundColor = .spaceBlack
        self.layer.masksToBounds = true
    }
    
    func setupPlaceholderText() {
        let currentPlaceholder = self.placeholder
        self.attributedPlaceholder = NSAttributedString(string: currentPlaceholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.subtleText, NSAttributedString.Key.font: UIFont(name: FontNames.latoLight, size: 16)!])
    }
    
    func updateFontTo(font: String) {
        guard let size = self.font?.pointSize else { return }
        self.font = UIFont(name: font, size: size)
    }
}
