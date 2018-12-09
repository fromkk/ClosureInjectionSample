//
//  AssetUploaderMetadataUpdater.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/09.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
import FirebaseFirestore
import AssetUploader
import Media
import Photos
import CodableFirebase

final class AssetUploaderMetadataInteractor: AssetUploaderMetadataInteractorProtocol {
    private let uid: UID
    private let assetHash: AssetHash
    init(uid: UID, assetHash: AssetHash) {
        self.uid = uid
        self.assetHash = assetHash
    }
    
    func insert(with asset: PHAsset, completion: @escaping (Error?) -> Void) {
        let mediaType: MediaType
        if asset.mediaType == .image {
            mediaType = .photo
        } else {
            mediaType = .video
        }
        
        let now = Date()
        let entity = MediaEntity(uid: uid, state: .exporting, mediaType: mediaType, localIdentifier: asset.localIdentifier, createdAt: now.timeIntervalSince1970, updatedAt: now.timeIntervalSince1970)
        let encoder = FirestoreEncoder()
        do {
            let data = try encoder.encode(entity)
            
            let db = Firestore.firestore()
            let settings = db.settings
            settings.areTimestampsInSnapshotsEnabled = true
            db.settings = settings
            db.collection("users").document(uid).collection("medias").document(assetHash).setData(data) { (error) in
                completion(error)
            }
        } catch {
            debugPrint(#function, "encode failed", error)
            completion(error)
        }
    }
    
    func update(state: MediaState, completion: @escaping (Error?) -> Void) {
        Firestore.firestore().collection("users").document(uid).collection("medias").document(assetHash).updateData([
            "state": state.rawValue,
            "updatedAt": Date().timeIntervalSince1970
        ]) { (error) in
            completion(error)
        }
    }
    
    func update(imagePath: String, state: MediaState, completion: @escaping (Error?) -> Void) {
        Firestore.firestore().collection("users").document(uid).collection("medias").document(assetHash).updateData([
            "state": state.rawValue,
            "imagePath": imagePath,
            "updatedAt": Date().timeIntervalSince1970
        ]) { (error) in
            completion(error)
        }
    }
    func update(imagePath: String, videoPath: String, state: MediaState, completion: @escaping (Error?) -> Void) {
        Firestore.firestore().collection("users").document(uid).collection("medias").document(assetHash).updateData([
            "state": state.rawValue,
            "imagePath": imagePath,
            "videoPath": videoPath,
            "updatedAt": Date().timeIntervalSince1970
            ]) { (error) in
                completion(error)
        }
    }
}
