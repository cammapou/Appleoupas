//
//  extensionView.swift
//  Apple ou pas
//
//  Created by Ddales on 18/12/2019.
//  Copyright © 2019 Ddales. All rights reserved.
//

import UIKit

extension UIView {
    
    func setLayer() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.75
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 10, height: 10)
    }
}
