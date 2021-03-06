//
//  ViewController.swift
//  Photos
//
//  Created by Kanan`s Macbook Pro on 11/30/21.
//

import UIKit
import SimpleImageViewer

class PhotosViewController: UIViewController, Storyboarded {
    // MARK: - Variables
    private var viewModel: PhotoListViewModel?
    private var cachedImages: [Int: UIImage] = [:]
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var currentPageButton: UIButton!
    
    // MARK: - Main methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setupViewModel()
    }

    // MARK: - IBActions
    @IBAction func nextPageClicked(_ sender: UIButton) {
        if viewModel!.currentPage.value < viewModel!.maxPageCount {
            viewModel?.photoList.value = []
            self.cachedImages = [:]
            viewModel?.currentPage.value += 1
            viewModel?.loadImages(currentPage: viewModel?.currentPage.value ?? 1)
        }
    }
    
    @IBAction func searchClicked(_ sender: UIBarButtonItem) {
        let vc = SearchPhotoViewController.instantiate(storyboard: "Search")
        vc.title = "Search"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Setup
extension PhotosViewController {
    // MARK: Setup UI
    private func setupUI() {
        setupCollectionView()
        
        addGestureToViewForDismissSearchBar()
        self.view.backgroundColor = .white
    }
    
    private func addGestureToViewForDismissSearchBar() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.handleViewClicking(_:)))
        self.view.addGestureRecognizer(gesture)
    }
    
    private func setupCollectionView() {
        collectionView.register(PhotoCollectionViewCell.nib(),
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        collectionView.collectionViewLayout = createCollectionViewLayout()
        
        collectionView.delegate   = self
        collectionView.dataSource = self
    }
}

// MARK: - Handle user interactions
extension PhotosViewController {
    @objc
    func handleViewClicking(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
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

// MARK: - Setup ViewModel
extension PhotosViewController {
    private func setupViewModel() {
        viewModel = PhotoListViewModel()
        
        bindPhotoListToUI()
        bindImageLoader()
    }
}

// MARK: - Bind ViewModel To UI
extension PhotosViewController {
    /// bind all loaded photos
    private func bindPhotoListToUI() {
        viewModel?.photoList.bind({ [weak self] data in
            print("photoListUpdated")
            self?.runInMainThread {
                self?.cachedImages = [:]
                self?.currentPageButton.setTitle("> Page \(self?.viewModel?.currentPage.value ?? 1)", for: .normal)
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
extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photoList.value.count ?? 0
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier,
                                                            for: indexPath) as? PhotoCollectionViewCell else {
            fatalError()
        }
        cell.name.text = viewModel?.photoList.value[indexPath.row].user?.name ?? ""
        
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
        layout.itemSize = Dimensions.photosItemSize
        let numberOfCellsInRow = floor(Dimensions.screenWidth / Dimensions.photosItemSize.width)
        let inset = (Dimensions.screenWidth - (numberOfCellsInRow * Dimensions.photosItemSize.width)) / (numberOfCellsInRow + 1)
        layout.sectionInset = .init(top: inset,
                                    left: inset,
                                    bottom: inset,
                                    right: inset)
        return layout
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("selected item...")
////        let imageView = UIImageView()
////
////        let imageURL = viewModel?.photoList.value[indexPath.row].urls?.regular ?? ""
////        imageView.setupImageViewer(url: URL(string: imageURL)!)
//    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellCount = 2

        let totalCellWidth = (Int(self.view.frame.size.width / 2) - 10) * cellCount
        let totalSpacingWidth = 10 * (cellCount - 1)

        let leftInset = (collectionView.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}
