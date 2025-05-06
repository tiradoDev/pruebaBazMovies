

import Foundation

// MovieListPresenter.swift
class MovieListPresenter: MovieListPresenterProtocol {
    private weak var view: MovieListViewProtocol?
    private let interactor: MovieListInteractorInputProtocol
    private let router: MovieListRouterProtocol
    private var movies: [Movie] = []
    private var currentCategory: MovieCategory = .popular

    required init(view: MovieListViewProtocol,
                  interactor: MovieListInteractorInputProtocol,
                  router: MovieListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        (interactor as? MovieListInteractor)?.presenter = self
    }

    func viewDidLoad() {
        interactor.fetchMovies(category: currentCategory)
    }

    func didSelectMovie(at index: Int) {
        guard index < movies.count else { return }
        router.navigateToDetail(from: view!, with: movies[index])
    }

    // Nuevo: usuario cambió segmento
    func didChangeCategory(to category: MovieCategory) {
        currentCategory = category
        interactor.fetchMovies(category: category)
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
