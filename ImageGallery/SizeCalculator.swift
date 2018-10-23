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
        return Float(image.size.width / image.size.height)
    }


    func getSize(_ ratio: Float, _ orientation: UIDeviceOrientation, _ bounds: CGRect) -> CGSize {
        let width = bounds.width / cols
        let height = width * CGFloat(ratio)
        return CGSize(width: width, height: height)
    }
}
