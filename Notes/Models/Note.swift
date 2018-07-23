//
//  Note.swift
//  Notes
//
//  Created by Mike Haydan on 23/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import Foundation

struct NoteApiModel: InitializableCodable {
    let id: Int
    let title: String?
    
    var note: NoteModel {
        return NoteModel(id: id, title: title ?? "")
    }
}

struct NoteModel {
    let id: Int
    let title: String
}
