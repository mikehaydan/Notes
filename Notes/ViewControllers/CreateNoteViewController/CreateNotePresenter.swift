//
//  CreateNotePresenter.swift
//  Notes
//
//  Created by Mike Haydan on 24/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import Foundation

protocol CreateNoteView: EditNoteView {
    
}

final class CreateNotePresenterImplementation: EditNotePresenter {
    
    // MARK: - Properties
    
    private unowned let view: EditNoteView
    private weak var delegate: EditNoteDelegate?
    private var noteNetworkService: NoteNetworkService
    
    // MARK: - LifeCycle
    
    init(view: EditNoteView, delegate: EditNoteDelegate?, noteNetworkService: NoteNetworkService) {
        self.view = view
        self.delegate = delegate
        self.noteNetworkService = noteNetworkService
    }
    
    // MARK: - Public
    
    func preparePresenter() {
        
    }
    
    func saveEnabledFor(text: String) -> Bool {
        return true
    }
    
    func saveNoteWith(text: String) {
        if text.isEmptyWithWhitespace {
            view.showAlert(message: text)
        } else {
            view.showLoader()
            noteNetworkService.createNoteWith(text: text) { [weak self] (result) in
                if let strongSelf = self {
                    switch result {
                    case let .success(response):
                        strongSelf.delegate?.noteCreated(note: response)
                        strongSelf.view.popView()
                    case let .failure(error):
                        strongSelf.view.showAlert(message: error.localizedDescription)
                    }
                }
            }
        }
    }
}


