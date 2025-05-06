import UIKit

class MovieDetailViewController: UIViewController, MovieDetailViewProtocol {
    func showError(_ error: any Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    var presenter: MovieDetailPresenterProtocol!
    private var detail: MovieDetail?
    
    // MARK: – UI Elements
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 24)
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let ratingLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .systemYellow
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let genresLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .secondaryLabel
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .secondaryLabel
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let statsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let languageLabel: UILabel = {
        let lbl = UILabel()
        lbl.setStat(title: "Language", detail: "-")
        return lbl
    }()
    
    private let commentsLabel: UILabel = {
        let lbl = UILabel()
        lbl.setStat(title: "Comments", detail: "-")
        return lbl
    }()
    
    private let collectionLabel: UILabel = {
        let lbl = UILabel()
        lbl.setStat(title: "Collection", detail: "-")
        return lbl
    }()
    
    private let synopsisTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Synopsis"
        lbl.font = .boldSystemFont(ofSize: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let synopsisLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .label
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var stillsLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 160, height: 90)
        layout.minimumLineSpacing = 12
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        return layout
    }()
    
    private lazy var stillsCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: stillsLayout)
        cv.register(CarouselImageCell.self, forCellWithReuseIdentifier: CarouselImageCell.identifier)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        return cv
    }()
    
    // MARK: – Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        presenter.viewDidLoad()
    }
    
    // MARK: – Layout
    
    private func setupLayout() {
        // 1. ScrollView + ContentView
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // ScrollView al superview
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView dentro de ScrollView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // 2. Agregar subviews al contentView
        [posterImageView,
         titleLabel, ratingLabel, genresLabel, infoLabel,
         statsStack,
         synopsisTitleLabel, synopsisLabel,
         stillsCollectionView].forEach { contentView.addSubview($0) }
        
        statsStack.addArrangedSubview(languageLabel)
        statsStack.addArrangedSubview(commentsLabel)
        statsStack.addArrangedSubview(collectionLabel)
        
        NSLayoutConstraint.activate([
            // Poster (16:9)
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 9/16),
            
            // Título
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Rating
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            // Géneros
            genresLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 4),
            genresLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genresLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Info (duración · año)
            infoLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 4),
            infoLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Stats
            statsStack.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 12),
            statsStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            statsStack.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Synopsis title
            synopsisTitleLabel.topAnchor.constraint(equalTo: statsStack.bottomAnchor, constant: 16),
            synopsisTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            // Synopsis text
            synopsisLabel.topAnchor.constraint(equalTo: synopsisTitleLabel.bottomAnchor, constant: 8),
            synopsisLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            synopsisLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Video stills carousel
            stillsCollectionView.topAnchor.constraint(equalTo: synopsisLabel.bottomAnchor, constant: 16),
            stillsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stillsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stillsCollectionView.heightAnchor.constraint(equalToConstant: 90),
            
            // Fondo del contentView
            stillsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: – MovieDetailViewProtocol
    
    func showMovieDetail(_ detail: MovieDetail) {
        DispatchQueue.main.async {
            self.detail = detail
            
            // Título
            self.titleLabel.text = detail.title
            
            // Pintamos estrellas según la parte entera de rating (0–10)
            let filledStars = Int(detail.voteAverage)
            self.ratingLabel.text = String(repeating: "⭐️", count: filledStars) + " \(detail.voteAverage)"
            
            // Géneros
            let genreNames = detail.genres.map { $0.name }
            self.genresLabel.text = genreNames.joined(separator: ", ")
            
            // Duración
            let runtimeMinutes = detail.runtime ?? 0
            let hours = runtimeMinutes / 60
            let minutes = runtimeMinutes % 60
            let durationText = "\(hours)h \(minutes)m"
            self.infoLabel.text = "\(durationText)"
            
            // Stats
            self.languageLabel.setStat(
                title: "Language",
                detail: detail.spokenLanguages.first?.englishName ?? "-"
            )
            self.commentsLabel.setStat(
                title: "Comments",
                detail: "\(detail.voteCount)"
            )
            self.collectionLabel.setStat(
                title: "Collection",
                detail: "\(detail.releaseDate)"
            )
            
            // Synopsis
            self.synopsisLabel.text = detail.overview
            
            // Poster
            if let path = detail.backdropPath {
                self.posterImageView.loadImage(from: path)
            }
            
            // Recargar carrusel
            self.stillsCollectionView.reloadData()
        }
    }
}

// MARK: – UICollectionViewDataSource

extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let d = detail else { return 0 }
        return [d.backdropPath, d.posterPath].compactMap { $0 }.count
    }
    func collectionView(_ cv: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(
            withReuseIdentifier: CarouselImageCell.identifier,
            for: indexPath
        ) as! CarouselImageCell
        
        let paths = [detail?.backdropPath, detail?.posterPath].compactMap { $0 }
        let path = paths[indexPath.item]
        cell.imageView.loadImage(from: path)
        
        return cell
    }
}
