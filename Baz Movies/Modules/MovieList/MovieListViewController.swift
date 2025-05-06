import UIKit

class MovieListViewController: UIViewController {
    var presenter: MovieListPresenterProtocol!
    
    private var movies: [Movie] = []
    
    // 1. Carrusel horizontal
    private lazy var carouselLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 180)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return layout
    }()
    
    private lazy var carouselCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: carouselLayout)
        cv.register(CarouselImageCell.self, forCellWithReuseIdentifier: CarouselImageCell.identifier)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        return cv
    }()
    
    // 2. Segmented Control
    private let segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: MovieCategory.allCases.map(\.displayName))
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    // 3. Table View
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(MovieListViewCell.self, forCellReuseIdentifier: MovieListViewCell.identifier)
        tv.rowHeight = 132
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        view.backgroundColor = .systemBackground
        
        setupViews()
        segmentControl.addTarget(self,
                                 action: #selector(segmentChanged(_:)),
                                 for: .valueChanged)
        tableView.dataSource = self
        tableView.delegate   = self
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate   = self
        
        presenter.viewDidLoad()
    }
    
    private func setupViews() {
        view.addSubview(segmentControl)
        view.addSubview(carouselCollectionView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            // SegmentedControl
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Carousel CollectionView
            carouselCollectionView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 8),
            carouselCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselCollectionView.heightAnchor.constraint(equalToConstant: 180),
            
            // TableView below carousel
            tableView.topAnchor.constraint(equalTo: carouselCollectionView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        let category = MovieCategory.allCases[sender.selectedSegmentIndex]
        presenter.didChangeCategory(to: category)
    }
}

// MARK: – MovieListViewProtocol

extension MovieListViewController: MovieListViewProtocol {
    func showMovies(_ movies: [Movie]) {
        DispatchQueue.main.async {
            self.movies = movies
            self.carouselCollectionView.reloadData()
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

// MARK: – UITableViewDataSource & Delegate

extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieListViewCell.identifier,
            for: indexPath
        ) as! MovieListViewCell
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectMovie(at: indexPath.row)
    }
}

// MARK: – UICollectionViewDataSource

extension MovieListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = movies[indexPath.item]
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CarouselImageCell.identifier,
            for: indexPath
        ) as! CarouselImageCell
        if let path = movie.posterPath {
            cell.imageView.loadImage(from: path,
                                     placeholder: UIImage(named: "placeholder.png"))
        }
        return cell
    }
}

// MARK: – UICollectionViewDelegate

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectMovie(at: indexPath.item)
    }
}
