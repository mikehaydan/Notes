//
//  NoteNetworkServiceStub.swift
//  NotesTests
//
//  Created by Mike Haydan on 25/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import Foundation

@testable import Notes

final class NoteNetworkServiceStub: NoteNetworkService {
    
    var noteListResult: Result<[NoteModel]>!
    var noteResult: Result<NoteModel>!
    var removeResult: Result<VoidResponse>!
    
    func getAllNotes(completion: @escaping NotesListCompletion) {
        completion(noteListResult)
    }
    
    func updateNoteWith(id: Int, with text: String, completion: @escaping NoteCompletion) {
        completion(noteResult)
    }
    
    func createNoteWith(text: String, completion: @escaping NoteCompletion) {
        completion(noteResult)
    }
    
    func removeNoteWith(id: Int, completion: @escaping RemoveCompletion) {
        completion(removeResult)
    }
}
