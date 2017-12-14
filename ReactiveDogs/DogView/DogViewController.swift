//
//  ViewController.swift
//  ReactiveDogs
//
//  Created by Marcel Chaucer on 12/8/17.
//  Copyright © 2017 Marcel Chaucer. All rights reserved.
//

import UIKit
import Alamofire
import ReactiveSwift
import Result
import ReactiveCocoa

enum DogDisplayType: Int {
    case large, grid, list
    
    var sectionInsets: UIEdgeInsets {
        switch self {
        case .list:
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        case .grid:
            return UIEdgeInsets(top: 10.0, left: 5.0, bottom: 10.0, right: 5.0)
        case .large:
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        }
    }
    
    var itemsPerRow: CGFloat {
        switch self {
        case .large, .list:
            return 1
        case .grid:
            return 3
        }
    }
    
    var heightMultiplier: CGFloat {
        switch self {
        case .list:
            return 0.33
        case .grid:
            return 1
        case .large:
            return 2
        }
    }
    
    var cellIdentifier: String {
        switch self {
        case .list:
            return "listDogCell"
        case .grid:
            return "gridDogCell"
        case .large:
            return "largeDogCell"
        }
    }
}


class DogViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
  
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var displayType: DogDisplayType = .large
    
    var viewModel: DogViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DogViewModel()
        reloadTableView()
        
        segmentedControl.reactive.selectedSegmentIndexes.observe(on: UIScheduler()).observeValues { [weak self] index in
            if let displayType = DogDisplayType(rawValue: index) {
                self?.displayType = displayType
                let indexPath = IndexPath(item: 0, section: 0)
                self?.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                print(displayType)
            }
            self?.collectionView.reloadData()
        }
    }
    
    func reloadTableView() {
        viewModel.dogsPipe.output.observe {(_) in
            print("Signal from View Model")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    

    //UICollectionView Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellVM = viewModel.fetchCellViewModel(at: indexPath)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DogDetailPage, let cell = sender as? DogCollectionViewCell {
            
            let cellAtIndexPath = collectionView.indexPath(for: cell)
            let cellVM = viewModel.fetchCellViewModel(at: cellAtIndexPath!)
            destination.image = cell.dogImage.image
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.itemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dogDisplay" , for: indexPath) as! DogCollectionViewCell
        let cellVM = viewModel.fetchCellViewModel(at: indexPath)
        cell.viewModel = cellVM
        
        return cell
    }
}

extension DogViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = displayType.sectionInsets.left * (displayType.itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / displayType.itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem * displayType.heightMultiplier)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return displayType.sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return displayType.sectionInsets
    }
}
