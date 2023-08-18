//
//  MySchemasCollectionViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 15.08.2023.
//

import UIKit

class MySchemasCollectionViewController: UICollectionViewController {
    
    private let itemsForRow: CGFloat = 1
    
    private let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    private let storageManager = StorageManager.shared
    
    private var savedSchemas: [Schema] = []
    
    private var filteringSchemas: [Schema] = []
    
    private let searchVC = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let searchText = searchVC.searchBar.text?.isEmpty else { return false }
        return searchText
    }
    private var isFiltering: Bool {
        searchVC.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
        fetchSchemas()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var name = ""
        var elements: [Element] = []
        guard let schemaVC = segue.destination as? SchemaViewController else { return }
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        if !isFiltering {
            guard let setElements = savedSchemas[indexPath.item].elements as? Set<Element> else { return }
            elements = Array(setElements)
            name = savedSchemas[indexPath.item].name
        } else {
            guard let setElements = filteringSchemas[indexPath.item].elements as? Set<Element> else { return }
            elements = Array(setElements)
            name = filteringSchemas[indexPath.item].name
        }

        schemaVC.saveElements = elements
        schemaVC.nameOfSaveSchema = name
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        isFiltering ? filteringSchemas.count : savedSchemas.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mySchema", for: indexPath) as? MySchemaCollectionViewCell else { return UICollectionViewCell() }
    
        // Configure the cell
        if !isFiltering {
            cell.configure(for: savedSchemas[indexPath.item])
        } else {
            cell.configure(for: filteringSchemas[indexPath.item])
        }
        
        let deleteCell = UIAction { [unowned self] _ in
            self.storageManager.delete(schema: savedSchemas[indexPath.item])
            
            if !isFiltering {
                savedSchemas.remove(at: indexPath.item)
            } else {
                filteringSchemas.remove(at: indexPath.item)
            }
            
            collectionView.deleteItems(at: [indexPath])
            collectionView.reloadData()
        }
        
        cell.deleteButton.addAction(deleteCell, for: .touchUpInside)
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}

extension MySchemasCollectionViewController: UICollectionViewDelegateFlowLayout {
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

extension MySchemasCollectionViewController {
    private func fetchSchemas() {
        storageManager.fetchSchemas { result in
            switch result {
            case .success(let schemas):
                savedSchemas = schemas
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupSearch() {
        searchVC.searchResultsUpdater = self
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchVC
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }

}

extension MySchemasCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteringBySearch(searchController.searchBar.text ?? "")
    }
    
    func filteringBySearch(_ searchRequest: String) {
        filteringSchemas = savedSchemas.filter({ schema in
            schema.name.lowercased().contains(searchRequest.lowercased())
        })
        collectionView.reloadData()
    }
}
