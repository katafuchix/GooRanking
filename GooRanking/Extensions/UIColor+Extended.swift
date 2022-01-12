//
//  UIColor+Extended.swift
//  GooRanking
//
//  Created by cano on 2018/12/15.
//  Copyright © 2018 deskplate. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    var image: UIImage? {
        return self.generateImage(CGSize(width: 1, height: 1))
    }

    func generateImage(_ size: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        UIGraphicsBeginImageContext(rect.size)

        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(self.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    static func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(
            red: (red < 0 ? 0 : red) / 255,
            green: (green < 0 ? 0 : green) / 255,
            blue: (blue < 0 ? 0 : blue) / 255,
            alpha: alpha < 0 ? 0 : alpha)
    }
}

