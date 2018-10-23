//
// Created by Maurizio Pietrantuono on 23/10/2018.
// Copyright (c) 2018 Maurizio Pietrantuono. All rights reserved.
//

import Foundation
import UIKit

class SizeCalculator {
    private var rows: CGFloat
    private var cols: CGFloat

    init(_ rows: Int, _ cols: Int) {
        self.rows = CGFloat(rows)
        self.cols = CGFloat(cols)
    }

    func calculateRatio(_ image: UIKit.UIImage) -> Float {
        return Float(image.size.height / image.size.width)
    }


    func getSize(_ ratio: Float, _ orientation: UIDeviceOrientation, _ bounds: CGRect?) -> CGSize {
        if (bounds == nil) {
            return CGSize(width: 0, height: 0)
        }
        print("screen width \(bounds!.width) ")
        let width = floor((bounds!.width / cols))
        print(" width \(width) ")
        let height = width * CGFloat(ratio)
        print(" height \(height) ")
        return CGSize(width: width, height: height)
    }
}
