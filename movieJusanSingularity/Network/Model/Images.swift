//
//  Images.swift
//  movieJusanSingularity
//
//  Created by Rustam Aliyev on 28.12.2023.
//

//   let images = try? JSONDecoder().decode(Images.self, from: jsonData)

import Foundation

// MARK: - Images
struct Images: Codable {
		let id: Int
		let profiles: [Profile]
}

// MARK: - Profile
struct Profile: Codable {
		let aspectRatio: Double
		let height: Int
		let iso639_1: String?
		let filePath: String
		let voteAverage: Double
		let voteCount, width: Int

		enum CodingKeys: String, CodingKey {
				case aspectRatio = "aspect_ratio"
				case height
				case iso639_1 = "iso_639_1"
				case filePath = "file_path"
				case voteAverage = "vote_average"
				case voteCount = "vote_count"
				case width
		}
}

