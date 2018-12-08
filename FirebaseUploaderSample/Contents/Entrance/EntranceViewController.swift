//
//  EntranceViewController.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import UIKit

final class EntranceViewController: UIViewController, XibInstantitable, Injectable, EntranceViewProtocol {
    
    // MAKR: Injectable
    typealias Dependencies = EntrancePresenterProtocol
    private var presenter: EntrancePresenterProtocol?
    func inject(_ dependencies: EntrancePresenterProtocol) {
        self.presenter = dependencies
    }
    
    // MARK: Event
    
    @IBAction func onStartButtonDidTap(_ sender: UIButton) {
        presenter?.start()
    }
    
    // MARK: EntranceViewProtocol
    
    func showLoading() {
        LoadingView.shared.show()
    }
    
    func hideLoading() {
        LoadingView.shared.hide()
    }
    
    // MARK:  XibInstantitable
    static var nibName: String { return "EntranceViewController" }
    
}
