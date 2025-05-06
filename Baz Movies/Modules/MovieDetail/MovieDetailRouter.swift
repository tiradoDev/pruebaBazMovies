import UIKit

class MovieDetailRouter: MovieDetailRouterProtocol {
    static func createModule(with movie: Movie) -> UIViewController {
        let view = MovieDetailViewController()
        let interactor = MovieDetailInteractor(movie: movie)
        let router = MovieDetailRouter()
        let presenter = MovieDetailPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        return view
    }
}
