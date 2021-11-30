//
//  ViewController.swift
//  Photos
//
//  Created by Kanan`s Macbook Pro on 11/30/21.
//

import UIKit

class PhotosViewController: UIViewController {
    // MARK: - Variables
    private var viewModel: PhotoListViewModel?
    
    // MARK: - IBOutlets
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
extension PhotosViewController {
    // MARK: Setup UI
    private func setupUI() {
        setupCollectionView()
        self.view.backgroundColor = .white
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCollectionViewCell.nib(),
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }

}

// MARK: - Setup ViewModel
extension PhotosViewController {
    private func setupViewModel() {
        viewModel = PhotoListViewModel()
        
        bindPhotoListToUI()
    }
}

// MARK: - Bind ViewModel To UI
extension PhotosViewController {
    private func bindPhotoListToUI() {
        viewModel?.photoList.bind({ data in
            self.runInMainThread {
                self.collectionView.reloadData()
            }
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
        
        let item = viewModel?.photoList.value[indexPath.row]
        cell.image.loadRemoteImageFrom(urlString: item?.urls?.full ?? "")
        
//        cell.item = viewModel?.photoList.value[indexPath.row]
        
        return cell
    }
}

extension PhotosViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 100)
    }
}

// - Display a grid of pictures. ( request #1)
// - The number of pictures in a row - 3.
// - Implement pagination in the list (no more than 10 pages)
// - Number of pictures per page - 30.
