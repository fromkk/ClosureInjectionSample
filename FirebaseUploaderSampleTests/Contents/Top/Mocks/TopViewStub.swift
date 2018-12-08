//
//  TopViewStub.swift
//  FirebaseUploaderSampleTests
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
@testable import FirebaseUploaderSample

final class TopViewStub: TopViewProtocol {
    var isShowMedia: Bool = false
    func showMedia() {
        isShowMedia = true
    }
    
    var isShowLoading: Bool = false
    func showLoading() {
        isShowLoading = true
    }
    
    var isHideLoading: Bool = false
    func hideLoading() {
        isHideLoading = true
    }
    
}
