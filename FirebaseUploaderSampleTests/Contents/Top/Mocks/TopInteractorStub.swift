//
//  TopInteractorStub.swift
//  FirebaseUploaderSampleTests
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
@testable import FirebaseUploaderSample

final class TopInteractorStub: TopInteractorProtocol {
    var state: State = .notLoaded {
        didSet {
            delegate?.topInteractor(self, didUpdate: state)
        }
    }
    
    var delegate: TopInteractorDelegate?
    
    var isFetched: Bool = false
    var uid: String?
    var result: State?
    
    func fetch(with uid: String) {
        self.isFetched = true
        self.uid = uid
        state = .loading
        if let result = result {
            state = result
        }
    }
}
