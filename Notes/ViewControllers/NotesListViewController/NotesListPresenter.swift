//
//  NotesListPresenter.swift
//  Notes
//
//  Created by Mike Haydan on 23/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import Foundation

protocol NotesListView: BaseView {
    func prepareUI()
    func reloadUI()
    func showLoader()
    func hideLoader()
    func reloadUIAt(index: Int)
    func removeItemAt(index: Int)
}

protocol NotesListPresenter {
    var dataSourceCount: Int { get }
    func preparePresenter()
    func confgigure(view: NoteListItemTableViewCellView, at index: Int)
    func prepare(view: EditNoteView, withNoteAt index: Int)
    func prepare(view: CreateNoteView)
    func removeItemAt(index: Int)
    func getData()
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
    
    func preparePresenter() {
        view.prepareUI()
    }
    
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
    
    func removeItemAt(index: Int) {
        view.showLoader()
        let note = dataSource[index]
        notesNetworkService.removeNoteWith(id: note.id) { [weak self] (result) in
            if let strongSelf = self {
                strongSelf.view.hideLoader()
                switch result {
                case .success:
                    strongSelf.dataSource.remove(at: index)
                    strongSelf.view.removeItemAt(index: index)
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
    
    func prepare(view: EditNoteView, withNoteAt index: Int) {
        let note = dataSource[index]
        let presenter = EditNotePresenterImplementation(view: view,
                                                        note: note,
                                                        delegate: self,
                                                        noteNetworkService: notesNetworkService,
                                                        noteIndex: index)
        view.presenter = presenter
    }
    
    func prepare(view: CreateNoteView) {
        let presenter = CreateNotePresenterImplementation(view: view, delegate: self, noteNetworkService: notesNetworkService)
        view.presenter = presenter
    }
}

// MARK: - EditNoteDelegate

extension NotesListPresenterImplementation: EditNoteDelegate {
    
    func noteWasUpdatedWith(text: String, at index: Int) {
        self.dataSource[index].title = text
        view.reloadUIAt(index: index)
    }
    
    func noteCreated(note: NoteModel) {
        self.dataSource.append(note)
        view.reloadUI()
    }
}
