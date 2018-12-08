//
//  ApplicationCoordinatorTests.swift
//  FirebaseUploaderSampleTests
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import XCTest
@testable import FirebaseUploaderSample

final class ApplicationCoordinatorTests: XCTestCase {
    func testStateEntrance() {
        XCTAssertEqual(.entrance, ApplicationCoordinator(window: UIWindow()).state(with: nil))
    }
    
    func testStateTop() {
        let user = UserMock(uid: "hoge")
        XCTAssertEqual(.top(user), ApplicationCoordinator(window: UIWindow()).state(with: user))
    }
}
