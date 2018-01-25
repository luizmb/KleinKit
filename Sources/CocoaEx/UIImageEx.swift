//
//  UIImageEx.swift
//  KleinKit
//
//  Created by Luiz Rodrigo Martins Barbosa on 25.01.18.
//

import UIKit

extension UIImage {
    public func resize(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let destImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return destImage
    }

    public func resizeToSquare(sizeLength: Float) -> UIImage {
        return resize(to: CGSize(width: CGFloat(sizeLength),
                                 height: CGFloat(sizeLength)))
    }
}
