//
//  SearchPhotoService.swift
//  Photos
//
//  Created by Kanan Abilzada on 01.12.21.
//

import Foundation

class SearchPhotoService: SearchPhotoServiceActions, Request {

    private let dataLoader: DataLoader
    
    // MARK: Request parameters
    var host: String
    var path: String
    var queryItems: [URLQueryItem]
    var headers: [String : String]
    
    static let shared = SearchPhotoService()
    
    // MARK: - Initialization
    init() {
        dataLoader = DataLoader()
        
        self.host = ApiURL.baseURL
        self.path = ""
        self.queryItems = []
        self.headers = [:]
        
        setupHeaders()
    }
    
    // MARK: Request header setup
    private func setupHeaders () {
        self.headers = ["Authorization": "Client-ID \(ApiURL.apiKey)"]
    }
}


extension SearchPhotoService {
    /// search photos for query
    /// - Parameter completion: completion handler for function
    /// - Parameter currentPage: represents current page's count
    /// - Parameter query: searching parameter for photos
    func searchPhoto(currentPage: String,
                   query: String,
                   completion: @escaping (SearchPhotoResponseType) -> Void) {
        self.path = "/search/photos"

        self.queryItems = []
        let perPage     = URLQueryItem(name: "per_page", value: "30")
        let currentPage = URLQueryItem(name: "page", value: currentPage)
        let searchQuery  = URLQueryItem(name: "query", value: query)
        self.queryItems = [perPage, searchQuery, currentPage]
        
        dataLoader.request(self, decodable: SearchPhotoModel.self) { response in
            completion(response)
        }
    }
}
