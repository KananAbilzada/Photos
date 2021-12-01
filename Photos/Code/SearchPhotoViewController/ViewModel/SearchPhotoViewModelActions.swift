//
//  SearchPhotoViewModelActions.swift
//  Photos
//
//  Created by Kanan Abilzada on 01.12.21.
//

import Foundation

protocol SearchPhotoViewModelActions: AnyObject {
    var photoList: Dynamic<SearchPhotoModel?> { get }
    var isLoading: Dynamic<Bool> { get }
    var currentPage: Dynamic<Int> { get }
}
