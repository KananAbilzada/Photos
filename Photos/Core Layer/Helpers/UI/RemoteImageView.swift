//
//  RemoteImageView.swift
//  Photos
//
//  Created by Kanan Abilzada on 30.11.21.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class RemoteImageView: UIImageView {
    
    func loadRemoteImageFrom(urlString: String){
        image = nil
        guard let url = URL(string: urlString) else {
            return
        }
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let resultImageData = data {
                DispatchQueue.main.async {
                    if let img = UIImage(data: resultImageData) {
                        imageCache.setObject(img, forKey: urlString as AnyObject)
                        self.image = img
                    }
                }
            }
        }.resume()
    }
    
}
