//
//  MockDispatchQueueProvider.swift
//  DataTests
//
//  Created by Long Do on 01/01/2025.
//

@testable import DesignSystem
import Foundation

class MockDispatchQueueProvider: DispatchQueueProvider {
    var backgroundQueue: DispatchQueue = .main
    var mainQueue: DispatchQueue = .main
}
