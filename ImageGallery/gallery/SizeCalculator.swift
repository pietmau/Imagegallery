//
// Created by Maurizio Pietrantuono on 23/10/2018.
// Copyright (c) 2018 Maurizio Pietrantuono. All rights reserved.
//

import Foundation
import UIKit

class SizeCalculator {
    private let rows: CGFloat
    private let cols: CGFloat
    private var initialRatio: CGFloat = 1
    private var ratio: CGFloat = 1

    init(_ rows: Int = 5, _ cols: Int = 5) {
        self.rows = CGFloat(rows)
        self.cols = CGFloat(cols)
    }

    func calculateRatio(_ image: UIKit.UIImage) -> Float {
        return Float(image.size.height / image.size.width)
    }

    func getSize(_ imageRatio: Float, _ orientation: UIDeviceOrientation, _ bounds: CGRect?) -> CGSize {
        if (bounds == nil) {
            return CGSize(width: 0, height: 0)
        }
        let width = floor((bounds!.width / cols)) * ratio
        let height = width * CGFloat(imageRatio) * ratio
        return CGSize(width: width, height: height)
    }

    func onPinch(_ recognizer: UIPinchGestureRecognizer) {
        let scale: CGFloat = CGFloat(recognizer.scale)
        if (recognizer.state == UIGestureRecognizerState.ended) {
            ratio = initialRatio * scale
            initialRatio = initialRatio * scale
            return
        }
        if (recognizer.state == UIGestureRecognizerState.changed) {
            ratio = initialRatio * scale
            return
        }
    }
}
