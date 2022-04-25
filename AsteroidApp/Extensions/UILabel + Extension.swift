//
//  UILabel + extension.swift
//  AsteroidApp
//
//  Created by Михаил Малышев on 23.04.2022.
//

import Foundation
import UIKit

// MARK: - UILabel + Extension
extension UILabel {
    
    // покраска слова в красный в лэйбле
    func halfTextColorChange(fullText : String , changeText : String, fontForChangedText: CGFloat ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
        guard let font = UIFont(name: "Helvetica-Bold", size: fontForChangedText) else { return }
        attribute.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        self.attributedText = attribute
    }
}
