//
//  NoteListItemTableViewCellViewSpy.swift
//  NotesTests
//
//  Created by Mike Haydan on 25/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import Foundation

@testable import Notes

final class NoteListItemTableViewCellViewSpy: NoteListItemTableViewCellView {
    
    var displayedTitle: String = ""
    
    func set(title: String) {
        displayedTitle = title
    }
}
