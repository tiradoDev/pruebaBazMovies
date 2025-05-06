import UIKit

class MovieListRouter: MovieListRouterProtocol {
    static func createModule() -> UIViewController {
        let view = MovieListViewController()
        let interactor = MovieListInteractor()
        let router = MovieListRouter()
        let presenter = MovieListPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        return view
    }
    
    func navigateToDetail(from view: MovieListViewProtocol, with movie: Movie) {
        if let viewController = view as? UIViewController {
            let detailVC = MovieDetailRouter.createModule(with: movie)
            viewController.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
