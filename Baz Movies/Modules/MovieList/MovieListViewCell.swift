import UIKit

class MovieListViewCell: UITableViewCell {
    static let identifier = "MovieListViewCell"
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let ratingLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .systemYellow
        lbl.numberOfLines = 1
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let genresLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12)
        lbl.textColor = .tertiaryLabel
        lbl.numberOfLines = 1
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let overviewTextView: UITextView = {
        let tv = UITextView()
        tv.font = .italicSystemFont(ofSize: 12)
        tv.textColor = .tertiaryLabel
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.textContainer.lineBreakMode = .byTruncatingTail
        tv.textContainer.maximumNumberOfLines = 3
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - View Setup
    
    private func setupViews() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(genresLabel)
        contentView.addSubview(overviewTextView)
        
        NSLayoutConstraint.activate([
            // Poster 100×132
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            
            // Title
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            
            // Rating
            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            // Genres
            genresLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genresLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 4),
            
            // Overview TextView
            overviewTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            overviewTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            overviewTextView.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 4),
            overviewTextView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Configuration
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        
        // Pintamos estrellas según la parte entera de rating (0–10)
        let filledStars = Int(movie.voteAverage)
        ratingLabel.text = String(repeating: "⭐️", count: filledStars) + " \(movie.voteAverage)"
        overviewTextView.text = movie.overview
        
        if let path = movie.posterPath {
            posterImageView.loadImage(from: path,
                                      placeholder: UIImage(named: "placeholder.png"))
        } else {
            posterImageView.image = UIImage(named: "placeholder.png")
        }
    }
}
