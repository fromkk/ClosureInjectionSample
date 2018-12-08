//
//  UIView+extensions.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import UIKit

extension UIView {
    func addSubview<T: UIView>(_ view: T, constraints: (T) -> [NSLayoutConstraint]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate(constraints(view))
    }
    
    func addSubviewOnCenter<T: UIView>(_ view: T) {
        addSubview(view) { (view) -> [NSLayoutConstraint] in
            [
                view.centerXAnchor.constraint(equalTo: centerXAnchor),
                view.centerYAnchor.constraint(equalTo: centerYAnchor),
            ]
        }
    }
    
    func addSubviewWithMatch<T: UIView>(_ view: T) {
        addSubview(view) { (view) -> [NSLayoutConstraint] in
            [
                view.widthAnchor.constraint(equalTo: widthAnchor),
                view.heightAnchor.constraint(equalTo: heightAnchor),
                view.centerXAnchor.constraint(equalTo: centerXAnchor),
                view.centerYAnchor.constraint(equalTo: centerYAnchor),
            ]
        }
    }
}
