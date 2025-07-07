//
//  DefaultDispatchQueueProvider.swift
//  Git Users
//
//  Created by Long Do on 31/12/2024.
//

import Foundation

public class DefaultDispatchQueueProvider: DispatchQueueProvider {

    public init() {}

    public var backgroundQueue: DispatchQueue {
        DispatchQueue.global(qos: .userInitiated) // Background queue for tasks
    }

    public var mainQueue: DispatchQueue {
        DispatchQueue.main // Main queue for UI updates
    }
}
