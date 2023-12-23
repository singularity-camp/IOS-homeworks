//
//  MainViewController.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 11.12.2023.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    private lazy var movie:[Result] = [] {
        didSet{
            self.movieTableView.reloadData()
        }
    }
    private var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        view.textAlignment = .center
        view.textColor = .black
        view.text = "MovieNews"
        return view
    }()
    private var isGenresShown: Bool = false
    private var titleLabelYPosition: Constraint!
    private var containerView = UIView()
    private lazy var genres: [Genre] = [.init(id: 1, name: "All")] {
        didSet {
            self.genresCollection.reloadData()
        }
    }
    private var allMovies: [Result] = []
    private var networkManager = NetworkManager.shared
    private var filters = Themes.allCases
    private lazy var movieTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.register(MovieTableViewCell.self, forCellReuseIdentifier: "movieCell")
        view.dataSource = self
        view.delegate = self
        return view
    }()
    private lazy var filterCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.register(GenresCollectionViewCell.self, forCellWithReuseIdentifier: "filterCell")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    private lazy var genresCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.register(GenresCollectionViewCell.self, forCellWithReuseIdentifier: "genreCell")
        view.isHidden = true
        view.delegate = self
        view.dataSource = self
        return view
    }()
    private var showGenresButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Genre ⌄", for: .normal) 
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    private let genresStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        stack.spacing = 2
        stack.backgroundColor = .clear
        return stack
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData(filter: .popular)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
    @objc func showGenreTapped(_ sender: UIButton){
        if !isGenresShown {
            self.genresCollection.isHidden = false
            isGenresShown = true
        }
        else {
            self.genresCollection.isHidden = true
            isGenresShown = false
        }
        
    }
    private func animate(){
        UIView.animate(withDuration: 0.5, delay: 0.5) {
            self.titleLabel.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.7, delay: 0.3) {
                self.titleLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            } completion: { _ in
                UIView.animate(withDuration: 0.45, delay: 0.45, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseIn) {
                    self.invokeAnimatedTitleLabel()
                } completion: { _ in
                    UIView.animate(withDuration: 0.5, delay: 0.5) {
                        self.containerView.alpha = 1
                    }
                }
            }
        }
    }
    private func invokeAnimatedTitleLabel(){
        titleLabelYPosition.update(offset: -(view.safeAreaLayoutGuide.layoutFrame.height / 2 - 20))
        view.layoutSubviews()
    }
    private func setupViews() {
        view.backgroundColor = .white
        showGenresButton.addTarget(self, action: #selector(showGenreTapped(_ :)), for: .touchUpInside)
        containerView.alpha = 0
        [titleLabel, containerView].forEach {
            view.addSubview($0)
        }
        [movieTableView, filterCollection, genresStack].forEach {
            containerView.addSubview($0)
        }
        genresStack.addArrangedSubview(showGenresButton)
        genresStack.addArrangedSubview(genresCollection)
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.tintColor = .white
        }
        else {
            print()
        }
        showGenresButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
        }
        genresCollection.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        filterCollection.snp.makeConstraints {make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(40)
        }
        genresStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(filterCollection.snp.bottom).offset(8)
        }
        movieTableView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalTo(genresStack.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            titleLabelYPosition = make.centerY.equalToSuperview().constraint
            make.center.equalToSuperview()
        }
        containerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    func loadData(filter: Themes){
        networkManager.loadMovieLists(filter: filter.urlPaths) { [weak self] movies in
            self?.movie = movies
        }
        networkManager.loadGenres { [weak self] genres in
            genres.forEach { genre in
                self?.genres.append(genre)
            }
        }
    }
    private func obtainMovieList(with genreId: Int) {
        guard genreId != 1 else {
            movie = allMovies
            return
        }
        
        movie = allMovies.filter { movie in
            movie.genreIDS.contains(genreId)
        }
    }

}
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        let movie = movie[indexPath.row]
        cell.configure(title: movie.title, image: movie.posterPath, date: movie.releaseDate, rating: movie.voteAverage)
        cell.selectionStyle = .none
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
        if collectionView == self.filterCollection {
            return filters.count
        }
        else {
            return genres.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.filterCollection {
            let cell = filterCollection.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! GenresCollectionViewCell
            cell.configure(title: filters[indexPath.row].key)
            cell.backgroundColor = .lightGray
            cell.configureCustonTitle(with: UIFont.systemFont(ofSize: 14))
            return cell
        }
        else {
            let cell = genresCollection.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as! GenresCollectionViewCell
            cell.configure(title: genres[indexPath.row].name)
            cell.configureCustonTitle(with: UIFont.systemFont(ofSize: 14))
            return cell
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.filterCollection {
            self.loadData(filter: filters[indexPath.row])
        }
        else {
            obtainMovieList(with: genres[indexPath.row].id)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 35)
    }
}
