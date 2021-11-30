//
//  PhotoListViewModel.swift
//  Photos
//
//  Created by Kanan`s Macbook Pro on 11/30/21.
//

import Foundation

class PhotoListViewModel: PhotoListViewModelActions {
    // MARK: - Variables
    var photoList: Dynamic<[PhotoListModel]>
    var isLoading: Dynamic<Bool>
    var currentPage: Dynamic<Int>
    private let maxPageCount: Int = 10
    
    let photoService = PhotoService.shared
    
    // MARK: - Initialization
    init() {
        self.photoList = Dynamic([])
        self.isLoading = Dynamic(false)
        self.currentPage = Dynamic(1)

        self.loadImages()
    }

}

extension PhotoListViewModel {
    /// Loading images from given api
    private func loadImages() {
        photoService.getPhotos(currentPage: "\(currentPage.value)") { [weak self] response in
            switch response {
            case .failure(let e):
                print("error")
                
            case .success(let data):
                self?.photoList.value = data
            }
        }
    }
}
