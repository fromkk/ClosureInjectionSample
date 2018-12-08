//
//  TopPresenterTests.swift
//  FirebaseUploaderSampleTests
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import XCTest
@testable import FirebaseUploaderSample

final class TopPresenterTest: XCTestCase {
    func testLoad() {
        let view = TopViewStub()
        let interactor = TopInteractorStub()
        interactor.result = .success([])
        
        let router = TopWireframeStub(viewController: UIViewController())
        let user = UserMock(uid: "hoge")
        let presenter = TopPresenter(dependencies: (user: user, view: view, interactor: interactor, router: router))
        
        XCTAssertFalse(interactor.isFetched)
        XCTAssertFalse(view.isShowLoading)
        XCTAssertFalse(view.isShowMedia)
        presenter.load()
        XCTAssertTrue(interactor.isFetched)
        XCTAssertTrue(view.isShowLoading)
        XCTAssertTrue(view.isShowMedia)
    }
    
    func testUpload() {
        let view = TopViewStub()
        let interactor = TopInteractorStub()
        
        let router = TopWireframeStub(viewController: UIViewController())
        let user = UserMock(uid: "hoge")
        let presenter = TopPresenter(dependencies: (user: user, view: view, interactor: interactor, router: router))
        
        XCTAssertFalse(router.isPresentUploadView)
        presenter.upload()
        XCTAssertTrue(router.isPresentUploadView)
    }
}
