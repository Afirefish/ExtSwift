//
//  Optional+opt.swift
//  ExtSwift
//
//  Created by Míng on 2023-12-20.
//  Copyright (c) 2023 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

public extension Optional {
    func transform<U>(_ transform: (Wrapped) throws -> U?) rethrows -> U? {
        guard case let .some(wrapped) = self else { return nil }
        return try transform(wrapped)
    }
}

/// Check whether value/type is Optional, get Wrapped Type
/// - seealso: https://forums.swift.org/t/challenge-finding-base-type-of-nested-optionals/25096/2
/// - seealso: https://stackoverflow.com/a/32781143/456536

// !!!: MUST be `fileprivate`
fileprivate protocol OptionalProtocol {
    static var deeplyWrappedType: Any.Type { get }
    var deeplyWrappedType: Any.Type { get }
    var deeplyWrapped: Any? { get }
}

extension Optional: OptionalProtocol {
    
    fileprivate static var deeplyWrappedType: Any.Type {
        return switch Wrapped.self {
            case let optional as OptionalProtocol.Type:
                optional.deeplyWrappedType
            default:
                Wrapped.self
        }
    }
    public var deeplyWrappedType: Any.Type {
        return switch self {
            case .some(let optional as OptionalProtocol):
                optional.deeplyWrappedType
            case .some(let wrapped):
                Swift.type(of: wrapped)
            case .none:
                Optional.deeplyWrappedType
        }
    }
    
    public var deeplyWrapped: Any? {
        guard case let .some(wrapped) = self else { return nil }
        guard let wrapped = wrapped as? OptionalProtocol else { return wrapped }
        return wrapped.deeplyWrapped
    }
}
