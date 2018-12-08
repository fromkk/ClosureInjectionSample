//
//  EntranceInterfaces.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation

protocol UserRegisterInteractorProtocol {
    func register(_ completion: @escaping () -> Void)
}

protocol EntrancePresenterProtocol: class {
    typealias Dependency = (view: EntranceViewProtocol, userRegisterInteractor: UserRegisterInteractorProtocol)
    init(dependency: Dependency)
    func start()
}

protocol EntranceViewProtocol: class {
    func showLoading()
    func hideLoading()
}
