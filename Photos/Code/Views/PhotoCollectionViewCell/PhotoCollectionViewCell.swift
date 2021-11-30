//
//  PhotoCollectionViewCell.swift
//  Photos
//
//  Created by Kanan Abilzada on 30.11.21.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    var item: PhotoListModel?
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.center = self.contentView.center
        return indicator
    }()
    
    static let identifier = "PhotoCollectionViewCell"

    @IBOutlet weak var image: RemoteImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.addSubview(activityIndicator)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier,
                     bundle: Bundle.main)
    }

}
