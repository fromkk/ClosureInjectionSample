//
//  TopWireframe.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import UIKit

final class TopWireframe: TopWireframeProtocol {
    
    weak var viewController: UIViewController?
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func presentUploadView() {
        let uploadViewController = UploadViewController.instantitate()
        let interactor = UploadInteractor()
        let router = UploadWireframe(viewController: uploadViewController)
        let presenter = UploadPresenter(dependencies: (view: uploadViewController, interactor: interactor, router: router))
        uploadViewController.inject(presenter)
        let navigationController = UINavigationController(rootViewController: uploadViewController)
        viewController?.present(navigationController, animated: true)
    }
    
}
