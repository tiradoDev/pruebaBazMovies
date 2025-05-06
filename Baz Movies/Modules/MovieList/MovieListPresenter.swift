

import Foundation

class MovieListPresenter: MovieListPresenterProtocol {
    private weak var view: MovieListViewProtocol?
    private let interactor: MovieListInteractorInputProtocol
    private let router: MovieListRouterProtocol
    private var movies: [Movie] = []

    required init(view: MovieListViewProtocol,
                  interactor: MovieListInteractorInputProtocol,
                  router: MovieListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        // Conecta el interactor con su salida
        (interactor as? MovieListInteractor)?.presenter = self
    }

    func viewDidLoad() {
        interactor.fetchMovies()
    }

    func didSelectMovie(at index: Int) {
        guard index < movies.count else { return }
        let movie = movies[index]
        router.navigateToDetail(from: view!, with: movie)
    }

    // MARK: — MovieListInteractorOutputProtocol

    func didFetchMovies(_ movies: [Movie]) {
        self.movies = movies
        view?.showMovies(movies)
    }

    func didFailFetchMovies(_ error: Error) {
        view?.showError(error)
    }
}
