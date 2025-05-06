import Foundation

protocol MovieServiceProtocol {
    func fetchMovies() async throws -> [Movie]
    func fetchMovieDetail(id: Int) async throws -> MovieDetail
}
