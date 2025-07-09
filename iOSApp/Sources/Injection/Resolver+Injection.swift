//
//  Resolver+Injection.swift
//  Git Users
//
//  Created by Do, LongThanh | MDSD on 2024/11/25.
//

import Data
import DesignSystem
import Foundation
import AlarmMe
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        defaultScope = .graph

        registerGitUserServices()
        registerJson()
        registerNetwork()
        registerDispatchQueueProvider()
    }

    private static func registerJson() {
        register(JSONDecoder.self) { JSONDecoder() }.scope(.application)
    }

    private static func registerNetwork() {
        register(NetworkAPIProtocol.self) { NetworkAPI(decoder: resolve()) }
    }

    private static func registerDispatchQueueProvider() {
        register(DispatchQueueProvider.self) { DefaultDispatchQueueProvider() }
    }
}
