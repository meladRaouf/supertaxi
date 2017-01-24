//
//  UIImage+ImageLoader.swift
//  ImageLoader
//
//  Created by Hirohisa Kawasaki on 10/28/15.
//  Copyright © 2015 Hirohisa Kawasaki. All rights reserved.
//

import Foundation
import UIKit

private let lock = NSRecursiveLock()

// MARK: Optimize image

extension UIImage {

    func adjusts(_ size: CGSize, scale: CGFloat, contentMode: UIViewContentMode) -> UIImage {
        lock.lock()
        defer { lock.unlock() }

        switch contentMode {
        case .scaleToFill:
            if size.width * scale > self.size.width || size.height * scale > self.size.height {
                return self
            }

            let fitSize = CGSize(width: size.width * scale, height: size.height * scale)
            return render(fitSize)
        case .scaleAspectFit:
            if size.width * scale > self.size.width || size.height * scale > self.size.height {
                return self
            }

            let downscaleSize = CGSize(width: self.size.width / scale, height: self.size.height / scale)
            let ratio = size.width/downscaleSize.width < size.height/downscaleSize.height ? size.width/downscaleSize.width : size.height/downscaleSize.height

            let fitSize = CGSize(width: downscaleSize.width * ratio * scale, height: downscaleSize.height * ratio * scale)
            return render(fitSize)
        case .scaleAspectFill:
            if size.width * scale > self.size.width || size.height * scale > self.size.height {
                return self
            }

            let downscaleSize = CGSize(width: self.size.width / scale, height: self.size.height / scale)
            let ratio = size.width/downscaleSize.width > size.height/downscaleSize.height ? size.width/downscaleSize.width : size.height/downscaleSize.height

            let fitSize = CGSize(width: downscaleSize.width * ratio * scale, height: downscaleSize.height * ratio * scale)
            return render(fitSize)
        default:
            return self
        }
    }

    func render(_ size: CGSize) -> UIImage {
        lock.lock()
        defer { lock.unlock() }

        if size.width == 0 || size.height == 0 {
            return self
        }

        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    static func decode(_ data: Data) -> UIImage? {
        lock.lock()
        defer { lock.unlock() }

        return UIImage(data: data)

    }
}
