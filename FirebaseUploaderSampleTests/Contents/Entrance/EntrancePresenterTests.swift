//
//  EntrancePresenterTests.swift
//  FirebaseUploaderSampleTests
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import XCTest
@testable import FirebaseUploaderSample

final class EntrancePresenterTests: XCTestCase {
    
    func testStart() {
        let view = EntranceViewStub()
        let interactor = UserRegisterInteractorStub()
        let presenter = EntrancePresenter(dependency: (view: view, userRegisterInteractor: interactor))
        XCTAssertFalse(view.isShowLoading)
        XCTAssertFalse(interactor.isRegistered)
        presenter.start()
        XCTAssertTrue(view.isShowLoading)
        XCTAssertTrue(interactor.isRegistered)
    }
    
}
