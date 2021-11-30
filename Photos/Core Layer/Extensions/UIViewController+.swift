//
//  UIViewController+.swift
//  Photos
//
//  Created by Kanan Abilzada on 30.11.21.
//

import UIKit

extension UIViewController {
    func runInMainThread (completion: @escaping () -> ()) {
        DispatchQueue.main.async {
            completion()
        }
    }
}
