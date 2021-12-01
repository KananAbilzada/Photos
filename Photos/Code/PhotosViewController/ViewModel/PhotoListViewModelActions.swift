//
//  PhotoListViewModelActions.swift
//  Photos
//
//  Created by Kanan`s Macbook Pro on 11/30/21.
//

import Foundation

protocol PhotoListViewModelActions: AnyObject {
    var photoList: Dynamic<[PhotoListModel]> { get }
    var isLoading: Dynamic<Bool> { get }
    var currentPage: Dynamic<Int> { get }
}
