import Foundation
import UIKit

// MARK: Interactor → Presenter
protocol MovieListInteractorOutputProtocol: AnyObject {
    func didFetchMovies(_ movies: [Movie])
    func didFailFetchMovies(_ error: Error)
}

// MARK: Presenter → Interactor (antes MovieListInteractorProtocol)
protocol MovieListInteractorInputProtocol: AnyObject {
    var presenter: MovieListInteractorOutputProtocol? { get set }
    func fetchMovies()
}

// MARK: Presenter Protocol: hereda de InteractorOutput
protocol MovieListPresenterProtocol: AnyObject, MovieListInteractorOutputProtocol {
    init(view: MovieListViewProtocol,
         interactor: MovieListInteractorInputProtocol,
         router: MovieListRouterProtocol)
    func viewDidLoad()
    func didSelectMovie(at index: Int)
}

// MARK: View → Presenter (sin cambios)
protocol MovieListViewProtocol: AnyObject {
    func showMovies(_ movies: [Movie])
    func showError(_ error: Error)
}

// MARK: Presenter → Router (sin cambios)
protocol MovieListRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToDetail(from view: MovieListViewProtocol, with movie: Movie)
}
