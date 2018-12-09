//
//  TopWireframeStub.swift
//  FirebaseUploaderSampleTests
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import UIKit
@testable import FirebaseUploaderSample

final class TopWireframeStub: TopWireframeProtocol {
    
    var viewController: UIViewController
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    var isPresentUploadView: Bool = false
    func presentUploadView(with uid: String, and ignoreLocalIdentifiers: [String]) {
        isPresentUploadView = true
    }
    
}
