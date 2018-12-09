//
//  UploadInterfaces.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import UIKit
import Photos
import AssetUploader

protocol UploadInteractorDelegate: class {
    func uploadInteractor(_ uploadInteractor: UploadInteractorProtocol, didUpdate state: UploadInteractorProtocol.State)
}

protocol UploadInteractorProtocol: class {
    typealias State = NetworkingState<PHFetchResult<PHAsset>>
    var state: State { get }
    var delegate: UploadInteractorDelegate? { get set }
    func fetch()
}

protocol UploadPresenterProtocol: class {
    typealias Interactor = UploadInteractorProtocol
    typealias View = UploadViewProtocol
    typealias Wireframe = UploadWireframeProtocol
    typealias Dependencies = (view: View, interactor: Interactor, router: Wireframe, assetUploader: AssetUploaderProtocol)
    init(dependencies: Dependencies)
    
    func close()
    func setting()
    func load()
    func upload(with assets: [PHAsset])
    func numberOfAssets() -> Int
    func asset(at index: Int) -> PHAsset?
}

protocol UploadViewProtocol: class {
    func showAssets()
    func showLoading()
    func hideLoading()
}

protocol UploadWireframeProtocol {
    init(viewController: UIViewController)
    func showSetting()
    func dismiss()
}
