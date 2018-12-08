//
//  UploadPresenter.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
import Photos

final class UploadPresenter: UploadPresenterProtocol, UploadInteractorDelegate {
    
    private weak var view: View?
    private let interactor: Interactor
    private let router: Wireframe
    init(dependencies: Dependencies) {
        self.view = dependencies.view
        self.interactor = dependencies.interactor
        self.router = dependencies.router
        interactor.delegate = self
    }
    
    func setting() {
        router.showSetting()
    }
    
    func close() {
        router.dismiss()
    }
    
    func load() {
        interactor.fetch()
    }
    
    func upload(with assets: [PHAsset]) {
        // TODO: upload
    }
    
    func numberOfAssets() -> Int {
        return fetchResult?.count ?? 0
    }
    
    func asset(at index: Int) -> PHAsset? {
        guard index < numberOfAssets() else { return nil }
        return fetchResult?.object(at: index)
    }
    
    private var fetchResult: PHFetchResult<PHAsset>?
    func uploadInteractor(_ uploadInteractor: UploadInteractorProtocol, didUpdate state: NetworkingState<PHFetchResult<PHAsset>>) {
        if case .loading = state {
            view?.showLoading()
        } else {
            view?.hideLoading()
        }
        
        switch state {
        case .success(let fetchResult):
            self.fetchResult = fetchResult
            view?.showAssets()
        default:
            break
        }
    }
    
}
