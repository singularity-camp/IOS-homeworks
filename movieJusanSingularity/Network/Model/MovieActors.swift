//
//  MovieActors.swift
//  movieJusanSingularity
//
//  Created by Rustam Aliyev on 28.12.2023.
//

//   let movieActors = try? JSONDecoder().decode(MovieActors.self, from: jsonData)

import Foundation

// MARK: - MovieActors
struct MovieActors: Codable {
		let cast: [Cast]
		//let crew: [JSONAny]
		let id: Int
}

// MARK: - Cast
struct Cast: Codable {
		let adult: Bool
		let backdropPath: String?
		let genreIDS: [Int]
		let id: Int
		let originalLanguage, originalTitle, overview: String
		let popularity: Double
		let posterPath: String?
		let releaseDate, title: String
		let video: Bool
		let voteAverage: Double
		let voteCount: Int
		let character, creditID: String
		let order: Int

		enum CodingKeys: String, CodingKey {
				case adult
				case backdropPath = "backdrop_path"
				case genreIDS = "genre_ids"
				case id
				case originalLanguage = "original_language"
				case originalTitle = "original_title"
				case overview, popularity
				case posterPath = "poster_path"
				case releaseDate = "release_date"
				case title, video
				case voteAverage = "vote_average"
				case voteCount = "vote_count"
				case character
				case creditID = "credit_id"
				case order
		}
}


