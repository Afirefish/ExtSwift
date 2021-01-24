//
//  OperatorsTests.swift
//  
//
//  Created by MingLQ on 2021-01-07.
//

import XCTest
@testable import ExtSwift

final class OperatorsTests: XCTestCase {
    
    private let some: String? = "x", some2: String? = "y", none: String? = nil
    
    func testIsNilAndNotNil() {
        
        XCTAssertTrue(??some  == true)
        XCTAssertTrue(!?some  == false)
        XCTAssertTrue(??none  == false)
        XCTAssertTrue(!?none  == true)
        
        XCTAssertTrue(!?some  == !(??some))
        XCTAssertTrue(!?none  == !(??none))
        
    }
    
    func testIsFalsyAndIsTruthy() {
        
        XCTAssertTrue(!true   == false)
        XCTAssertTrue(!false  == true)
        XCTAssertTrue(!1      == false)
        XCTAssertTrue(!0      == true)
        XCTAssertTrue(!1.0    == false)
        XCTAssertTrue(!0.0    == true)
        XCTAssertTrue(!some   == false)
        XCTAssertTrue(!none   == true)
        
        XCTAssertTrue(!!true  == true)
        XCTAssertTrue(!!false == false)
        XCTAssertTrue(!!1     == true)
        XCTAssertTrue(!!0     == false)
        XCTAssertTrue(!!1.0   == true)
        XCTAssertTrue(!!0.0   == false)
        XCTAssertTrue(!!some  == true)
        XCTAssertTrue(!!none  == false)
        
        XCTAssertTrue(!!some  == !(!some))
        XCTAssertTrue(!!true  == !(!true))
        XCTAssertTrue(!!1     == !(!1))
        XCTAssertTrue(!!1.0   == !(!1.0))
        XCTAssertTrue(!!none  == !(!none))
        XCTAssertTrue(!!false == !(!false))
        XCTAssertTrue(!!0     == !(!0))
        XCTAssertTrue(!!0.0   == !(!0.0))
        
        let b: Bool? = nil
        XCTAssertTrue(!b      == !false) // !b: NOT falsy from Optional, !false: NOT false from Bool
        let c: OperatorsTests = self
        XCTAssertTrue(!c      == false) // !c: NOT falsy from Optional
        
    }
    
    func testFalsyCoalescing() {
        
        XCTAssertTrue(0 ??! 1 == 1)
        XCTAssertTrue(1 ??! 0 == 1)
        XCTAssertTrue(0 ??! 0 == 0)
        XCTAssertTrue(1 ??! 2 == 1)
        
        XCTAssertTrue(false ??! true  == true)
        XCTAssertTrue(true  ??! false == true)
        XCTAssertTrue(false ??! false == false)
        XCTAssertTrue(true  ??! true  == true)
        
        XCTAssertTrue(none  ??! some  == some)
        XCTAssertTrue(some  ??! none  == some)
        XCTAssertTrue(none  ??! none  == none)
        XCTAssertTrue(some  ??! some2 == some)
        
    }
    
    @available(*, deprecated, message: "UNSTABLE API - Maybe it's not necessary!")
    func testUnstableFalsyCoalescing() {
        
        XCTAssertTrue(0 ?!! 1 == 0)
        XCTAssertTrue(1 ?!! 0 == 0)
        XCTAssertTrue(0 ?!! 0 == 0)
        XCTAssertTrue(1 ?!! 2 == 2)
        
        XCTAssertTrue(false ?!! true  == false)
        XCTAssertTrue(true  ?!! false == false)
        XCTAssertTrue(false ?!! false == false)
        XCTAssertTrue(true  ?!! true  == true)
        
        XCTAssertTrue(none  ?!! some  == none)
        XCTAssertTrue(some  ?!! none  == none)
        XCTAssertTrue(none  ?!! none  == none)
        XCTAssertTrue(some  ?!! some2 == some2)
        
    }
    
    static var allTests = [
        ("testIsNilAndNotNil", testIsNilAndNotNil),
        ("testIsFalsyAndIsTruthy", testIsFalsyAndIsTruthy),
        ("testFalsyCoalescing", testFalsyCoalescing),
        // ("testUnstableFalsyCoalescing", testUnstableFalsyCoalescing),
    ]
}
