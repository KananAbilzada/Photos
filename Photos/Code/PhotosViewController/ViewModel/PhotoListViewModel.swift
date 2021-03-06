//
//  PhotoListViewModel.swift
//  Photos
//
//  Created by Kanan`s Macbook Pro on 11/30/21.
//

import Foundation
import UIKit

class PhotoListViewModel: PhotoListViewModelActions {
    let imageLoaderService = StringImageLoader()
    
    // MARK: - Variables
    var imageRetrievedSuccess: Dynamic<(Int, UIImage?)>
    var photoList: Dynamic<[PhotoListModel]>
    var isLoading: Dynamic<Bool>
    var currentPage: Dynamic<Int>
    let maxPageCount: Int = 10
    
    let photoService = PhotoService.shared
    
    // MARK: - Initialization
    init() {
        self.photoList             = Dynamic([])
        self.isLoading             = Dynamic(false)
        self.currentPage           = Dynamic(1)
        self.imageRetrievedSuccess = Dynamic((0, nil))
    
        self.loadImages(currentPage: self.currentPage.value)
    }

}

extension PhotoListViewModel {
    /// Loading images from given api
    func loadImages(currentPage: Int) {
        photoService.getPhotos(currentPage: "\(currentPage)") { [weak self] response in
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
        let givenElementString = photoList.value[index].urls?.small ?? ""
        
        imageLoaderService.loadRemoteImageFrom(urlString: givenElementString) { [weak self] image in
            print(UInt(index))
            self?.imageRetrievedSuccess.value = (index, image)
        }
    }
}
