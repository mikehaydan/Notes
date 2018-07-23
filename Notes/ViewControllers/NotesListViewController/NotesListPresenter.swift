//
//  NotesListPresenter.swift
//  Notes
//
//  Created by Mike Haydan on 23/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import Foundation

protocol NotesListView: class {
    func reloadUI()
    func showLoader()
    func hideLoader()
    func showAlert(message: String)
}

protocol NotesListPresenter {
    var dataSourceCount: Int { get }
    func getData()
    func confgigure(view: NoteListItemTableViewCellView, at index: Int)
}

final class NotesListPresenterImplementation: NotesListPresenter {
    
    // MARK: - Properties
    
    private unowned let view: NotesListView
    private let notesNetworkService: NoteNetworkService
    
    var dataSource: [NoteModel] = []
    var dataSourceCount: Int {
        return dataSource.count
    }
    
    // MARK: - LifeCycle
    
    init(view: NotesListView, notesNetworkService: NoteNetworkService) {
        self.view = view
        self.notesNetworkService = notesNetworkService
    }
    
    // MARK: - Private
    
    
    // MARK: - Public
    
    func getData() {
        view.showLoader()
        notesNetworkService.getAllNotes { [weak self] (result) in
            if let strongSelf = self {
                strongSelf.view.hideLoader()
                switch result {
                case let .success(response):
                    strongSelf.dataSource = response
                    strongSelf.view.reloadUI()
                case let .failure(error):
                    strongSelf.view.showAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    func confgigure(view: NoteListItemTableViewCellView, at index: Int) {
        let model = dataSource[index]
        view.set(title: model.title)
    }
}
