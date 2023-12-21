//
//  NetworkManager.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 20.12.2023.
//

import Foundation

class NetworkManager {
    static var shared = NetworkManager()
    private let urlString: String = "https://api.themoviedb.org"
    private let apiKey: String = "d568b1ed6289cb2eb4c00ca0e87771ee"
    private let session = URLSession(configuration: .default)
    private lazy var urlComponents: URLComponents = {
             var components = URLComponents()
             components.scheme = "https"
             components.host = "api.themoviedb.org"
             components.queryItems = [
                 URLQueryItem(name: "api_key", value: apiKey)
             ]
             return components
         }()
    
    func loadMovieLists(filter: String, completion: @escaping([Result]) -> Void){
        var components = urlComponents
        components.path = "/3/movie/\(filter)"
        guard let requestUrl = components.url else {
                    return
                }
        let task = session.dataTask(with: requestUrl) { data, response, error in
            guard error == nil else{
                print("Error: error calling GET")
                return
            }
            guard let data else {
                print("Error: did not get Data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: Http request failed")
                return
            }
            do{
                let movie = try JSONDecoder().decode(Movie.self, from: data)
                DispatchQueue.main.async {
                    completion(movie.results)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
           
        }
        task.resume()
    }
    func loadMovieDetails(id: Int, completion: @escaping(MovieDetails) -> Void){
        var components = urlComponents
        components.path = "/3/movie/\(id)"
        guard let requestUrl = components.url else {
                    return
                }
        let task = session.dataTask(with: requestUrl) { data, response, error in
            guard error == nil else{
                print("Error: error calling GET")
                return
            }
            guard let data else {
                print("Error: did not get Data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: Http request failed")
                return
            }
            do{
                let movieDetails = try JSONDecoder().decode(MovieDetails.self, from: data)
                DispatchQueue.main.async {
                    completion(movieDetails)
                }
            } catch {
                DispatchQueue.main.async {
                    print("error")
                }
            }
           
        }
        task.resume()
    }
}
