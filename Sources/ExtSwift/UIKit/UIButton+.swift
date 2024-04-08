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
        /// state:    0b xxxx 0100 // 任意个 1，一般只有 1 个
        /// all:      0b 0... 1111 // 后半段全是 1
        /// states:   0b 0... 1010 // 有若干个 1
        /// optional: 0b 0... 0001 // 只有 1 个 1
        /// 基于上面取值：
        /// 除 state 本身的 0100 之外，
        /// 当 optional 为 0010、1000 时（与 states 存在并集），
        /// 将 state 与 optional 取合计得到 0110、1100，
        /// 排除与 state 相等的值（这里没有），
        /// 回调
        closure(state) /// 对 state 回调
        let all = ~(State.application.rawValue | State.reserved.rawValue)
        var states: UInt = states.reduce(0) { $0 | $1.rawValue },
            optional: UInt = 1
        while states & all != 0 { /// 只要 states 中还有 1
            if states & optional != 0 { /// 如果 states 和 optional 有相同位置的 1
                let merged = State(rawValue: state.rawValue | optional) /// 合并 state 和 optional
                if merged != state { /// 避免对 state 状态回调，导致重复设置
                    closure(merged) /// 对 states.map { state | $0 } 回调
                }
                states &= ~optional /// 从 states 中去掉 optional 中的 1
            }
            /// optional 中的 1 从最右端开始左移，直到清理掉 states 中所有的 1
            optional <<= 1
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
