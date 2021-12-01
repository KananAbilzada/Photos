//
//  SearchPhotoServiceActions.swift
//  Photos
//
//  Created by Kanan Abilzada on 01.12.21.
//

import Foundation

protocol SearchPhotoServiceActions: AnyObject {
    func searchPhoto(currentPage: String,
                   query: String,
                   completion: @escaping (SearchPhotoResponseType) -> Void)
}
