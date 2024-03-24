//
//  ESHitTestView.swift
//  ExtSwift
//
//  Created by Míng on 2024-01-26.
//  Copyright (c) 2024 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import UIKit

public class ESHitTestView: UIView {
    
    public var hitTestClosure: ((UIView?, CGPoint, UIEvent?) -> UIView?)?
    
    public init(hitTestClosure: ((UIView?, CGPoint, UIEvent?) -> UIView?)? = nil) {
        self.hitTestClosure = hitTestClosure
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if let hitTestClosure {
            return hitTestClosure(hitView, point, event)
        }
        return hitView == self ? nil : hitView
    }
}
