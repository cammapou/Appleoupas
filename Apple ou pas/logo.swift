//
//  logo.swift
//  Apple ou pas
//
//  Created by Ddales on 18/12/2019.
//  Copyright © 2019 Ddales. All rights reserved.
//

import UIKit

class Logo {
    
    private var _appleImage: [UIImage?] = [UIImage(named: "apple 1"), UIImage(named: "apple 2")]
    private var _autreImage: [UIImage?] = [UIImage(named: "android"), UIImage(named: "windows")]
    private var _image: UIImage?
    private var _isapple: Bool
    
    var image: UIImage? {
        get {
            return _image
        }
    }
    
    var isApple: Bool {
        get {
            return _isapple
        }
    }
    
    init(bool: Bool) {
        self._isapple = bool
        let random = Int.random(in: 0...1)
        self._image = _isapple ? _appleImage[random] : _autreImage[random]
        
    }
}
