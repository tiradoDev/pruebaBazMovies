import Foundation

private struct MovieResponse: Codable {
    let results: [Movie]
}

class MovieService: MovieServiceProtocol {
    private let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwMGJlZDAxM2Y1MGY0Y2U5NWM5OWQyN2QxY2E0NGQyNSIsIm5iZiI6MTc0NjQ5NjExOS43MjcsInN1YiI6IjY4MTk2YTc3YWVhNzYzM2RiNjRmZWY0YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ZWfAJsoZNY2bHHrYEofg75_7b7JU6waonUZY0xSqNg4"
    private let baseURL = "https://api.themoviedb.org/3/movie"
    
    func fetchMovies(category: MovieCategory) async throws -> [Movie] {
        let url = URL(string: "\(baseURL)/\(category.rawValue)")!
        var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        comps.queryItems = [
            URLQueryItem(name: "api_key",  value: apiKey),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page",     value: "1")
        ]
        var req = URLRequest(url: comps.url!)
        req.httpMethod = "GET"
        req.timeoutInterval = 10
        req.setValue("application/json", forHTTPHeaderField: "accept")
        req.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: req)
        let wrapper = try JSONDecoder().decode(MovieResponse.self, from: data)
        return wrapper.results
    }
    
    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        let url = URL(string: "\(baseURL)/movie/\(id)")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "api_key",   value: apiKey),
            URLQueryItem(name: "language",  value: "en-US")
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(MovieDetail.self, from: data)
    }
}


