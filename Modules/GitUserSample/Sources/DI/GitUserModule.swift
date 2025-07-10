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

        registerHelpers()
        registerLocalSource()
        registerRepositories()
        registerUseCases()
        registerMappers()
        registerViewModel()
    }
    
    private static func registerHelpers() {
        register(AlarmClockHelper.self) { AlarmClockHelperImpl() }
    }

    private static func registerLocalSource() {
        register(GitUserLocalSource.self) { GitUserLocalSourceImpl() }
        register(GitUserDetailLocalSource.self) { GitUserDetailLocalSourceImpl() }
        register(AlarmLocalSource.self) { AlarmLocalSourceImpl() }
        register(AlarmAudioLocalSource.self) { AlarmAudioLocalSourceImpl() }
    }

    private static func registerRepositories() {
        register(GitUserRepository.self) { GitUserRepositoryImpl(networkAPI: resolve(), gitUserLocalSource: resolve()) }
        register(GitUserDetailRepository.self) {
            GitUserDetailRepositoryImpl(
                networkAPI: resolve(),
                gitUserDetailLocalSource: resolve()
            )
        }
        register(AlarmRepository.self) { AlarmRepositoryImpl(alarmLocalSource: resolve(), alarmAudioLocalSource: resolve()) }
    }

    private static func registerUseCases() {
        register(GetGitUserUseCase.self) { GetGitUserUseCase(repository: resolve()) }
        register(GetGitUserDetailRemoteUseCase.self) { GetGitUserDetailRemoteUseCase(repository: resolve()) }
        register(GetGitUserDetailLocalUseCase.self) { GetGitUserDetailLocalUseCase(repository: resolve()) }
        
        register(CreateAlarmUseCase.self) { CreateAlarmUseCase(alarmRepository: resolve(), alarmClockHelper: resolve()) }
        register(DeleteAlarmUseCase.self) { DeleteAlarmUseCase(alarmRepository: resolve(), alarmClockHelper: resolve()) }
        register(UpdateAlarmUseCase.self) { UpdateAlarmUseCase(alarmRepository: resolve(), alarmClockHelper: resolve()) }
        register(ObserveAlarmsUseCase.self) { ObserveAlarmsUseCase(alarmRepository: resolve()) }
        register(GetAlarmByIdUseCase.self) { GetAlarmByIdUseCase(alarmRepository: resolve()) }
        
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
        
        register(AlarmViewModel.self) {
            AlarmViewModel(dispatchQueueProvider: resolve(), observeAlarmsUseCase: resolve(), deleteAlarmUseCase: resolve(), toggleAlarmUseCase: resolve())
        }
        register(AlarmSetupViewModel.self) {
            AlarmSetupViewModel(dispatchQueueProvider: resolve(), getAlarmByIdUseCase: resolve(), createAlarmUseCase: resolve(), updateAlarmUseCase: resolve(), deleteAlarmUseCase: resolve())
        }
    }

    private static func registerMappers() {
        register(GitUserDetailUiMapper.self) { GitUserDetailUiMapperImpl() }
    }
}
