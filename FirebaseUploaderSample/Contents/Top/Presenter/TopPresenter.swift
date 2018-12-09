//
//  TopPresenter.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation
import Media
import DifferenceKit

final class TopPresenter: TopPresenterProtocol, TopInteractorDelegate {
    
    private let user: UserIdRepresentable
    private weak var view: TopViewProtocol?
    private let interactor: TopInteractorProtocol
    private let router: TopWireframeProtocol
    init(dependencies: Dependencies) {
        self.user = dependencies.user
        self.view = dependencies.view
        self.interactor = dependencies.interactor
        self.router = dependencies.router
        
        interactor.delegate = self
    }
    
    func upload() {
        router.presentUploadView(with: user.uid, and: entities.map { $0.localIdentifier })
    }
    
    func load() {
        interactor.fetch(with: user.uid)
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    private var entities: [MediaEntity] = []
    
    func numberOfItems(in section: Int) -> Int {
        return entities.count
    }
    
    func entity(at indexPath: IndexPath) -> MediaEntity? {
        guard indexPath.item < entities.count else { return nil }
        return entities[indexPath.item]
    }
    
    func topInteractor(_ topInteractor: TopInteractorProtocol, didUpdate state: NetworkingState<[MediaEntity]>) {
        if case .loading = state {
            view?.showLoading()
        } else {
            view?.hideLoading()
        }
        
        switch state {
        case .success(let entities):
            let changeSet = StagedChangeset<[MediaEntity]>(source: self.entities, target: entities)
            self.entities = entities
            self.view?.reloadData(with: changeSet)
        default:
            break
        }
    }
}
