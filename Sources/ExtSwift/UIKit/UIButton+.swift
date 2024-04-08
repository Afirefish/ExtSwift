//
//  UIButton+.swift
//  ExtSwift
//
//  Created by Míng on 2024-04-08.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import UIKit

extension UIButton {
    public func setBackgroundColor(_ color: UIColor?, for state: State) {
        setImage(color.transform { UIImage.image(with: $0) }, for: state)
    }
}

extension UIButton {
    
    private func with(_ state: State, possible states: [State], closure: (_ state: State) -> Void) {
        closure(state)
        for each in states {
            let merged = State(rawValue: state.rawValue | each.rawValue)
            if merged != state {
                closure(merged)
            }
        }
    }
    
    public func setTitle(_ title: String?, for state: State, possible states: State...) {
        with(state, possible: states) { setTitle(title, for: $0) }
    }
    
    public func setTitleColor(_ color: UIColor?, for state: State, possible states: State...) {
        with(state, possible: states) { setTitleColor(color, for: $0) }
    }
    
    public func setTitleShadowColor(_ color: UIColor?, for state: State, possible states: State...) {
        with(state, possible: states) { setTitleShadowColor(color, for: $0) }
    }
    
    public func setAttributedTitle(_ title: NSAttributedString?, for state: State, possible states: State...) {
        with(state, possible: states) { setAttributedTitle(title, for: $0) }
    }
    
    public func setImage(_ image: UIImage?, for state: State, possible states: State...) {
        with(state, possible: states) { setImage(image, for: $0) }
    }
    
    public func setBackgroundColor(_ color: UIColor?, for state: State, possible states: State...) {
        with(state, possible: states) { setBackgroundColor(color, for: $0) }
    }
    
    public func setBackgroundImage(_ image: UIImage?, for state: State, possible states: State...) {
        with(state, possible: states) { setBackgroundImage(image, for: $0) }
    }
    
    public func setPreferredSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration?, forImageIn state: State, possible states: State...) {
        with(state, possible: states) { setPreferredSymbolConfiguration(configuration, forImageIn: $0) }
    }
}
