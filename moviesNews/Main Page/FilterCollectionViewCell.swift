//
//  FilterCollectionViewCell.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 11.12.2023.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    private var title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
            
    }
    
    private func setupViews(){
        contentView.backgroundColor = .clear
        contentView.addSubview(title)
        layer.masksToBounds = true
        layer.cornerRadius = 11
        layer.borderColor = UIColor.systemOrange.cgColor
        layer.borderWidth = 1
        title.snp.makeConstraints({make in
            make.top.bottom.equalToSuperview().inset(4)
            make.trailing.leading.equalToSuperview().inset(16)
        })
    }
    
    func configure(title: String){
        self.title.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
}
