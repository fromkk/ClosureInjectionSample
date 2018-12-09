//
//  TopWireframe.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import UIKit
import AssetUploader

final class TopWireframe: TopWireframeProtocol {
    
    weak var viewController: UIViewController?
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func presentUploadView(with uid: String) {
        let assetUploader = AssetUploader(uid: uid)
        assetUploader.makeMetadataUpdater = { (uid, assetHash) in
            return AssetUploaderMetadataInteractor(uid: uid, assetHash: assetHash)
        }
        assetUploader.makeTransferTask = { (url, uid, assetHash, path) in
            return AssetUploaderURLTransfer(url: url, uid: uid, assetHash: assetHash, path: path)
        }
        
        let uploadViewController = UploadViewController.instantitate()
        let interactor = UploadInteractor()
        let router = UploadWireframe(viewController: uploadViewController)
        let presenter = UploadPresenter(dependencies: (view: uploadViewController, interactor: interactor, router: router, assetUploader: assetUploader))
        
        uploadViewController.inject(presenter)
        let navigationController = UINavigationController(rootViewController: uploadViewController)
        viewController?.present(navigationController, animated: true)
    }
    
}
