//
//  NotesListViewController.swift
//  Notes
//
//  Created by Mike Haydan on 23/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import UIKit

private enum NoteListViewControllerConstants {
    static let itemCellIdentifier: String = "noteListCell"
}

final class NotesListViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    private var presenter: NotesListPresenter!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preparePresenter()
    }
    
    // MARK: - IBActions
    
    
    // MARK: - Private
    
    private func preparePresenter() {
        let noteNetworkService = NoteNetworkSerivceImplementation(apiClient: ApiClientImplementation.defaultConfiguration)
        presenter = NotesListPresenterImplementation(view: self, notesNetworkService: noteNetworkService)
        presenter.getData()
    }
    
    // MARK: - Public
}

// MARK: - UICollectionViewDataSource


//MARK: - UITableViewDataSource

extension NotesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dataSourceCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteListViewControllerConstants.itemCellIdentifier, for: indexPath)
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension NotesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let view = cell as! NoteListItemTableViewCellView
        presenter.confgigure(view: view, at: indexPath.row)
    }
}

// MARK: - NotesListView

extension NotesListViewController: NotesListView {
    
    func reloadUI() {
        tableView.reloadData()
    }
    
    func showLoader() {
        activityIndicatorView.startAnimating()
    }
    
    func hideLoader() {
        activityIndicatorView.stopAnimating()
    }
    
    func showAlert(message: String) {
        self.alert(message: message)
    }
}
