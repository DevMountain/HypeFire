//
//  HypeFireButton.swift
//  HypeFire
//
//  Created by Cameron Stuart on 7/11/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import UIKit

class HypeFireButton: UIButton {
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        updateFontTo(font: FontNames.latoRegular)
        self.setTitleColor(.mainText, for: .normal)
        self.backgroundColor = .greenAccent
        self.addCornerRadius()
    }
    
    func updateFontTo(font: String) {
        guard let size = self.titleLabel?.font.pointSize else { return }
        self.titleLabel?.font = UIFont(name: font, size: size)
    }
}
