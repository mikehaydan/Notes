//
//  EditNoteViewSpy.swift
//  NotesTests
//
//  Created by Mike Haydan on 25/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import Foundation

@testable import Notes

final class EditNoteViewSpy: EditNoteView {
    
    var presenter: EditNotePresenter!
    var loaderShowed: Bool = false
    var viewPopped: Bool = false
    var setText: String = ""
    var messageDisplayed: String = ""
    
    func showLoader() {
        loaderShowed = true
    }
    
    func hideLoader() {
        loaderShowed = false
    }
    
    func set(text: String) {
        setText = text
    }
    
    func popView() {
        viewPopped = true
    }
    
    func showAlert(message: String) {
        messageDisplayed = message
    }
}
