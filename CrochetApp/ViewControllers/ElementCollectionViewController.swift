//
//  ElementCollectionViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 08.08.2023.
//

import UIKit

class ElementCollectionViewController: UICollectionViewController {
    
    private let dataManager = DataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataManager.categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataManager.getCountCollection(from: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "elementView", for: indexPath)
            guard let typedHeaderView = headerView as? ElementCollectionReusableView else { return headerView }
            typedHeaderView.categoryLabel.text = dataManager.categories[indexPath.section]
            return typedHeaderView
        default:
            return UICollectionReusableView()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "elementCell", for: indexPath) as? ElementCollectionViewCell else { return UICollectionViewCell() }
        let currentCollection = dataManager.getCollection(from: indexPath.section)
        cell.elementImageView.image = UIImage(named: currentCollection[indexPath.item])
        // Configure the cell
    
        return cell
    }
    


    // MARK: UICollectionViewDelegate

}
