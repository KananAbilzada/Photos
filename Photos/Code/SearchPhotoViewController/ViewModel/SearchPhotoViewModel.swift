//
//  SearchPhotoViewModel.swift
//  Photos
//
//  Created by Kanan Abilzada on 01.12.21.
//

import UIKit

class SearchPhotoViewModel: SearchPhotoViewModelActions {
    let imageLoaderService = StringImageLoader()
    
    // MARK: - Variables
    var imageRetrievedSuccess: Dynamic<(Int, UIImage?)>
    var photoList: Dynamic<SearchPhotoModel?>
    var isLoading: Dynamic<Bool>
    var searchMode: Dynamic<Bool>
    var currentPage: Dynamic<Int>
    private let maxPageCount: Int = 10
    
    let searchPhotoService = SearchPhotoService.shared
    
    // MARK: - Initialization
    init() {
        self.photoList             = Dynamic(nil)
        self.isLoading             = Dynamic(false)
        self.currentPage           = Dynamic(1)
        self.searchMode            = Dynamic(false)
        self.imageRetrievedSuccess = Dynamic((0, nil))
    }

}

extension SearchPhotoViewModel {
    /// Loading images from given api
    func searchImage(query searchQuery: String) {
        searchPhotoService.searchPhoto(currentPage: "\(currentPage.value)",
                                 query: searchQuery) { [weak self] response in
            switch response {
            case .failure(let e):
                print("error", e.localizedDescription)
                
            case .success(let data):
                self?.photoList.value = data
            }
        }

    }
    
    /// loading image from given string
    func loadImageFromGivenItem(with index: Int) {
        let givenElementString = photoList.value?.results?[index].urls?.small ?? ""
        
        imageLoaderService.loadRemoteImageFrom(urlString: givenElementString) { [weak self] image in
            print(UInt(index))
            self?.imageRetrievedSuccess.value = (index, image)
        }
    }
}

