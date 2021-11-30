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
        self.view.backgroundColor = .white
    }
    
    private func setupViewModel() {
        viewModel = PhotoListViewModel()
        
        
    }
    
    // MARK: Setup ViewModel
}
