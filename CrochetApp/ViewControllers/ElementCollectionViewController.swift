//
//  ElementCollectionViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 08.08.2023.
//

import UIKit

final class ElementCollectionViewController: UICollectionViewController {
    unowned var delegate: ElementCollectionViewControllerDelegate?
    
    private let dataManager = DataManager.shared
    
    private let itemsForRow: CGFloat = 5
    
    private let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    private var selectedElements: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
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

        return cell
    }

    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let element = dataManager.getCollection(from: indexPath.section)[indexPath.item]
        selectedElements.append(element)
    }
    
    deinit {
        delegate?.getUsage(elements: selectedElements)
    }
}

// MARK: - Extension for UICollectionViewDelegateFlowLayout
extension ElementCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = sectionInsets.top * (itemsForRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthForItem = availableWidth / itemsForRow
        return CGSize(width: widthForItem, height: widthForItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInsets.top
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        sectionInsets.top
    }
}
