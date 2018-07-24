//
//  String + Extensions.swift
//  Notes
//
//  Created by Mike Haydan on 24/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import Foundation

extension String {
    
    var isEmptyWithWhitespace: Bool {
        return self.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
    }
}
