//
//  EditNotePresenter.swift
//  Notes
//
//  Created by Mike Haydan on 24/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import Foundation

protocol EditNoteDelegate: class {
    func noteWasUpdatedWith(text: String, by index: Int)
    func noteCreated(note: NoteModel)
}

protocol EditNoteView: BaseView {
    var presenter: EditNotePresenter! { get set }
    func showLoader()
    func hideLoader()
    func set(text: String)
    func popView()
}

protocol EditNotePresenter {
    func preparePresenter()
    func saveEnabledFor(text: String) -> Bool
    func saveNoteWith(text: String)
}

final class EditNotePresenterImplementation: EditNotePresenter {
    
    // MARK: - Properties
    
    private unowned let view: EditNoteView
    private weak var delegate: EditNoteDelegate?
    private var noteNetworkService: NoteNetworkService
    private let noteIndex: Int
    
    var note: NoteModel
    
    // MARK: - LifeCycle
    
    init(view: EditNoteView, note: NoteModel, delegate: EditNoteDelegate?, noteNetworkService: NoteNetworkService, noteIndex: Int) {
        self.view = view
        self.note = note
        self.delegate = delegate
        self.noteNetworkService = noteNetworkService
        self.noteIndex = noteIndex
    }
    
    // MARK: - Private
    
    
    // MARK: - Public
    
    func preparePresenter() {
        view.set(text: note.title)
    }
    
    func saveEnabledFor(text: String) -> Bool {
        return note.title != text
    }
    
    func saveNoteWith(text: String) {
        if text.isEmptyWithWhitespace {
            view.showAlert(message: "EmptyTextMessage".localized)
        } else {
            view.showLoader()
            noteNetworkService.updateNoteWith(id: note.id, with: text) { [weak self] (result) in
                if let strongSelf = self {
                    strongSelf.view.hideLoader()
                    switch result {
                    case .success:
                        strongSelf.view.showAlert(message: "Success".localized)
                        strongSelf.delegate?.noteWasUpdatedWith(text: text, by: strongSelf.noteIndex)
                    case let .failure(error):
                        strongSelf.view.showAlert(message: error.localizedDescription)
                    }
                }
            }
        }
    }
}
