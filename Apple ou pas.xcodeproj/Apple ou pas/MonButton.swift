//
//  MonButton.swift
//  Apple ou pas
//
//  Created by Ddales on 18/12/2019.
//  Copyright © 2019 Ddales. All rights reserved.
//

import UIKit

class MonButton: UIButton {
    
    func setup(string: String) {
        setLayer()
        setTitle(string, for: UIControl.State.normal)
        setTitleColor(.black, for: UIControl.State.normal)
    }
}
