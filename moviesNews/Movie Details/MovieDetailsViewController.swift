//
//  MovieDetailsViewController.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 20.12.2023.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var movidId = Int()
    
    private var imageView = UIImageView()
    private var networkManager = NetworkManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func setupViews(){
        self.title = "Movie"
        view.backgroundColor = .white
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints {make in
            make.height.equalTo(400)
            make.width.equalTo(300)
            make.center.equalToSuperview()
        }
    }
    
    private func loadData(){
        networkManager.loadMovieDetails(id: movidId) { [weak self] movieDetails in
            guard let posterPath = movieDetails.posterPath else{return}
            let urlString = "https://image.tmdb.org/t/p/w200" + (posterPath)
           
            let url = URL(string: urlString)!
            
                DispatchQueue.global(qos: .userInitiated).async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self?.imageView.image = UIImage(data: data)
                        }
                    }
            }
        }
    }

  
}
