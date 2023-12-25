//
//  GalleryViewController.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 25.12.2023.
//

import UIKit

class GalleryViewController: UIViewController {
    
    var actorId = Int()
    var allPhotosCount = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        let xBarButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(xButtonClick))
        self.navigationItem.rightBarButtonItem = xBarButton
        self.navigationController?.navigationBar.tintColor = .white;
        self.navigationItem.hidesBackButton = true
    }
    @objc func xButtonClick(){
        self.navigationController?.popViewController(animated: true)
    }
    private var networkManager = NetworkManager.shared
    private lazy var galleryCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "GalleryCollectionViewCell")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    private lazy var photos:[Profile] = [] {
        didSet{
            self.galleryCollection.reloadData()
        }
    }
    func setupViews(){
        self.title = "1/\(allPhotosCount)"
        view.addSubview(galleryCollection)
        
        galleryCollection.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    func loadData(){
        networkManager.loadPhotosOfActor(id: actorId) { [weak self] photos in
            photos.forEach { photo in
                self?.photos.append(photo)
            }
        }
    }
}
extension GalleryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = galleryCollection.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        cell.configure(imagePath: photos[indexPath.row].filePath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.title = "\(indexPath.row + 1)/\(allPhotosCount)"
    }
}
