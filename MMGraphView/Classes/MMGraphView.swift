//
//  MMGraph.swift
//  MMGraphSample
//
//  Created by Muthuraj Muthulingam.
//  Copyright © 2018 Muthuraj Muthulingam. All rights reserved.
//

import UIKit

// MARK: - MMGraph Concrete Class
@IBDesignable
public class MMGraphView: UIView {
    
    // MARK: - Private Properties
    private lazy var currentPoints: [CGPoint] = []
    private var currentTheme: MMGraphTheme = MMGraphTheme() {
        didSet {
            // redraw graph
           layoutIfNeeded()
           // set background
            graphView.backgroundColor = currentTheme.backgroundColor
            if let bgImage = currentTheme.backgroundImage {
                graphView.backgroundColor = UIColor(patternImage: bgImage)
            }
            
            offSet = currentTheme.graphPadding
        }
    }
    private lazy var rawPoints: [CGPoint] = []
    private lazy var configuaration: MMGraphConfiguration = MMGraphConfiguration()
    private lazy var graphView: UIView = UIView()
    var offSet: CGFloat = 30 // default
    lazy var pointLayers = [CAShapeLayer]()
    lazy var textLayers = [CATextLayer]()
    lazy var lineLayer = CAShapeLayer()
    
    // MARK: - IBInspectables
    @IBInspectable var color: UIColor = UIColor.green {
        didSet {
            drawGraph(using: self.currentPoints)
        }
    }
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareGraphView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareGraphView()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        // remove existing layers
        graphView.layer.sublayers?.forEach({ (layer: CALayer) -> () in
            layer.removeFromSuperlayer()
        })
        pointLayers.removeAll()
        textLayers.removeAll()
        guard !currentPoints.isEmpty else {
            return
        }
        drawLines()
        drawPoints()
        animateLayers()
    }
    
    // MARK: - Private Helpers
    private func drawPoints() {
        if configuaration.showAllPoints { // show all the points
            circleDots(from: currentPoints)
        } else  { // show only highest point
                let minYValue = currentPoints.minYValue()
                circleDots(from: [minYValue.point])
        }
    }
    
    private func circleDots(from points: [CGPoint]) {
        
        func showTextLayerIfNeeded(on point: CGPoint, index: Int) {
            if configuaration.showsTextInfo {
                let rawPoint = rawPoints[index]
                let textLayer = CATextLayer(with: CGRect(x: 0, y: 0, width: 120, height: 50),
                                            text: "\(rawPoint.y)")
                
                textLayer.fontSize = 10
                textLayer.font = UIFont.preferredFont(forTextStyle: .headline)
                currentTheme.infoTheme?.textTheme.apply(to: textLayer)
                let yPos = point.y - (currentTheme.infoTheme?.padding ?? 10)
                textLayer.position = CGPoint(x: point.x + 50, y: yPos)
                graphView.layer.addSublayer(textLayer)
                
                if configuaration.shouldAnimate {
                    textLayer.opacity = 0
                    textLayers.append(textLayer)
                }
            }
        }
        
        for (index, point) in points.enumerated() {
            let dotCircleLayer = CAShapeLayer(with: UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 12, height: 12)).cgPath,
                                              color: UIColor.clear,
                                              fillColor: UIColor(white: 248.0/255.0, alpha: 0.5),
                                              lineWidth: 0.0)
            dotCircleLayer.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
            dotCircleLayer.position = point
            currentTheme.infoTheme?.dotCircleTheme.apply(to: dotCircleLayer)
            graphView.layer.addSublayer(dotCircleLayer)
            
            if configuaration.shouldAnimate {
                dotCircleLayer.opacity = 0
                pointLayers.append(dotCircleLayer)
            }
            
            // show TextLayer if needed
            showTextLayerIfNeeded(on: point, index: index)
        }
    }

    private func prepareGraphView() {
        graphView.backgroundColor = UIColor.red
        self.addSubview(graphView)
        // set consstriants
        graphView.setConstraintRelativeSize(relatedSuperView: self, offset: offSet)
    }
    
    private func drawLines() {
        guard !currentPoints.isEmpty else {
            return
        }
        
        let controlPoints = CubicCurveUtility.controlPointsFromPoints(dataPoints: currentPoints)
        let linePath = UIBezierPath()
        for i in 0..<currentPoints.count {
            let point = currentPoints[i]
            if i==0 {
                linePath.move(to: point)
            } else {
                let segment = controlPoints[i-1]
                linePath.addCurve(to: point, controlPoint1: segment.controlPoint1, controlPoint2: segment.controlPoint2)
            }
        }
        linePath.lineCapStyle = .round
        lineLayer = CAShapeLayer(with: linePath.cgPath, color: color, fillColor: UIColor.clear, lineWidth: 4.0)
        currentTheme.lineTheme?.apply(to: lineLayer)
        graphView.layer.addSublayer(lineLayer)
        
        if configuaration.shouldAnimate {
            lineLayer.strokeEnd = 0
        }
    }
}

extension MMGraphView: MMGraphViewRules {
    // MARK: - Public Helpers
    public func drawGraph(using points: [CGPoint], configuration: MMGraphConfiguration = MMGraphConfiguration()) {
        self.configuaration = configuration
        self.rawPoints = points
        self.currentPoints = self.getGraphPoints(from: points)
    }
    
    public func setTheme(_ theme: MMGraphTheme) {
        self.currentTheme = theme
    }
}

extension CGFloat {
    var f: Double {
        return Double(self)
    }
}
