//
//  FilterCollectionViewCell.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 11.12.2023.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    var buttonLabel: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.systemOrange.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(buttonLabel)
        buttonLabel.snp.makeConstraints({make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        })
            
    }
        
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
}
