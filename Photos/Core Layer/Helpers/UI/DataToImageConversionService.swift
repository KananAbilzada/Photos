//
//  DataToImageConversionService.swift
//  Photos
//
//  Created by Kanan Abilzada on 30.11.21.
//

import UIKit

protocol DataToImageConversionService: AnyObject {
    func getImage(from data: Data) -> UIImage?
}

class DataToImageConversionServiceImplementation: DataToImageConversionService {
    func getImage(from data: Data) -> UIImage? {
        return UIImage(data: data)
    }
}
