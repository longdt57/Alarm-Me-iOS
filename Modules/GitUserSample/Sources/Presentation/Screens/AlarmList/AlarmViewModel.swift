//
//  AlarmViewModel.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Foundation
import Combine
import DesignSystem

final class AlarmViewModel: BaseViewModel {
    
    @Published private(set) var uiState = AlarmUiState()
    
    private let observeAlarmsUseCase: ObserveAlarmsUseCase
    private let deleteAlarmUseCase: DeleteAlarmUseCase
    private let toggleAlarmUseCase: UpdateAlarmUseCase
    
    init(
        dispatchQueueProvider: DispatchQueueProvider,
        observeAlarmsUseCase: ObserveAlarmsUseCase,
        deleteAlarmUseCase: DeleteAlarmUseCase,
        toggleAlarmUseCase: UpdateAlarmUseCase
    ) {
        self.observeAlarmsUseCase = observeAlarmsUseCase
        self.deleteAlarmUseCase = deleteAlarmUseCase
        self.toggleAlarmUseCase = toggleAlarmUseCase
        super.init(dispatchQueueProvider: dispatchQueueProvider)
        observeAlarms()
    }
    
    func deleteAlarm(alarm: AlarmModel) {
        injectLoading(publisher: deleteAlarmUseCase.invoke(alarm: alarm))
            .subscribe(on: dispatchQueueProvider.backgroundQueue)
            .receive(on: dispatchQueueProvider.mainQueue)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.handleError(error: error)
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
    }
    
    func toggleAlarm(alarm: AlarmModel) {
        var updatedAlarm = alarm
        updatedAlarm.isEnabled = alarm.isEnabled.not()
        injectLoading(publisher: toggleAlarmUseCase.invoke(updatedAlarm))
            .subscribe(on: dispatchQueueProvider.backgroundQueue)
            .receive(on: dispatchQueueProvider.mainQueue)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.handleError(error: error)
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
    }
    
    private func observeAlarms() {
        observeAlarmsUseCase.invoke()
            .receive(on: dispatchQueueProvider.mainQueue)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.handleError(error: error)
                    }
                },
                receiveValue: { [weak self] alarms in
                    self?.uiState.alarms = alarms
                }
            )
                .store(in: &cancellables)
    }
}
