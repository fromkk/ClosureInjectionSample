//
//  UploadWireframe.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import UIKit

final class UploadWireframe: UploadWireframeProtocol {
    
    private weak var viewController: UIViewController?
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showSetting() {
        let url = URL(string: UIApplication.openSettingsURLString)!
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
