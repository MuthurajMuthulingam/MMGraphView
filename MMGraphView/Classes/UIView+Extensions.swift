//
//  UIView+Extensions.swift
//  MMGraphSample
//
//  Created by Muthuraj Muthulingam.
//  Copyright © 2018 Muthuraj Muthulingam. All rights reserved.
//

import UIKit

// MARK: - UIView Constraints
public extension UIView {
    public func setConstraintRelativeSize(relatedSuperView superView: UIView?, offset: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let leading = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: superView, attribute: .leading, multiplier: 1, constant: offset)
        let trailing = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: superView, attribute: .trailing, multiplier: 1, constant: -offset)
        let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1, constant: offset)
        let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1, constant: -offset)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
}
