//
//  MonLabel.swift
//  Apple ou pas
//
//  Created by Ddales on 31/12/2019.
//  Copyright © 2019 Ddales. All rights reserved.
//

import UIKit


class MonLabel : UILabel {
    
    private var _font: UIFont = UIFont.systemFont(ofSize: 22)
    private var _color: UIColor = UIColor.white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setUp() {
        textColor = _color
        numberOfLines = 0
        textAlignment = .center
        adjustsFontSizeToFitWidth = true
        font = _font
        updateText(nil, nil)
    }

    func updateText(_ tempsRestant: Int?, _ score: Int?) {
        let texte = "Est-ce un logo Apple ?"
        if tempsRestant == nil && score == nil {
            text = texte
        } else {
            let attributes = NSMutableAttributedString(
                string: texte + "\n",
                attributes: [
                    NSAttributedString.Key.foregroundColor: _color,
                    NSAttributedString.Key.font: _font
            ])
            attributes.append(NSAttributedString(
                string: "Temps restant: \(tempsRestant!) - Scrore: \(score!)",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.red,
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)
            ]))
            attributedText = attributes
        }
    }
}
