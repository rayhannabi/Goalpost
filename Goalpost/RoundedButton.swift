//
//  RoundedButton.swift
//  Goalpost
//
//  Created by Rayhan on 9/1/17.
//  Copyright © 2017 Rayhan. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    override func awakeFromNib() {
        customizeView()
    }
    
    func customizeView() {
        clipsToBounds = true
        layer.cornerRadius = 20
    }
}
