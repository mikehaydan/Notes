//
//  NotesListViewSpy.swift
//  NotesTests
//
//  Created by Mike Haydan on 25/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import Foundation
@testable import Notes

final class NotesListViewSpy: NotesListView {
    
    var viewReloaded: Bool = false
    var loaderShowed: Bool = false
    var uiPrepared: Bool = false
    var messageShowed: String = ""
    var reloadedIndex: Int!
    var removedIndex: Int!
    
    func reloadUI() {
        viewReloaded = true
    }
    
    func showLoader() {
        loaderShowed = true
    }
    
    func hideLoader() {
        loaderShowed = false
    }
    
    func reloadUIAt(index: Int) {
        reloadedIndex = index
    }
    
    func removeItemAt(index: Int) {
        removedIndex = index
    }
    
    func showAlert(message: String) {
        messageShowed = message
    }
    
    func prepareUI() {
        uiPrepared = true
    }
}
