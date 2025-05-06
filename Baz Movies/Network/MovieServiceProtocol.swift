import Foundation

protocol MovieServiceProtocol {
    func fetchMovies(category: MovieCategory) async throws -> [Movie]
    func fetchMovieDetail(id: Int) async throws -> MovieDetail
}
