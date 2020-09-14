//
//  HypeFireLabel.swift
//  HypeFire
//
//  Created by Cameron Stuart on 7/11/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import UIKit

class HypeFireLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateFontTo(font: FontNames.latoRegular)
        self.textColor = .mainText
    }
    
    func updateFontTo(font: String) {
        let size = self.font.pointSize
        self.font = UIFont(name: font, size: size)
    }
}

class HypeFireLabelLight: HypeFireLabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateFontTo(font: FontNames.latoLight)
        self.textColor = .subtleText
    }
}

class HypeFireLabelBold: HypeFireLabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateFontTo(font: FontNames.latoBold)
    }
}
