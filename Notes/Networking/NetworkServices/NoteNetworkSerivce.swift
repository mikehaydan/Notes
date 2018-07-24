//
//  NoteNetworkSerivce.swift
//  Notes
//
//  Created by Mike Haydan on 23/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import Foundation

typealias NotesListCompletion = (Result<[NoteModel]>) -> ()
typealias NoteCompletion = (Result<NoteModel>) -> ()
typealias RemoveCompletion = (Result<VoidResponse>) -> ()

protocol NoteNetworkService {
    func getAllNotes(completion: @escaping NotesListCompletion)
    func updateNoteWith(id: Int, with text: String, completion: @escaping NoteCompletion)
    func createNoteWith(text: String, completion: @escaping NoteCompletion)
    func removeNoteWith(id: Int, completion: @escaping RemoveCompletion)
}

final class NoteNetworkSerivceImplementation: NoteNetworkService {
    
    enum Keys {
        static let title: String = "title"
    }
    
    // MARK: - Properties
    
    private let apiClient: ApiClient
    
    // MARK: - LifeCycle
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public
    
    func getAllNotes(completion: @escaping NotesListCompletion) {
        let request = URLRequest.requestWithURL(path: Urls.notes)
        apiClient.execute(request: request) { (result: Result<ApiResponse<[NoteApiModel]>>) in
            switch result {
            case let .success(response):
                let resultToBeReturned = response.entity.map({ $0.note })
                completion(.success(resultToBeReturned))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func updateNoteWith(id: Int, with text: String, completion: @escaping NoteCompletion) {
        let params = [Keys.title: text]
        let url = Urls.noteBy(id: id)
        let request = URLRequest.requestWithURL(path: url, method: .put, bodyParameters: params)
        apiClient.execute(request: request) { (result: Result<ApiResponse<NoteApiModel>>) in
            switch result {
            case let .success(response):
                let resultToBeReturned = response.entity.note
                completion(.success(resultToBeReturned))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func createNoteWith(text: String, completion: @escaping NoteCompletion) {
        let params = [Keys.title: text]
        let url = Urls.notes
        let request = URLRequest.requestWithURL(path: url, method: .post, bodyParameters: params)
        apiClient.execute(request: request) { (result: Result<ApiResponse<NoteApiModel>>) in
            switch result {
            case let .success(response):
                let resultToBeReturned = response.entity.note
                completion(.success(resultToBeReturned))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func removeNoteWith(id: Int, completion: @escaping RemoveCompletion) {
        let url = Urls.noteBy(id: id)
        let request = URLRequest.requestWithURL(path: url, method: .delete)
        apiClient.execute(request: request) { (result: Result<ApiResponse<VoidResponse>>) in
            switch result {
            case let .success(response):
                completion(.success(response.entity))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
