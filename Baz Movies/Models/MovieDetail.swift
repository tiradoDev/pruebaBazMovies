import Foundation

struct MovieDetail: Codable {
    let id: Int
    let title: String
    let overview: String
    let genres: [Genre]
    let posterPath: String?
    let voteAverage: Double
    let homepage: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, genres, homepage
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
