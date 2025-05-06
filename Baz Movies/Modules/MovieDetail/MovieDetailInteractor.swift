import Foundation

import Foundation

class MovieDetailInteractor: MovieDetailInteractorInputProtocol {
    weak var presenter: MovieDetailInteractorOutputProtocol?
    private let service: MovieServiceProtocol
    private let movie: Movie
    
    init(movie: Movie, service: MovieServiceProtocol = MovieService()) {
        self.movie = movie
        self.service = service
    }
    
    func fetchMovieDetail() {
        Task {
            do {
                let detail = try await service.fetchMovieDetail(id: movie.id)
                presenter?.didFetchMovieDetail(detail)
            } catch {
                presenter?.didFailFetchMovieDetail(error)
            }
        }
    }
}
