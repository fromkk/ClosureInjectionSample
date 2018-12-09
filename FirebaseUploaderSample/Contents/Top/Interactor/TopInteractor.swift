//
//  TopInteractor.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase
import Media

final class TopInteractor: TopInteractorProtocol {
    deinit {
        listenerRegistration?.remove()
    }
    
    var state: State = .notLoaded {
        didSet {
            delegate?.topInteractor(self, didUpdate: state)
        }
    }
    
    weak var delegate: TopInteractorDelegate?
    
    var listenerRegistration: ListenerRegistration?
    
    func fetch(with uid: String) {
        state = .loading
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        listenerRegistration = db.collection("users").document(uid).collection("medias").order(by: "mediaDate", descending: true).addSnapshotListener(includeMetadataChanges: true) { [weak self] (snapshot, _) in
            guard let snapshot = snapshot else { return }
            let decoder = FirestoreDecoder()
            let result: [MediaEntity] = snapshot.documents.compactMap({ (document) -> MediaEntity? in
                do {
                    return try decoder.decode(MediaEntity.self, from: document.data())
                } catch {
                    debugPrint(#function, error)
                    return nil
                }
            })
            self?.state = .success(result)
        }
    }
}
