import Foundation

class MovieListInteractor: MovieListInteractorInputProtocol {
    weak var presenter: MovieListInteractorOutputProtocol?
    private let service: MovieServiceProtocol
    
    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
    }
    
    func fetchMovies(category: MovieCategory) {
        Task {
            do {
                let movies = try await service.fetchMovies(category: category)
                presenter?.didFetchMovies(movies)
            } catch {
                presenter?.didFailFetchMovies(error)
            }
        }
    }
}
