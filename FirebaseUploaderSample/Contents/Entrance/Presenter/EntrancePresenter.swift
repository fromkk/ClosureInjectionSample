//
//  EntrancePresenter.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation

final class EntrancePresenter: EntrancePresenterProtocol {
    weak var view: EntranceViewProtocol?
    let userRegisterInteractor: UserRegisterInteractorProtocol
    init(dependency: Dependency) {
        self.view = dependency.view
        self.userRegisterInteractor = dependency.userRegisterInteractor
    }
    
    func start() {
        view?.showLoading()
        userRegisterInteractor.register { [weak self] in
            self?.view?.hideLoading()
        }
    }
}
