import UIKit
import WebKit

class MovieDetailViewController: UIViewController, MovieDetailViewProtocol {
    var presenter: MovieDetailPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    func showMovieDetail(_ detail: MovieDetail) {
        // update UI
    }
    
    func showError(_ error: Error) {
        // show error alert
    }
}
