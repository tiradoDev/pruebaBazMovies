enum MovieCategory: String, CaseIterable {
    case popular      = "popular"
    case nowPlaying   = "now_playing"
    case topRated     = "top_rated"
    case upcoming     = "upcoming"
    
    var displayName: String {
        switch self {
        case .popular:    return "Popular"
        case .nowPlaying: return "Now Playing"
        case .topRated:   return "Top Rated"
        case .upcoming:   return "Upcoming"
        }
    }
}
