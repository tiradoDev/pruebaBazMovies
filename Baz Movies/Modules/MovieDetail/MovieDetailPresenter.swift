

import Foundation

class MovieDetailPresenter: MovieDetailPresenterProtocol {
    private weak var view: MovieDetailViewProtocol?
    private let interactor: MovieDetailInteractorInputProtocol
    private let router: MovieDetailRouterProtocol

    required init(view: MovieDetailViewProtocol,
                  interactor: MovieDetailInteractorInputProtocol,
                  router: MovieDetailRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        // Conecta el interactor con su salida
        (interactor as? MovieDetailInteractor)?.presenter = self
    }

    func viewDidLoad() {
        interactor.fetchMovieDetail()
    }

    // MARK: — MovieDetailInteractorOutputProtocol

    func didFetchMovieDetail(_ detail: MovieDetail) {
        view?.showMovieDetail(detail)
    }

    func didFailFetchMovieDetail(_ error: Error) {
        view?.showError(error)
    }
}
