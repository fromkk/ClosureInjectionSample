//
//  UploadViewController.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import UIKit
import Photos

final class UploadViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, Injectable, UploadViewProtocol, XibInstantitable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Upload"
        
        navigationItem.leftBarButtonItem = closeButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.load()
    }
    
    // MARK: XibInstantitable
    
    static var nibName: String { return "UploadViewController" }
    
    // MARK: DI
    
    typealias Dependencies = UploadPresenterProtocol
    private var presenter: UploadPresenterProtocol?
    func inject(_ dependencies: UploadPresenterProtocol) {
        presenter = dependencies
    }
    
    // MARK: UploadViewProtocol
    
    func showAssets() {
        collectionView.reloadData()
    }
    
    func showLoading() {
        LoadingView.shared.show()
    }
    
    func hideLoading() {
        LoadingView.shared.hide()
    }
    
    // MARK: UI
    
    private lazy var imageManager: PHImageManager = PHImageManager.default()
    
    private lazy var imageRequestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        return options
    }()
    
    lazy var closeButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(onTap(closeButton:)))
    
    @objc private func onTap(closeButton: UIBarButtonItem) {
        presenter?.close()
    }
    
    @IBAction func onTapUploadButton(_ sender: UIButton) {
        let assets: [PHAsset] = collectionView.indexPathsForSelectedItems?.compactMap({ (indexPath) -> PHAsset? in
            return presenter?.asset(at: indexPath.item)
        }) ?? []
        
        presenter?.upload(with: assets)
    }
    
    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        let numberOfRows: CGFloat = 4
        let margin: CGFloat = 2
        let size: CGFloat = (view.frame.size.width - (margin * (numberOfRows - 1))) / numberOfRows
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        layout.scrollDirection = .vertical
        return layout
    }()
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.collectionViewLayout = collectionViewLayout
            collectionView.allowsMultipleSelection = true
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(UINib(nibName: "UploadViewCell", bundle: Bundle(for: UploadViewCell.self)), forCellWithReuseIdentifier: UploadViewCell.reuseIdentifier)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfAssets() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UploadViewCell.reuseIdentifier, for: indexPath) as! UploadViewCell
        if let asset = presenter?.asset(at: indexPath.item) {
            imageManager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: imageRequestOptions) { (image, info) in
                cell.imageView.image = image
            }
        }
        
        return cell
    }
    
}
