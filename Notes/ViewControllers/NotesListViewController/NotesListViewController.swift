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
    static let editNoteIdentifier: String = "editNote"
    static let createNoteIdentifier: String = "createNote"
}

final class NotesListViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private var presenter: NotesListPresenter!
    private var selectedNoteIndex: Int = 0
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preparePresenter()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == NoteListViewControllerConstants.editNoteIdentifier {
            let controller = segue.destination as! EditNoteViewController
            presenter.prepare(view: controller, withNoteAt: selectedNoteIndex)
        } else if segue.identifier == NoteListViewControllerConstants.createNoteIdentifier {
            let controller = segue.destination as! CreateNoteViewController
            presenter.prepare(view: controller)
        }
        
        super.prepare(for: segue, sender: sender)
    }
    
    // MARK: - IBActions
    
    @IBAction private func createNoteAction(_ sender: Any) {
        performSegue(withIdentifier: NoteListViewControllerConstants.createNoteIdentifier, sender: nil)
    }
    
    @IBAction private func setEditingAction(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    @IBAction private func refreshAction() {
        presenter.getData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Private
    
    private func preparePresenter() {
        let noteNetworkService = NoteNetworkSerivceImplementation(apiClient: ApiClientImplementation.defaultConfiguration)
        presenter = NotesListPresenterImplementation(view: self, notesNetworkService: noteNetworkService)
        presenter.preparePresenter()
        presenter.getData()
    }
    
    // MARK: - Public
}

//MARK: - UITableViewDataSource

extension NotesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dataSourceCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteListViewControllerConstants.itemCellIdentifier, for: indexPath)
        let view = cell as! NoteListItemTableViewCellView
        presenter.confgigure(view: view, at: indexPath.row)
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension NotesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedNoteIndex = indexPath.row
        
        self.performSegue(withIdentifier: NoteListViewControllerConstants.editNoteIdentifier, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return tableView.isEditing ? .delete : .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        presenter.removeItemAt(index: indexPath.row)
    }
}

// MARK: - NotesListView

extension NotesListViewController: NotesListView {
    
    func prepareUI() {
        refreshControl.isEnabled = false
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
    }
    
    func removeItemAt(index: Int) {
        tableView.beginUpdates()
        let indexPath = IndexPath(item: index, section: 0)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func reloadUI() {
        tableView.reloadData()
    }
    
    func showLoader() {
        view.isUserInteractionEnabled = false
        activityIndicatorView.startAnimating()
    }
    
    func hideLoader() {
        view.isUserInteractionEnabled = true
        activityIndicatorView.stopAnimating()
    }
    
    func reloadUIAt(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
