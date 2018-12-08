//
//  ApplicationCoordinator.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import UIKit
import FirebaseAuth

final class ApplicationCoordinator: ApplicationCoordinatorProtocol {
    
    deinit {
        if let listener = listener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    private weak var window: UIWindow?
    init(window: UIWindow) {
        self.window = window
    }
    
    private var listener: AuthStateDidChangeListenerHandle?
    
    func start() {
        let state = self.state(with: Auth.auth().currentUser)
        handle(with: state)
        
        self.listener = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            guard let self = self else { return }
            let state = self.state(with: user)
            self.handle(with: state)
        }
    }
    
    func state(with user: UserIdRepresentable?) -> ApplicationCoordinatorState {
        if let user = user {
            return .top(user)
        } else {
            return .entrance
        }
    }
    
    private var lastState: ApplicationCoordinatorState?
    
    func handle(with state: ApplicationCoordinatorState) {
        guard lastState != state else { return }
        
        switch state {
        case .entrance:
            let entranceViewController = EntranceViewController.instantitate()
            let presenter = EntrancePresenter(dependency: (view: entranceViewController, userRegisterInteractor: UserRegisterInteractor()))
            entranceViewController.inject(presenter)
            window?.rootViewController = entranceViewController
        case .top(let user):
            let topViewController = TopViewController.instantitate()
            let presenter = TopPresenter(dependencies: (user: user, view: topViewController, interactor: TopInteractor(), router: TopWireframe(viewController: topViewController)))
            topViewController.inject(presenter)
            let navigationController = UINavigationController(rootViewController: topViewController)
            window?.rootViewController = navigationController
        }
    }
    
}
