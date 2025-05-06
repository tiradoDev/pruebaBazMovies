import UIKit

class MovieListViewController: UIViewController {
    var presenter: MovieListPresenterProtocol!
    
    private var movies: [Movie] = []
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Popular Movies"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        presenter.viewDidLoad()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints a los bordes
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        tableView.register(MovieListViewCell.self,
                           forCellReuseIdentifier: MovieListViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 132
    }
}

// MARK: - MovieListViewProtocol
extension MovieListViewController: MovieListViewProtocol {
    func showMovies(_ movies: [Movie]) {
        DispatchQueue.main.async {
            self.movies = movies
            self.tableView.reloadData()
        }
    }
    
    func showError(_ error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource & Delegate
extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    // Número de filas = cantidad de movies
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    // Configura cada celda
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieListViewCell.identifier,
            for: indexPath
        ) as! MovieListViewCell
        
        // Aquí configuras tu celda con el movie
        cell.configure(with: movie)
        return cell
    }
    
    // Maneja selección de fila
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectMovie(at: indexPath.row)
    }
}
