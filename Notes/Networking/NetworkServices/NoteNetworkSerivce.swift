//
//  NoteNetworkSerivce.swift
//  Notes
//
//  Created by Mike Haydan on 23/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import Foundation

typealias NotesListCompletion = (Result<[NoteModel]>) -> ()

protocol NoteNetworkService {
    func getAllNotes(completion: @escaping NotesListCompletion)
}

final class NoteNetworkSerivceImplementation: NoteNetworkService {
    
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
}
