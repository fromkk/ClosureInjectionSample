//
//  TopInterfaces.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import UIKit
import Media

protocol TopInteractorDelegate: class {
    func topInteractor(_ topInteractor: TopInteractorProtocol, didUpdate state: TopInteractorProtocol.State)
}

protocol TopInteractorProtocol: class {
    typealias State = NetworkingState<[MediaEntity]>
    var state: State { get }
    var delegate: TopInteractorDelegate? { get set }
    func fetch(with uid: String)
}

protocol TopPresenterProtocol: class {
    typealias Dependencies = (
        user: UserIdRepresentable,
        view: TopViewProtocol,
        interactor: TopInteractorProtocol,
        router: TopWireframeProtocol
    )
    init(dependencies: Dependencies)
    
    func upload()
    func load()
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func entity(at indexPath: IndexPath) -> MediaEntity?
}

protocol TopViewProtocol: class {
    func showMedia()
    func showLoading()
    func hideLoading()
}

protocol TopWireframeProtocol {
    init(viewController: UIViewController)
    func presentUploadView(with uid: String)
}
