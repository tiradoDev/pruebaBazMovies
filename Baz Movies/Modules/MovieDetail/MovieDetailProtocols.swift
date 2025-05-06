import Foundation
import UIKit

// MARK: View -> Presenter
protocol MovieDetailViewProtocol: AnyObject {
    func showMovieDetail(_ detail: MovieDetail)
    func showError(_ error: Error)
}

// MARK: Presenter -> View
protocol MovieDetailPresenterProtocol: AnyObject, MovieDetailInteractorOutputProtocol {
    init(view: MovieDetailViewProtocol,
         interactor: MovieDetailInteractorInputProtocol,
         router: MovieDetailRouterProtocol)
    func viewDidLoad()
}

// MARK: Presenter → Interactor
protocol MovieDetailInteractorInputProtocol: AnyObject {
    var presenter: MovieDetailInteractorOutputProtocol? { get set }
    func fetchMovieDetail()
}

// MARK: Presenter -> Router
protocol MovieDetailRouterProtocol: AnyObject {
    static func createModule(with movie: Movie) -> UIViewController
}

// MARK: Interactor → Presenter
protocol MovieDetailInteractorOutputProtocol: AnyObject {
    func didFetchMovieDetail(_ detail: MovieDetail)
    func didFailFetchMovieDetail(_ error: Error)
}
