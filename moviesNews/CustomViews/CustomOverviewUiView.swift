//
//  CustomOverviewUiView.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 24.12.2023.
//

import UIKit

@IBDesignable
class CustomOverviewUiView: UIView {
    
    private var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        view.textAlignment = .center
        view.textColor = .black
        view.numberOfLines = 1
        return view
    }()
    private var textLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        view.textAlignment = .center
        view.textColor = .black
        view.numberOfLines = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(){
        self.backgroundColor = .lightGray
        
        [titleLabel, textLabel].forEach{
            self.addSubview($0)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        textLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().offset(4)
        }
    }
    func configureView(with title: String, and text: String){
        self.titleLabel.text = title
        self.textLabel.text = text
    }

}
