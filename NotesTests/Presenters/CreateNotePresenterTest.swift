//
//  CreateNotePresenterTest.swift
//  NotesTests
//
//  Created by Mike Haydan on 25/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import XCTest
@testable import Notes

final class CreateNotePresenterText: XCTestCase {
    
    // MARK: - Properties
    
    let viewSpy: NotesListViewSpy = NotesListViewSpy()
    let networkService: NoteNetworkServiceStub = NoteNetworkServiceStub()
    var presenter: NotesListPresenterImplementation!
    
    // MARK: - LifeCycle
    
    override func setUp() {
        super.setUp()
        
        presenter = NotesListPresenterImplementation(view: viewSpy, notesNetworkService: networkService)
    }
    
    // MARK: - Tests
    
    func test_preparePresenter() {
        //given
        let expectedUiPreparedresult = true
        
        //when
        presenter.preparePresenter()
        
        //then
        XCTAssert(viewSpy.uiPrepared == expectedUiPreparedresult, "UI is not prepared")
    }
    
    func test_getData_success() {
        //given
        let notes = NoteApiModel.createNoteArray()
        networkService.noteListResult = Result.success(notes)
        
        //when
        presenter.getData()
        
        //then
        XCTAssert(viewSpy.viewReloaded, "Refresh table view is not called")
        XCTAssert(presenter.dataSourceCount == notes.count, "Data source count is note correct")
        XCTAssert(!viewSpy.loaderShowed, "Loader should be hidden")
        
    }
    
    func test_getData_failure() {
        //given
        let error = NSError.parseError
        networkService.noteListResult = Result.failure(error)
        
        //when
        presenter.getData()
        
        //then
        XCTAssert(viewSpy.messageShowed == error.localizedDescription, "Displayed not correct error message")
    }
    
    func test_removeItemAt_success() {
        //given
        let notes = NoteApiModel.createNoteArray()
        let indexToRemove = 0
        presenter.dataSource = notes
        networkService.removeResult = Result.success(try! VoidResponse(data: nil))
    
        //when
        presenter.removeItemAt(index: indexToRemove)
        
        //then
        XCTAssert(viewSpy.removedIndex == indexToRemove, "Wrong removed index")
        XCTAssert(presenter.dataSource[indexToRemove].id != notes[indexToRemove].id, "Wrong removed id")
    }
    
    func test_removeItemAt_failure() {
        //given
        let notes = NoteApiModel.createNoteArray()
        let indexToRemove = 0
        let error = NSError.parseError
        presenter.dataSource = notes
        networkService.removeResult = Result.failure(error)
        
        //when
        presenter.removeItemAt(index: indexToRemove)
        
        //then
        XCTAssert(viewSpy.messageShowed == error.localizedDescription, "Displayed not correct error message")
    }
    
    func test_configureNoteListItemTableViewCellView() {
        //given
        let notes = NoteApiModel.createNoteArray()
        let configureIndex = 0
        let expectedNote = notes[configureIndex]
        let cellViewSpy = NoteListItemTableViewCellViewSpy()
        presenter.dataSource = notes
        
        //when
        presenter.confgigure(view: cellViewSpy, at: configureIndex)
        
        //then
        XCTAssert(cellViewSpy.displayedTitle == expectedNote.title, "Displayed not correct title")
    }
    
    func test_prepareEditNoteView() {
        //given
        let notes = NoteApiModel.createNoteArray()
        let configureIndex = 0
        let expectedNote = notes[configureIndex]
        let editNoteViewSpy = EditNoteViewSpy()
        presenter.dataSource = notes
        
        //when
        presenter.prepare(view: editNoteViewSpy, withNoteAt: configureIndex)
        editNoteViewSpy.presenter.preparePresenter()
        
        //then
        XCTAssert(editNoteViewSpy.presenter != nil, "Edit note presenter not configured")
        XCTAssert(editNoteViewSpy.setText == expectedNote.title, "Displayed not correct title")
    }
    
    func test_prepareCreateNoteView() {
        //given
        let createNoteViewSpy = CreateNoteViewSpy()
        
        //when
        presenter.prepare(view: createNoteViewSpy)
        
        //then
        XCTAssert(createNoteViewSpy.presenter != nil, "Create note presenter not configured")
    }
    
    func test_noteWasUpdatedWithText() {
        //given
        let notes = NoteApiModel.createNoteArray()
        let updateNoteIndex = 0
        let updateText = "Update title"
        presenter.dataSource = notes
        
        //when
        presenter.noteWasUpdatedWith(text: updateText, at: updateNoteIndex)
        
        //then
        XCTAssert(viewSpy.reloadedIndex == updateNoteIndex, "Wrong reloaded index")
        XCTAssert(presenter.dataSource[updateNoteIndex].title == updateText, "Wrong updated item")
    }
    
    func test_noteCreated() {
        //given
        let noteAdd = NoteApiModel.createNoteArray().first!
        let expectedResultCount = presenter.dataSourceCount + 1
        
        //when
        presenter.noteCreated(note: noteAdd)
        
        //then
        XCTAssert(viewSpy.viewReloaded, "UI is not reloaded")
        XCTAssert(presenter.dataSourceCount == expectedResultCount, "Not correct number of items")
    }
}
