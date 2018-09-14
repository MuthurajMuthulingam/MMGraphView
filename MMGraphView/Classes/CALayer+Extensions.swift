//
//  CALayer+Extensions.swift
//  MMGraphSample
//
//  Created by Muthuraj Muthulingam.
//  Copyright © 2018 Muthuraj Muthulingam. All rights reserved.
//

import UIKit

// MARK: - Custom Initializer to CAShape Layer
public extension CAShapeLayer {
    public convenience init(with path: CGPath, color: UIColor, fillColor: UIColor, lineWidth: CGFloat) {
        self.init()
        self.path = path
        self.strokeColor = color.cgColor
        self.lineWidth = lineWidth
        self.lineJoin = kCALineJoinRound
        self.lineCap = kCALineCapRound
        self.fillColor = fillColor.cgColor
    }
    
    public func applyShadow(color: UIColor, offSet: CGSize, opacity: Float, radius: CGFloat) {
        self.shadowColor = color.cgColor
        self.shadowOffset = offSet
        self.shadowOpacity = opacity
        self.shadowRadius = radius
    }
}

public extension CATextLayer {
    public convenience init(with bounds: CGRect, text: String?) {
        self.init()
        self.bounds = bounds
        self.string = text
    }
}

public extension CABasicAnimation {
    public convenience init(keyPath: String,
                     toValue: Any?,
                     fromValue: Any?,
                     duration: Double,
                     beginTime: Double = CACurrentMediaTime(),
                     timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn),
                     filMode: String = kCAFillModeForwards,
                     removeOnCompletion: Bool = false) {
        self.init(keyPath: keyPath)
        self.toValue = toValue
        self.beginTime = beginTime
        self.duration = duration
        self.timingFunction = timingFunction
        self.fillMode = filMode
        self.isRemovedOnCompletion = removeOnCompletion
    }
}

extension CGPoint: Comparable {
    public static func <(lhs: CGPoint, rhs: CGPoint) -> Bool {
        return lhs.x < rhs.x && lhs.y < rhs.y
    }
}

public extension Array where Element == CGPoint {
    private enum Axis {
        case x
        case y
    }
    
    private func minValue(axis: Axis) -> (minValue: CGFloat, point: CGPoint) {
        var minValue: CGFloat = .greatestFiniteMagnitude
        var minPoint: CGPoint = .zero
        for point in self {
            let value:CGFloat = (axis == .x) ? point.x : point.y
            if value < minValue {
                minValue = value
                minPoint = point
            }
        }
        return (minValue,minPoint)
    }
    
    private func maxValue(axis: Axis) -> (minValue: CGFloat, point: CGPoint) {
        var minValue: CGFloat = .leastNormalMagnitude
        var minPoint: CGPoint = .zero
        for point in self {
            let value:CGFloat = (axis == .x) ? point.x : point.y
            if value > minValue {
                minValue = value
                minPoint = point
            }
        }
        return (minValue,minPoint)
    }
    
    public func minYValue() -> (minValue: CGFloat, point: CGPoint) {
        return minValue(axis: .y)
    }
    
    public func maxYValue() -> (minValue: CGFloat, point: CGPoint) {
        return maxValue(axis: .y)
    }
    
    public func minXValue() -> (minValue: CGFloat, point: CGPoint) {
        return minValue(axis: .x)
    }
    
    public func maxXValue() -> (minValue: CGFloat, point: CGPoint) {
        return maxValue(axis: .x)
    }
}

