import UIKit

extension UILabel {
    /// Convierte este label en un stat label con un título en texto pequeño y el detalle en texto normal.
    func setStat(title: String, detail: String) {
        let titleAttr = NSAttributedString(
            string: "\(title)\n",
            attributes: [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.secondaryLabel
            ]
        )
        let detailAttr = NSAttributedString(
            string: detail,
            attributes: [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.label
            ]
        )
        let combined = NSMutableAttributedString()
        combined.append(titleAttr)
        combined.append(detailAttr)
        self.attributedText = combined
        self.textAlignment = .center
        self.numberOfLines = 2
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
