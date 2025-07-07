//
//  GitUserModule.swift
//  GitUser
//
//  Created by Long Do on 3/7/25.
//

import Foundation
import Resolver

extension Resolver {
    public static func registerGitUserServices() {
        defaultScope = .graph

        registerLocalSource()
        registerRepositories()
        registerUseCases()
        registerMappers()
        registerViewModel()
    }

    private static func registerLocalSource() {
        register(GitUserLocalSource.self) { GitUserLocalSourceImpl() }
        register(GitUserDetailLocalSource.self) { GitUserDetailLocalSourceImpl() }
    }

    private static func registerRepositories() {
        register(GitUserRepository.self) { GitUserRepositoryImpl(networkAPI: resolve(), gitUserLocalSource: resolve()) }
        register(GitUserDetailRepository.self) {
            GitUserDetailRepositoryImpl(
                networkAPI: resolve(),
                gitUserDetailLocalSource: resolve()
            )
        }
    }

    private static func registerUseCases() {
        register(GetGitUserUseCase.self) { GetGitUserUseCase(repository: resolve()) }
        register(GetGitUserDetailRemoteUseCase.self) { GetGitUserDetailRemoteUseCase(repository: resolve()) }
        register(GetGitUserDetailLocalUseCase.self) { GetGitUserDetailLocalUseCase(repository: resolve()) }
    }

    private static func registerViewModel() {
        register(GitUserListViewModel.self) {
            GitUserListViewModel(useCase: resolve(), dispatchQueueProvider: resolve())
        }
        register(GitUserDetailViewModel.self) {
            GitUserDetailViewModel(
                dispatchQueueProvider: resolve(),
                getRemoteUseCase: resolve(),
                getLocalUseCase: resolve(),
                gitUserDetailUiMapper: resolve()
            )
        }
    }

    private static func registerMappers() {
        register(GitUserDetailUiMapper.self) { GitUserDetailUiMapperImpl() }
    }
}
