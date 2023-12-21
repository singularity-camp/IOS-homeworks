//
//  MovieTableViewCell.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 11.12.2023.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    var imageMovie: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        view.contentMode = .scaleAspectFill
        return view
    }()
    var labelMovie: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        view.textColor = .white
        view.numberOfLines = 2
        view.textAlignment = .center
        return view
    }()
    var dateLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    var ratingLabel: UILabel = {
        let view = UILabel()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .green
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.textAlignment = .center
        return view
    }()
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    func configure(title: String, image: String, date: String, rating: Double){
        labelMovie.text = title
        dateLabel.text = date
        ratingLabel.text = "★ \(rating)"
        let urlString = "https://image.tmdb.org/t/p/w200" + (image)
       
        let url = URL(string: urlString)!
        
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.imageMovie.image = UIImage(data: data)
                    }
                }
        }
    }
    private func setupViews() {
        self.backgroundColor = .clear
        
        [imageMovie, labelMovie, dateLabel, ratingLabel].forEach {
            contentView.addSubview($0)
        }

        let trailing = 57
        let leading = 57
        
        imageMovie.snp.makeConstraints { make in
            make.height.equalTo(360)
            make.top.equalTo(16)
            make.trailing.equalToSuperview().inset(trailing)
            make.leading.equalTo(leading)
            make.bottom.equalToSuperview()
        }
        
        labelMovie.snp.makeConstraints { make in
            make.top.equalTo(127)
            make.trailing.equalToSuperview().inset(trailing)
            make.leading.equalToSuperview().inset(leading)
            
//            make.bottom.equalToSuperview().inset(16)
        }
        dateLabel.snp.makeConstraints({ make in
            make.top.equalTo(labelMovie.snp.bottom).offset(36)
            make.trailing.equalToSuperview().inset(trailing)
            make.leading.equalToSuperview().inset(leading)
            make.bottom.equalToSuperview().inset(36)
        })
        ratingLabel.snp.makeConstraints({make in
            make.top.equalTo(imageMovie.snp.top).offset(10)
            make.trailing.equalToSuperview().inset(226)
            make.leading.equalToSuperview().inset(leading + 10)
        })
    }

}
