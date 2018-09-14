//
//  MMGraphView+Utilities.swift
//  MMGraphSample
//
//  Created by Muthuraj Muthulingam.
//  Copyright © 2018 Muthuraj Muthulingam. All rights reserved.
//

import UIKit

// MARK: - MMGraphView Helper Utitlity
extension MMGraphView {
    private func yAxisPoints(from points: [CGFloat]) -> [CGFloat] {
        var yAxisPoints = [CGFloat]()
        let maxValue: CGFloat = points.max() ?? 0
        var divideCoef = self.frame.size.height - (offSet*2)
        if (self.frame.size.height - (offSet*2)) < maxValue {
            divideCoef = maxValue
        }
        for i in points {
            let val = ((divideCoef - CGFloat(i))/divideCoef) * (self.frame.height - (offSet*2))
            yAxisPoints.append(val)
        }
        return yAxisPoints
    }
    
    private func xAxisPoints(from points: [CGFloat]) -> [CGFloat] {
        var xAxisPoints = [CGFloat]()
        for i in 0..<points.count {
            let val = (CGFloat(i)/CGFloat(points.count)) * (self.frame.width - (offSet*2))
            xAxisPoints.append(val)
        }
        return xAxisPoints
    }
    
    private func normalise(against value: CGFloat, points: [CGFloat]) -> [CGFloat] {
        guard !points.isEmpty else  { return [] }
        let maxValue = points.max() ?? 0
        let normalisedPoints = points.map { point in
            return (point/maxValue)*value
        }
        return normalisedPoints
    }
    
    func getGraphPoints(from points: [CGPoint]) -> [CGPoint] {
        let xPoints = points.map{ point in
            return point.x
        }
        let yPoints = points.map { point in
            return point.y
        }
        let normaliseXAxisPoints = normalise(against: self.frame.size.width - (offSet*2), points: xPoints)
        let normaliseYAxisPoints = normalise(against: self.frame.size.height - (offSet*4), points: yPoints)
        let xAxisPoints = self.xAxisPoints(from: normaliseXAxisPoints)
        let yAxisPoints = self.yAxisPoints(from: normaliseYAxisPoints)
        var graphPoints: [CGPoint] = []
        for i in 0..<xPoints.count {
            graphPoints.append(CGPoint(x: xAxisPoints[i], y: yAxisPoints[i]))
        }
        return graphPoints
    }
}

//MARK: - MMGraph Configuaration Rules
public protocol MMGraphConfigurationRules {
    var shouldAnimate: Bool { get set }
    var showAllPoints: Bool { get set }
    var showsTextInfo: Bool { get set }
}

public struct MMGraphConfiguration: MMGraphConfigurationRules {
    public var shouldAnimate: Bool = true
    public var showAllPoints: Bool = false
    public var showsTextInfo: Bool = true
    
    public init(){
        
    }
}

// MARK: - MMGraphe Theme Helper
// MARK: - MMGraph Theme Rules
public protocol MMShadowRules {
    var color: UIColor { get set }
    var opacity: Float { get set }
    var offSet: CGSize { get set }
    var radius: Double { get set }
}

public struct MMGraphShadow: MMShadowRules {
    public var color: UIColor
    public var opacity: Float
    public var offSet: CGSize
    public var radius: Double
    
    public init(color: UIColor, opacity: Float, offSet: CGSize, radius: Double) {
        self.color = color
        self.opacity = opacity
        self.offSet = offSet
        self.radius = radius
    }
}

public protocol MMGraphTextThemeRules {
    var color: UIColor { get set }
    var font: UIFont { get set }
}

public struct MMGraphTextTheme: MMGraphTextThemeRules {
    public var color: UIColor = UIColor.white
    public var font: UIFont = UIFont.systemFont(ofSize: 10)
    
    public init(color: UIColor, font: UIFont) {
        self.color = color
        self.font = font
    }
    
    public init() {
        // default initializer
    }
}

public protocol MMGraphThemeShadowRules {
    var shadow: MMGraphShadow? { get set }
}

public protocol MMGraphLineThemeRules: MMGraphThemeShadowRules {
    var lineColor: UIColor { get set }
    var lineWidth: CGFloat { get set }
}

public struct MMGraphLineTheme: MMGraphLineThemeRules {
    public var lineWidth: CGFloat = 4.0
    public var shadow: MMGraphShadow? = MMGraphShadow(color: UIColor.black, opacity: 0.5, offSet: CGSize(width: 0, height: 8), radius: 6.0)
    public var lineColor: UIColor = UIColor.yellow
    
    public init() {
        // default initializer
    }
    
    public init(lineWidth: CGFloat, shadow: MMGraphShadow?, lineColor: UIColor) {
        self.lineWidth = lineWidth
        self.shadow = shadow
        self.lineColor = lineColor
    }
}

public protocol MMGraphDotThemeRules: MMGraphThemeShadowRules {
    var fillColor: UIColor { get set }
    var borderWidth: CGFloat { get set }
    var contents: Any? { get set }
}

public struct MMGraphDotCircleTheme: MMGraphDotThemeRules {
    public var contents: Any? = nil
    public var fillColor: UIColor = UIColor.clear
    public var borderWidth: CGFloat = 0.0
    public var shadow: MMGraphShadow? = MMGraphShadow(color: UIColor.black, opacity: 0.7, offSet: CGSize(width: 0, height: 2), radius: 3.0)
    
    public init() {
        // default initializer
    }
    
    public init(content: Any?, fillColor: UIColor, borderWidth: CGFloat, shadow: MMGraphShadow?) {
        self.contents = content
        self.fillColor = fillColor
        self.borderWidth = borderWidth
        self.shadow = shadow
    }
}

public protocol MMGraphInfoThemeRules {
    var dotCircleTheme: MMGraphDotCircleTheme { get set }
    var textTheme: MMGraphTextTheme { get set }
    var padding: CGFloat { get set }
}

public struct MMGraphInfoTheme: MMGraphInfoThemeRules {
    public var dotCircleTheme: MMGraphDotCircleTheme = MMGraphDotCircleTheme()
    public var textTheme: MMGraphTextTheme = MMGraphTextTheme()
    public var padding: CGFloat = 15
    
    public init() {
        // default initialiser
    }
    
    public init(dotCircleTheme: MMGraphDotCircleTheme, textTheme: MMGraphTextTheme, padding: CGFloat) {
        self.dotCircleTheme = dotCircleTheme
        self.textTheme = textTheme
        self.padding = padding
    }
}

public protocol MMGraphThemeRules {
    var lineTheme: MMGraphLineTheme? { get set }
    var infoTheme: MMGraphInfoTheme? { get set }
    var backgroundColor: UIColor { get set }
    var backgroundImage: UIImage? { get set }
    var graphPadding: CGFloat { get set }
}

public struct MMGraphTheme: MMGraphThemeRules {
    public var infoTheme: MMGraphInfoTheme? = MMGraphInfoTheme()
    public var graphPadding: CGFloat = 30 // default
    public var backgroundColor: UIColor = UIColor.clear
    public var backgroundImage: UIImage? = nil
    public var lineTheme: MMGraphLineTheme? = MMGraphLineTheme()
    
    public init() {
        // default initialiser
    }
    
    public init(infoTheme: MMGraphInfoTheme?, graphPadding: CGFloat, backgroundColor: UIColor, backgroundImage: UIImage?, lineTheme: MMGraphLineTheme) {
        self.infoTheme = infoTheme
        self.graphPadding = graphPadding
        self.backgroundColor = backgroundColor
        self.backgroundImage = backgroundImage
        self.lineTheme = lineTheme
    }
}

// MARK: - Shadow Theme Extensions
public extension MMGraphShadow {
    fileprivate func apply(to layer: CAShapeLayer) {
        layer.applyShadow(color: self.color, offSet: self.offSet, opacity: self.opacity, radius: CGFloat(self.radius))
    }
}

public extension MMGraphDotCircleTheme {
    public func apply(to layer: CAShapeLayer) {
        self.shadow?.apply(to: layer)
        if let image = self.contents as? UIImage {
           layer.contents = image.cgImage
            layer.rasterizationScale = UIScreen.main.scale
           layer.contentsGravity = kCAGravityResizeAspectFill
           layer.bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        } else {
           layer.fillColor = self.fillColor.cgColor
            layer.borderWidth = self.borderWidth
        }
    }
}

public extension MMGraphLineTheme {
    public func apply(to layer: CAShapeLayer) {
        layer.strokeColor = lineColor.cgColor
        layer.lineWidth = lineWidth
        shadow?.apply(to: layer)
    }
}

extension MMGraphTextTheme {
    public func apply(to textLayer: CATextLayer) {
        textLayer.fontSize = self.font.pointSize
        textLayer.font = self.font
        textLayer.foregroundColor = self.color.cgColor
    }
}

private let kStrokeAnimationKey = "StrokeAnimationKey"
private let kFadeAnimationKey = "FadeAnimationKey"

// MARK: - Graphview Animation related Extensions
public extension MMGraphView {

    public func animateLayers() {
        animatePoints()
        animateLine()
        animateText()
    }
    
    private func animatePoints() {
        var delay = 0.2
        for point in pointLayers {
            let fadeAnimation = prepareFadeAnimation(with: CACurrentMediaTime() + delay)
            point.add(fadeAnimation, forKey: kFadeAnimationKey)
            delay += 0.15
        }
    }
    
    private func animateText() {
        var delay = 0.2
        textLayers.forEach { textLayer in
            let fadeAnimation = prepareFadeAnimation(with: CACurrentMediaTime() + delay)
            textLayer.add(fadeAnimation, forKey: kFadeAnimationKey)
            delay += 0.15
        }
    }
    
    private func prepareFadeAnimation(with beginTime: Double) -> CABasicAnimation {
        return CABasicAnimation(keyPath: "opacity",
                                toValue: 1,
                                fromValue: nil,
                                duration: 0.2,
                                beginTime: beginTime,
                                timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                                filMode: kCAFillModeForwards,
                                removeOnCompletion: false)
    }
    
    private func animateLine() {
        let linePathAnimation = CABasicAnimation(keyPath: "strokeEnd",
                                                 toValue: 1,
                                                 fromValue: nil,
                                                 duration: 1.5,
                                                 beginTime: CACurrentMediaTime() + 0.5,
                                                 timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn),
                                                 filMode: kCAFillModeForwards,
                                                 removeOnCompletion: false)
        lineLayer.add(linePathAnimation, forKey: kStrokeAnimationKey)
    }
}

public protocol MMGraphViewRules {
    func drawGraph(using points: [CGPoint], configuration: MMGraphConfiguration)
    func setTheme(_ theme: MMGraphTheme)
}

