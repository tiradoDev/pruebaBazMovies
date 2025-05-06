import UIKit
import SafariServices

class MovieDetailViewController: UIViewController, MovieDetailViewProtocol {
    // MARK: – Properties
    
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
    
    private let openHomepageButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Open Website", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isHidden = true
        return btn
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
        openHomepageButton.addTarget(self, action: #selector(didTapOpenHomepage), for: .touchUpInside)
        presenter.viewDidLoad()
    }
    
    // MARK: – Layout
    
    private func setupLayout() {
        // ScrollView + ContentView
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Add subviews
        [posterImageView,
         titleLabel, ratingLabel, genresLabel, infoLabel,
         statsStack,
         synopsisTitleLabel, synopsisLabel,
         openHomepageButton,
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
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Rating
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            // Genres
            genresLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 4),
            genresLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genresLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Info (duration)
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
            
            // Open Homepage button
            openHomepageButton.topAnchor.constraint(equalTo: synopsisLabel.bottomAnchor, constant: 16),
            openHomepageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            openHomepageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            openHomepageButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Carousel
            stillsCollectionView.topAnchor.constraint(equalTo: openHomepageButton.bottomAnchor, constant: 16),
            stillsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stillsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stillsCollectionView.heightAnchor.constraint(equalToConstant: 90),
            stillsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: – MovieDetailViewProtocol
    
    func showMovieDetail(_ detail: MovieDetail) {
        DispatchQueue.main.async {
            self.detail = detail
            
            // Title
            self.titleLabel.text = detail.title
            
            // Stars + numeric rating
            let filledStars = Int(detail.voteAverage)
            self.ratingLabel.text = String(repeating: "⭐️", count: filledStars)
                + " \(String(format: "%.1f", detail.voteAverage))"
            
            // Genres
            let names = detail.genres.map { $0.name }
            self.genresLabel.text = names.joined(separator: ", ")
            
            // Duration
            let totalMins = detail.runtime ?? 0
            let h = totalMins / 60
            let m = totalMins % 60
            self.infoLabel.text = "\(h)h \(m)m"
            
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
                detail: "\(detail.revenue)"
            )
            
            // Synopsis
            self.synopsisLabel.text = detail.overview
            
            // Poster
            if let path = detail.backdropPath {
                self.posterImageView.loadImage(from: path)
            }
            
            // Homepage button visibility
            self.openHomepageButton.isHidden = detail.homepage == nil
            
            // Reload carousel
            self.stillsCollectionView.reloadData()
        }
    }
    
    @objc private func didTapOpenHomepage() {
        guard
            let urlString = detail?.homepage,
            let url = URL(string: urlString)
        else { return }
        let safari = SFSafariViewController(url: url)
        present(safari, animated: true)
    }
    
    func showError(_ error: any Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Error",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(.init(title: "OK", style: .default))
            self.present(alert, animated: true)
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
        cell.imageView.loadImage(from: paths[indexPath.item])
        return cell
    }
}
