//
//  Note.swift
//  NotesTests
//
//  Created by Mike Haydan on 25/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import Foundation

@testable import Notes

extension NoteApiModel {
    static func createNoteApiArray(numberOfElements: Int = 2) -> [NoteApiModel] {
        var notes: [NoteApiModel] = []
        
        for i in 0..<numberOfElements {
            let note = createNote(index: i)
            notes.append(note)
        }
        
        return notes
    }
    
    static func createNoteArray(numberOfElements: Int = 2) -> [NoteModel] {
        return createNoteApiArray(numberOfElements: numberOfElements).map({ $0.note })
    }
    
    static func createNote(index: Int = 0) -> NoteApiModel {
        return NoteApiModel(id: Int(arc4random()), title: "title: \(index)")
    }
}
