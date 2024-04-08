//
//  KVO.swift
//  ExtSwift
//
//  Created by Míng on 2021-03-03.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

/// Key-Value Observing

@propertyWrapper
public class KVO<ValueType> {
    
    // MARK: property-wrapper
    
    public var projectedValue: KVO<ValueType> { self }
    
    public var wrappedValue: ValueType {
        willSet {
            let removing = observers.filter { observer in
                return observer.options.contains(.willSet) && observer.closure(newValue, wrappedValue, .willSet) == .stop
            }
            observers.removeAll { observer in
                return removing.contains { $0 === observer }
            }
        }
        didSet {
            let removing = observers.filter { observer in
                return observer.options.contains(.didSet) && observer.closure(wrappedValue, oldValue, .didSet) == .stop
            }
            observers.removeAll { observer in
                return removing.contains { $0 === observer }
            }
            if !keepEventState {
                wrappedValue = oldValue
            }
        }
    }
    
    private var keepEventState: Bool
    
    fileprivate init(wrappedValue: ValueType, keepEventState: Bool = true) {
        self.wrappedValue = wrappedValue
        self.keepEventState = keepEventState
    }
    
    public convenience init(wrappedValue: ValueType) {
        self.init(wrappedValue: wrappedValue, keepEventState: true)
    }
    
    // MARK: observers
    
    public enum ObservingState {
        case keep, stop
    }
    
    private var observers: [Observer<ValueType>] = []
    
    private final class Observer<_ValueType>: ObserverProtocol {
        
        weak var propertyWrapper: KVO?
        let options: ObservingOptions
        let closure: (_ newValue: _ValueType, _ oldValue: _ValueType, _ option: ObservingOptions) -> ObservingState
        
        init(propertyWrapper: KVO, options: ObservingOptions, closure: @escaping (_ newValue: _ValueType, _ oldValue: _ValueType, _ option: ObservingOptions) -> ObservingState) {
            self.propertyWrapper = propertyWrapper
            self.options = options
            self.closure = closure
        }
        
        func isObserving() -> Bool {
            return propertyWrapper?.observers.contains { $0 === self } ?? false
        }
        
        func stopObserving() {
            propertyWrapper?.removeObserver(self)
        }
    }
    
    @discardableResult
    public func addObserver(options: ObservingOptions = .default, using closure: @escaping (_ newValue: ValueType, _ oldValue: ValueType, _ option: ObservingOptions) -> ObservingState) -> ObserverProtocol {
        let observer = Observer(propertyWrapper: self, options: options, closure: closure)
        if !options.contains(.initial) || closure(wrappedValue, wrappedValue, .initial) == .keep {
            observers.append(observer)
        }
        return observer
    }
    
    public func keepObserver(options: ObservingOptions = .default, using closure: @escaping (_ newValue: ValueType, _ oldValue: ValueType, _ option: ObservingOptions) -> Void) {
        addObserver(options: options) { newValue, oldValue, option in
            closure(newValue, oldValue, option)
            return .keep
        }
    }
    
    public func removeObserver(_ observer: ObserverProtocol) {
        observers.removeAll { $0 === observer }
    }
}

// MARK: - ExtKVO

@propertyWrapper
public final class ExtKVO<ValueType>: KVO<ValueType> {
    
    public override var projectedValue: ExtKVO<ValueType> { self }
    
    public override var wrappedValue: ValueType {
        get { super.wrappedValue }
        set { super.wrappedValue = newValue }
    }
    
    public override init(wrappedValue: ValueType, keepEventState: Bool = false) {
        super.init(wrappedValue: wrappedValue, keepEventState: keepEventState)
    }
    
    public convenience init(wrappedValue: ValueType) {
        self.init(wrappedValue: wrappedValue, keepEventState: false)
    }
    
    @discardableResult
    public func addObserver(using closure: @escaping (_ value: ValueType) -> ObservingState) -> ObserverProtocol {
        return super.addObserver(options: .didSet) { value, oldValue, option -> ObservingState in
            return closure(value)
        }
    }
    
    public func keepObserver(using closure: @escaping (_ value: ValueType) -> Void) {
        super.addObserver(options: .didSet) { value, oldValue, option -> ObservingState in
            closure(value)
            return .keep
        }
    }
    
    @available(*, unavailable)
    public override func addObserver(options: ObservingOptions = .default, using closure: @escaping (_ newValue: ValueType, _ oldValue: ValueType, _ option: ObservingOptions) -> ObservingState) -> ObserverProtocol {
        fatalError()
    }
    
    @available(*, unavailable)
    public override func keepObserver(options: ObservingOptions = .default, using closure: @escaping (_ newValue: ValueType, _ oldValue: ValueType, _ option: ObservingOptions) -> Void) {
        fatalError()
    }
}

// MARK: - supports

// when move into KVO: "Static stored properties not supported in generic types"
public struct ObservingOptions: OptionSet, CustomStringConvertible {
    
    public static let initial = ObservingOptions(rawValue: 1 << 0) // value
    public static let willSet = ObservingOptions(rawValue: 1 << 1) // value + oldValue
    public static let didSet  = ObservingOptions(rawValue: 1 << 2) // value + oldValue
    
    public static let `default`: ObservingOptions = [.initial, .didSet]
    
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public var description: String {
        var strings: [String] = []
        if self.contains(.initial) { strings.append("initial") }
        if self.contains(.willSet) { strings.append("willSet") }
        if self.contains(.didSet)  { strings.append("didSet") }
        return strings.joined(separator: "|")
    }
}

public protocol ObserverProtocol: AnyObject {
    func isObserving() -> Bool
    func stopObserving()
}
