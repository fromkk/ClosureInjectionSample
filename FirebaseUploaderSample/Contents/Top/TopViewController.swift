//
//  TopViewController.swift
//  FirebaseUploaderSample
//
//  Created by Kazuya Ueoka on 2018/12/08.
//  Copyright © 2018 fromkk. All rights reserved.
//

import UIKit
import DifferenceKit
import Media

final class TopViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, TopViewProtocol, Injectable, XibInstantitable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Top"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.load()
    }
    
    // MARK: XibInstantitable
    static var nibName: String { return "TopViewController" }
    
    // MARK: Injectable
    typealias Dependencies = TopPresenterProtocol
    private var presenter: TopPresenterProtocol?
    func inject(_ dependencies: TopPresenterProtocol) {
        presenter = dependencies
    }
    
    // MARK: Properties
    
    var cache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()
    
    // MARK: TopViewProtocol
    
    func reloadData(with changeSet: StagedChangeset<[MediaEntity]>) {
        collectionView.reload(using: changeSet) { _ in }
    }
    
    func showLoading() {
        LoadingView.shared.show()
    }
    
    func hideLoading() {
        LoadingView.shared.hide()
    }
    
    // MARK: Events
    
    @IBAction func onTapUploadButton(_ sender: UIButton) {
        presenter?.upload()
    }
    
    // MAKR: UI
    
    private var collectionViewLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let numberOfRows: CGFloat = 4
        let margin: CGFloat = 2
        let size: CGFloat = (view.frame.size.width - (margin * (numberOfRows - 1))) / numberOfRows
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        layout.scrollDirection = .vertical
        return layout
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            setUpCollectionView()
        }
    }
    
    private func setUpCollectionView() {
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.register(UINib(nibName: "TopViewCell", bundle: Bundle(for: TopViewCell.self)), forCellWithReuseIdentifier: TopViewCell.reuseIdentifier)
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter?.numberOfSections() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfItems(in: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopViewCell.reuseIdentifier, for: indexPath) as! TopViewCell
        cell.cache = cache
        cell.entity = presenter?.entity(at: indexPath)
        return cell
    }
}
