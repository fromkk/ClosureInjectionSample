//
//  LoadingView.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import UIKit

final class LoadingView: UIWindow {
    static let shared: LoadingView = LoadingView(frame: UIScreen.main.bounds)
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        windowLevel = .alert
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        addSubviewOnCenter(activityIndicator)
        makeKeyAndVisible()
        isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let result = UIActivityIndicatorView(style: .white)
        result.hidesWhenStopped = true
        return result
    }()
    
    var isLoading: Bool { return activityIndicator.isAnimating }
    
    func show() {
        guard !isLoading else { return }
        activityIndicator.startAnimating()
        isHidden = false
    }
    
    func hide() {
        guard isLoading else { return }
        activityIndicator.stopAnimating()
        isHidden = true
    }
}
