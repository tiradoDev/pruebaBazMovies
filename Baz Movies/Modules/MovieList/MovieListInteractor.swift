import Foundation

import Foundation

class MovieListInteractor: MovieListInteractorInputProtocol {
    weak var presenter: MovieListInteractorOutputProtocol?
    private let service: MovieServiceProtocol
    
    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
    }
    
    func fetchMovies() {
        Task {
            do {
                let movies = try await service.fetchMovies()
                presenter?.didFetchMovies(movies)
            } catch {
                presenter?.didFailFetchMovies(error)
            }
        }
    }
}
