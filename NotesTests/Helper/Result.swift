//
//  Result.swift
//  NotesTests
//
//  Created by Mike Haydan on 25/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import Foundation

@testable import Notes

extension Result: Equatable { }

public func ==<T>(lhs: Result<T>, rhs: Result<T>) -> Bool {
    // Shouldn't be used for PRODUCTION enum comparison. Good enough for unit tests.
    return String(stringInterpolationSegment: lhs) == String(stringInterpolationSegment: rhs)
}
