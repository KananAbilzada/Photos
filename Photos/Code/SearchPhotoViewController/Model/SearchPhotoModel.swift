//
//  SearchPhotoModel.swift
//  Photos
//
//  Created by Kanan Abilzada on 01.12.21.
//

import Foundation

struct SearchPhotoModel: Codable, Identifiable {
    let id = UUID()
    let total: Int
    let total_pages: Int
    let results: [PhotoListModel]?
}
