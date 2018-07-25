//
//  EditNotePresenterTest.swift
//  NotesTests
//
//  Created by Mike Haydan on 25/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import Foundation

import XCTest
@testable import Notes

final class EditNotePresenterTest: XCTestCase {

    // MARK: - Properties
    
    let viewSpy: EditNoteViewSpy = EditNoteViewSpy()
    let networkService: NoteNetworkServiceStub = NoteNetworkServiceStub()
    let note = NoteApiModel.createNote().note
    let noteIndex = 0
    var presenter: EditNotePresenterImplementation!
    
    // MARK: - LifeCycle

    override func setUp() {
        super.setUp()
        presenter = EditNotePresenterImplementation(view: viewSpy, note: note, delegate: nil, noteNetworkService: networkService, noteIndex: noteIndex)
    }
    
    // MARK: - Tests
    
    func test_preparePresenter() {
        //given
        let expextedViewText = note.title
        
        //when
        presenter.preparePresenter()
        
        //then
        XCTAssert(expextedViewText == viewSpy.setText, "Displayed wrong title")
    }
    
    func test_saveEnabledFor_false() {
        //given
        let expectedResult = false
        let updatedText = note.title
        
        //when
        let result = presenter.saveEnabledFor(text: updatedText)
        
        //then
        XCTAssert(result == expectedResult, "Save should be dissabled")
    }
    
    func test_saveEnabledFor_true() {
        //given
        let expectedResult = true
        let updatedText = note.title + "qwe"
        
        //when
        let result = presenter.saveEnabledFor(text: updatedText)
        
        //then
        XCTAssert(result == expectedResult, "Save should be enabled")
    }
    
    func test_saveNoteWith_exptyText() {
        //given
        let updatedText = ""
        
        //when
        presenter.saveNoteWith(text: updatedText)
        
        //then
        XCTAssert(viewSpy.messageDisplayed == "EmptyTextMessage".localized, "Save should be dissabled")
    }
    
    func test_saveNoteWith_success() {
        //given
        let updatedText = "test"
        let expectedResult = Result.success(NoteModel(id: self.note.id, title: updatedText))
        networkService.noteResult = expectedResult
        
        //when
        presenter.saveNoteWith(text: updatedText)
        
        //then
        XCTAssert(viewSpy.messageDisplayed == "Success".localized)
    }
    
    func test_saveNoteWith_failure() {
        //given
        let updatedText = "test"
        let error = NSError.parseError
        networkService.noteResult = Result.failure(error)
        
        //when
        presenter.saveNoteWith(text: updatedText)
        
        //then
        XCTAssert(viewSpy.messageDisplayed == error.localizedDescription)
    }
}
