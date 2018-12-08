//
//  Instantiable.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import UIKit

protocol StoryboardInstantitable: class {
    static var storyboardName: String { get }
    static var viewControllerIdentifier: String { get }
}

extension StoryboardInstantitable {
    static func instantitate() -> Self {
        guard let result: Self = UIStoryboard(name: storyboardName, bundle: Bundle(for: Self.self)).instantiateViewController(withIdentifier: viewControllerIdentifier) as? Self else {
            fatalError("instantitate failed")
        }
        
        return result
    }
}

protocol XibInstantitable: class {
    static var nibName: String { get }
}

extension XibInstantitable {
    static func instantitate(with owner: Any? = nil) -> Self {
        guard let result: Self = UINib(nibName: nibName, bundle: Bundle(for: Self.self)).instantiate(withOwner: owner, options: nil).first as? Self else {
            fatalError("instantitate failed")
        }
        
        return result
    }
}
