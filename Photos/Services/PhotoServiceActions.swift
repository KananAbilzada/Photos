//
//  PhotoServiceActions.swift
//  Photos
//
//  Created by Kanan`s Macbook Pro on 11/30/21.
//

import Foundation

protocol PhotoServiceActions: AnyObject {
    func getPhotos(completion: @escaping ([PhotoListModel]) -> Void)
}
