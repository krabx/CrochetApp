//
//  ElementListViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 23.06.2023.
//

import UIKit

final class ElementListViewController: UIViewController {
    let dataManager = DataManager.shared
    var standarts: [Data] = []

    @IBOutlet var elementListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elementListCollectionView.dataSource = self
        elementListCollectionView.delegate = self
        rendererViewToData()
    }

}

extension ElementListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        standarts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "elementCell", for: indexPath) as? ElementCollectionViewCell else { return UICollectionViewCell() }
        //cell.elementImageView.image = UIImage(systemName: "square.and.arrow.up")
        cell.elementImageView.image = UIImage(data: standarts[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}

extension ElementListViewController {
    private func rendererViewToData() {
        let standardElements = dataManager.standard

        for standardElement in standardElements {
            let renderer = UIGraphicsImageRenderer(size: standardElement.bounds.size)
            let data = renderer.pngData { ctx in
                standardElement.drawHierarchy(in: standardElement.bounds, afterScreenUpdates: true)
            }
            
            standarts.append(data)
        }
    }
}