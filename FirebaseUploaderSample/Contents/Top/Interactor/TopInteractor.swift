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

final class TopInteractor: TopInteractorProtocol {
    var state: State = .notLoaded {
        didSet {
            delegate?.topInteractor(self, didUpdate: state)
        }
    }
    
    weak var delegate: TopInteractorDelegate?
    
    func fetch(with uid: String) {
        state = .loading
        Firestore.firestore().collection("users").document(uid).collection("medias").getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                self?.state = .failed(error)
            } else if let snapshot = snapshot {
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
}
