//
//  Urls.swift
//  Notes
//
//  Created by Mike Haydan on 09/06/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import Foundation

enum Urls {
    private static let baseUrlString: String = "https://private-9aad-note10.apiary-mock.com"
    
    static let baseUrl: URL = URL(string: baseUrlString)!
    static let notes: String = "/notes"
}
