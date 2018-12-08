//
//  UploadInteractor.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
import Photos

final class UploadInteractor: UploadInteractorProtocol {
    var state: State = .notLoaded {
        didSet {
            delegate?.uploadInteractor(self, didUpdate: state)
        }
    }
    weak var delegate: UploadInteractorDelegate?
    
    func fetch() {
        handlePermission(with: PHPhotoLibrary.authorizationStatus())
    }
    
    private func handlePermission(with status: PHAuthorizationStatus) {
        switch status {
        case .authorized:
            performFetch()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] (status) in
                self?.handlePermission(with: status)
            }
        case .denied, .restricted:
            break
        }
    }
    
    private func performFetch() {
        let options = PHFetchOptions()
        options.includeAllBurstAssets = false
        options.includeAssetSourceTypes = [.typeCloudShared, .typeUserLibrary, .typeiTunesSynced]
        options.includeHiddenAssets = false
        
        guard let assetCollection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: options).firstObject else {
            return
        }
        
        options.sortDescriptors = [NSSortDescriptor(keyPath: \PHAsset.creationDate, ascending: false)]
        let fetchResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: assetCollection, options: options)
        state = .success(fetchResult)
    }
}
