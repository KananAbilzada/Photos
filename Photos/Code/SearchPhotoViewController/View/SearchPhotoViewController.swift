//
//  SearchPhotoViewController.swift
//  Photos
//
//  Created by Kanan Abilzada on 01.12.21.
//

import UIKit
import SimpleImageViewer

class SearchPhotoViewController: UIViewController, Storyboarded {
    // MARK: - Variables
    private var viewModel: SearchPhotoViewModel?
    private var cachedImages: [Int: UIImage] = [:]
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Main methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setupViewModel()
    }

}

// MARK: - Setup
extension SearchPhotoViewController {
    // MARK: Setup UI
    private func setupUI() {
        setupCollectionView()
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView.register(PhotoCollectionViewCell.nib(),
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.collectionViewLayout = createCollectionViewLayout()
    }

}

// MARK: - Setup ViewModel
extension SearchPhotoViewController {
    private func setupViewModel() {
        viewModel = SearchPhotoViewModel()
        
        bindPhotoListToUI()
        bindImageLoader()
    }
}

// MARK: - User Interactions
extension SearchPhotoViewController {
    // for cell click
    @objc func handleContentViewClick(_ gesture: UITapGestureRecognizer) {
        let p = gesture.location(in: collectionView)
        
        if let indexPath = collectionView.indexPathForItem(at: p) {
            
            let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
            
            let configuration = ImageViewerConfiguration { config in
                config.imageView = cell.imageView
            }

            let imageViewerController = ImageViewerController(configuration: configuration)

            present(imageViewerController, animated: true)
        }
    }
}

// MARK: - Bind ViewModel To UI
extension SearchPhotoViewController {
    /// bind all loaded photos
    private func bindPhotoListToUI() {
        viewModel?.photoList.bind({ [weak self] data in
            self?.runInMainThread {
                self?.collectionView.reloadData()
            }
        })
    }
    
    
    /// bind loaded image to cell
    private func bindImageLoader() {
        viewModel?.imageRetrievedSuccess.bind({ [weak self] (index, image) in
            self?.runInMainThread {
                print("imageRetrievedSuccess")
                if let cell = self?.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? PhotoCollectionViewCell {
                    // 1
                    cell.activityIndicator.stopAnimating()
                    
                    // 2
                    cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    UIView.animate(withDuration: 0.45) {
                        cell.transform = .identity
                    }
                    
                    // 3
                    cell.imageView.image = image
                }
            }
            
            self?.cachedImages[index] = image
        })
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photoList.value?.results?.count ?? 0
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier,
                                                            for: indexPath) as? PhotoCollectionViewCell else {
            fatalError()
        }
                
        cell.name.text = viewModel?.photoList.value?.results?[indexPath.row].user?.name ?? ""
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleContentViewClick(_:)))
        cell.contentView.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let photoCell = cell as? PhotoCollectionViewCell {
            if let image = self.cachedImages[indexPath.row] {
                photoCell.imageView.image = image
            } else {
                // load new image
                viewModel?.loadImageFromGivenItem(with: indexPath.row)
                photoCell.activityIndicator.startAnimating()
            }
        }
    }
    
    func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.view.frame.size.width - 20, height: Dimensions.screenWidth * 0.55)
        let numberOfCellsInRow = floor(Dimensions.screenWidth / Dimensions.photosItemSize.width)
        let inset = (Dimensions.screenWidth - (numberOfCellsInRow * Dimensions.photosItemSize.width)) / (numberOfCellsInRow + 1)
        layout.sectionInset = .init(top: inset,
                                    left: inset,
                                    bottom: inset,
                                    right: inset)
        return layout
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchPhotoViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellCount = 2

        let totalCellWidth = (Int(self.view.frame.size.width / 2) - 10) * cellCount
        let totalSpacingWidth = 10 * (cellCount - 1)

        let leftInset = (collectionView.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}

// MARK: - UISearchBarDelegate
extension SearchPhotoViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 3 {
            viewModel?.searchImage(query: searchText)
        } else {
            viewModel?.photoList.value = nil
        }
    }
}

    // Default State
// - Display a grid of pictures. ( request #1) +
// - The number of pictures in a row - 3. +
// - Implement pagination in the list (no more than 10 pages) +
// - Number of pictures per page - 30. +

    //Search by name:
// - Implement search. ( request #2)
// - The request should be sent, if was entered more than three characters
// - The number of pictures in a row - 1.
// - Needs to implement removing of pictures in the search mode. Removing is relevant only for the current search result
