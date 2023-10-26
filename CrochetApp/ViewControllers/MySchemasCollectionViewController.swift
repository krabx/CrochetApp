//
//  MySchemasCollectionViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 15.08.2023.
//

import UIKit

final class MySchemasCollectionViewController: UICollectionViewController {
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchSchemas()
        collectionView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var name = ""
        var elements: [Element] = []
        var backgroundImageIndex = 0
        guard let schemaVC = segue.destination as? SchemaViewController else { return }
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        
        if !isFiltering {
            guard let setElements = savedSchemas[indexPath.item].elements as? Set<Element> else { return }
            elements = Array(setElements)
            name = savedSchemas[indexPath.item].name
            backgroundImageIndex = Int(savedSchemas[indexPath.item].backgroundImageIndex)
        } else {
            guard let setElements = filteringSchemas[indexPath.item].elements as? Set<Element> else { return }
            elements = Array(setElements)
            name = filteringSchemas[indexPath.item].name
            backgroundImageIndex = Int(filteringSchemas[indexPath.item].backgroundImageIndex)
        }

        schemaVC.saveElements = elements
        schemaVC.nameOfSaveSchema = name
        schemaVC.backgroundImageIndex = backgroundImageIndex
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isFiltering ? filteringSchemas.count : savedSchemas.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mySchema", for: indexPath) as? MySchemaCollectionViewCell else { return UICollectionViewCell() }
        
        if !isFiltering {
            cell.configure(for: savedSchemas[indexPath.item], with: indexPath)
        } else {
            cell.configure(for: filteringSchemas[indexPath.item], with: indexPath)
        }
        
        cell.delegate = self
        
        return cell
    }
}

// MARK: - Extension for UICollectionViewDelegateFlowLayout
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

// MARK: - Extension for private methods
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
        searchVC.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        searchVC.searchResultsUpdater = self
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchVC
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// MARK: - Extension for search
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

// MARK: - Extension for MySchemaCollectionViewCellDelegate
extension MySchemasCollectionViewController: MySchemaCollectionViewCellDelegate {
    func delete(item: MySchemaCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: item) else { return }
        
        if !isFiltering {
            storageManager.delete(schema: savedSchemas[indexPath.item])
            savedSchemas.remove(at: indexPath.item)
        } else {
            storageManager.delete(schema: filteringSchemas[indexPath.item])
            
            guard let index = savedSchemas.firstIndex(where: {$0 == filteringSchemas[indexPath.item]} ) else { return }
            
            filteringSchemas.remove(at: indexPath.item)
            savedSchemas.remove(at: index)
        }
        
        collectionView.deleteItems(at: [indexPath])
    }
}
