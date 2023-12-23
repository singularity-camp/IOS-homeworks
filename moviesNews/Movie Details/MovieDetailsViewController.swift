//
//  MovieDetailsViewController.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 20.12.2023.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var movidId = Int()
    var voteAvg:Int = 0
    private var imageView = UIImageView()
    private var networkManager = NetworkManager.shared
    private lazy var genresCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.register(GenresCollectionViewCell.self, forCellWithReuseIdentifier: "GenresCollectionViewCell")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    private var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.contentInset = .zero
        return scroll
    }()
    private var descriptionLabel: UILabel = {
        let view = UILabel()
        view.text = "Суд в Красноярске оштрафовал на 125 тысяч рублей военнослужащего, который пытался улететь в Таиланд по паспорту брата-близнеца. Мужчина предъявил документ на контроле в красноярском аэропорту Емельяново, его задержали. Суд признал его виновным в попытке незаконного пересечения границы (часть 3 статьи 30, часть 1 статьи 322 УК).Фото: пресс-служба Второго восточного окружного военного суда. Суд в Красноярске оштрафовал на 125 тысяч рублей военнослужащего, который пытался улететь в Таиланд по паспорту брата-близнеца. Мужчина предъявил документ на контроле в красноярском аэропорту Емельяново, его задержали. Суд признал его виновным в попытке незаконного пересечения границы (часть 3 статьи 30, часть 1 статьи 322 УК)."
        view.numberOfLines = 0
        return view
    }()
    private let starsStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        stack.spacing = 4
        stack.backgroundColor = .red
        return stack
    }()
    private let youTubeImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "uTube")
        return image
    }()
    private var contentView = UIView()
    private lazy var genres:[Genre] = [] {
        didSet{
            self.genresCollection.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
        // Do any additional setup after loading the view.
    }
    func setupViews(){
        self.title = "Movie"
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.backgroundColor = .white
        contentView.addSubview(imageView)
        contentView.addSubview(genresCollection)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(starsStack)
        contentView.addSubview(youTubeImage)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.centerX.equalTo(view.snp.centerX)
        }
        imageView.snp.makeConstraints {make in
            make.height.equalTo(400)
            make.width.equalTo(300)
            make.centerX.equalToSuperview()
            make.top.equalTo(genresCollection.snp.bottom).offset(16)
            
        }
        genresCollection.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().offset(8)
            make.height.greaterThanOrEqualTo(300)
            
        }
        starsStack.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            
        }
        youTubeImage.snp.makeConstraints { make in
            make.top.equalTo(starsStack.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.width.equalTo(100)
        }
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        youTubeImage.addGestureRecognizer(tapGR)
        youTubeImage.isUserInteractionEnabled = true
        
        
    }
    
    @objc func imageTapped(){
        networkManager.loadMovieDetailsVideos(id: movidId) {  videos in
            let uTubeVideos = videos.filter {video in
                if let site = video.webSite {
                    site.contains("YouTube")
                } else {
                    .init()
                }
            }
                
            guard let key = videos.first?.key else {
                return
            }
            let urlString = "https://www.youtube.com/watch?v=" + key
            if let url = URL(string: urlString){
                UIApplication.shared.open(url)
            }
            }
        }
    
    private func loadData(){
        networkManager.loadMovieDetails(id: movidId) { [weak self] movieDetails in
            guard let posterPath = movieDetails.posterPath else{return}
            self?.voteAvg = Int(movieDetails.voteAverage ?? 0)
            self?.createStarsStack()
            self?.genres = movieDetails.genres
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
    private func createStarsStack(){
        let voteFullStars: Int = voteAvg/2
        
        
        for _ in 0..<voteFullStars {
            let fullStar = UIImageView()
            fullStar.contentMode = .scaleToFill
            fullStar.image = UIImage(named: "full_star")
            starsStack.addArrangedSubview(fullStar)
        }
        let leftEmptyStars: Int = 5 - voteFullStars
        for _ in 0..<leftEmptyStars {
            let emptyStar = UIImageView()
            emptyStar.image = UIImage(named: "empty_star")
            emptyStar.contentMode = .scaleToFill
            starsStack.addArrangedSubview(emptyStar)
        }
        
    }
  
}
extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = genresCollection.dequeueReusableCell(withReuseIdentifier: "GenresCollectionViewCell", for: indexPath) as! GenresCollectionViewCell
        cell.configure(title: genres[indexPath.row].name)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 35)
    }
  

    
}
