//
//  GalleryCollectionViewCell.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 25.12.2023.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    private var profileImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        [profileImage].forEach {
            contentView.addSubview($0)
        }
        profileImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
    }
    func configure(imagePath: String){
        if imagePath != "noImage"{
            let urlString = "https://image.tmdb.org/t/p/w200" + (imagePath)
            let url = URL(string: urlString)!
            profileImage.kf.setImage(with: url)
        }
        else {
            profileImage.image = UIImage(named: "noProfile")
        }
    }
}
