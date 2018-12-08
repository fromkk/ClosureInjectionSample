//
//  ApplicationCoordinatorInterfaces.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import UIKit

enum ApplicationCoordinatorState: Equatable {
    case entrance
    case top(UserIdRepresentable)
    
    static func == (lhs: ApplicationCoordinatorState, rhs: ApplicationCoordinatorState) -> Bool {
        switch (lhs, rhs) {
        case (.entrance, .entrance):
            return true
        case (.top(let user1), .top(let user2)):
            return user1.uid == user2.uid
        default:
            return false
        }
    }
}

protocol ApplicationCoordinatorProtocol: class {
    init(window: UIWindow)
    func start()
    func state(with user: UserIdRepresentable?) -> ApplicationCoordinatorState
    func handle(with state: ApplicationCoordinatorState)
}
