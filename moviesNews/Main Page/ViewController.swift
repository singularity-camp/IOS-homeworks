//
//  MainViewController.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 11.12.2023.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    private lazy var  movie:[Result] = [] {
        didSet{
            self.movieTableView.reloadData()
        }
    }
    private var networkManager = NetworkManager.shared

    var genres: [String] = ["Now Playing", "Popular", "Top Rated", "Upcoming"]
    var filterUrl: [String] = ["now_playing", "popular", "top_rated", "upcoming"]
    
    private lazy var movieTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.register(MovieTableViewCell.self, forCellReuseIdentifier: "movieCell")
        return view
    }()
    private var filterCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "filterCell")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData(filter: "popular")
        movieTableView.delegate = self
        movieTableView.dataSource = self
        filterCollection.dataSource = self
        filterCollection.delegate = self

    }
   

    private func setupViews() {
        view.backgroundColor = UIColor(red: 54/255, green: 69/255, blue: 79/255, alpha: 1)
        view.addSubview(movieTableView)
        view.addSubview(filterCollection)
        self.title = "News"
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = UIColor(red: 54/255, green: 69/255, blue: 79/255, alpha: 1)
            appearance.shadowColor = .clear
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        else {
            print()
        }
        
        filterCollection.snp.makeConstraints {make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
            
        }
        movieTableView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalTo(filterCollection.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }
    func loadData(filter: String){
        networkManager.loadMovieLists(filter: filter) { [weak self] movies in
            self?.movie = movies
        }
    }

}
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        cell.labelMovie.text = movie[indexPath.row].title
        cell.ratingLabel.text = "★ \(movie[indexPath.row].voteAverage)"
        cell.dateLabel.text = movie[indexPath.row].releaseDate
        
        let movie = movie[indexPath.row]
        cell.configure(title: movie.title, image: movie.posterPath, date: movie.releaseDate, rating: movie.voteAverage)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsController = MovieDetailsViewController()
        let movie = movie[indexPath.row]
        movieDetailsController.movidId = movie.id
        self.navigationController?.pushViewController(movieDetailsController, animated: true)
    }
}
extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = filterCollection.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCollectionViewCell
        cell.buttonLabel.text = "\(genres[indexPath.row])"
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.loadData(filter: filterUrl[indexPath.row])
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 40)
    }
  

    
}
