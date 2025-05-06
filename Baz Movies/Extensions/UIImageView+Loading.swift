import UIKit

private let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImage(from path: String, placeholder: UIImage? = nil) {
        // URL completa de TMDB con tamaño medio (w500)
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let key = NSString(string: path)
        
        // Pon placeholder mientras carga
        DispatchQueue.main.async {
            self.image = placeholder
        }
        
        if let cached = imageCache.object(forKey: key) {
            DispatchQueue.main.async {
                self.image = cached
            }
            return
        }
        
        guard let url = URL(string: baseURL + path) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data,
                  let img = UIImage(data: data),
                  error == nil else {
                return
            }
            
            imageCache.setObject(img, forKey: key)
            DispatchQueue.main.async {
                self.image = img
            }
        }.resume()
    }
}
