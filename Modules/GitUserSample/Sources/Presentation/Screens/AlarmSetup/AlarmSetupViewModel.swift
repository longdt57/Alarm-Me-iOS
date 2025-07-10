//
//  AlarmSetupViewModel.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Foundation
import Combine
import DesignSystem

class AlarmSetupViewModel: BaseViewModel {
    
    @Published var uiState = AlarmSetupUiState()
    let dismissPublisher = PassthroughSubject<Void, Never>()
    
    private var initialAlarm: AlarmModel? = nil
    
    private let getAlarmByIdUseCase: GetAlarmByIdUseCase
    private let createAlarmUseCase: CreateAlarmUseCase
    private let updateAlarmUseCase: UpdateAlarmUseCase
    private let deleteAlarmUseCase: DeleteAlarmUseCase
    //    private let fetchAlarmAudioUseCase: FetchAlarmAudioUseCase
    //    private let observeAlarmAudioUseCase: ObserveAlarmAudioUseCase
    
    init(
        dispatchQueueProvider: DispatchQueueProvider,
        getAlarmByIdUseCase: GetAlarmByIdUseCase,
        createAlarmUseCase: CreateAlarmUseCase,
        updateAlarmUseCase: UpdateAlarmUseCase,
        deleteAlarmUseCase: DeleteAlarmUseCase,
        //        fetchAlarmAudioUseCase: FetchAlarmAudioUseCase,
        //        observeAlarmAudioUseCase: ObserveAlarmAudioUseCase
    ) {
        self.getAlarmByIdUseCase = getAlarmByIdUseCase
        self.createAlarmUseCase = createAlarmUseCase
        self.updateAlarmUseCase = updateAlarmUseCase
        self.deleteAlarmUseCase = deleteAlarmUseCase
        //        self.fetchAlarmAudioUseCase = fetchAlarmAudioUseCase
        //        self.observeAlarmAudioUseCase = observeAlarmAudioUseCase
        super.init(dispatchQueueProvider: dispatchQueueProvider)
        
        //        fetchAudio()
        //        observeAudio()
    }
    
    func loadAlarmData(alarm: AlarmModel? = nil) {
        initialAlarm = alarm
        if let alarm = alarm {
            var newUiState = self.uiState
            newUiState.id = alarm.id
            newUiState.label = alarm.label ?? ""
            newUiState.timeOfDay = alarm.timeOfDay ?? ""
            newUiState.isEnabled = alarm.isEnabled
            newUiState.audio = alarm.audio
            newUiState.snoozeEnabled = alarm.snoozeEnabled ?? false
            newUiState.repeatDays = fromRepeatDayString(alarm.repeatDays.orEmpty())
            newUiState.initialTimePickerState = TimePickerState.parseTimeToPickerState(alarm.timeOfDay ?? "")
            
            self.uiState = newUiState
        }
    }
    
    private func createAlarmRequest() -> AlarmModel {
        AlarmModel(
            id: uiState.id,
            audio: uiState.audio,
            createdAt: Date().formatted(),
            isEnabled: uiState.isEnabled,
            label: uiState.label,
            repeatDays: toRepeatDayString(uiState.repeatDays),
            snoozeEnabled: uiState.snoozeEnabled,
            timeOfDay: uiState.timeOfDay,
            updatedAt: nil,
            vibrate: true
        )
    }
    
    func save() {
        guard !isLoading() else { return }
        uiState.isEnabled = true
        if uiState.isNewAlarm {
            createAlarm()
        } else {
            updateAlarm()
        }
    }
    
    private func createAlarm() {
        let publisher = createAlarmUseCase.invoke(alarm: createAlarmRequest())
            .receive(on: dispatchQueueProvider.mainQueue)
        
        injectLoading(publisher: publisher)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.handleError(error: error)
                }
            }, receiveValue: { _ in
                self.navigateUp()
            })
            .store(in: &cancellables)
    }
    
    private func updateAlarm() {
        let publisher = updateAlarmUseCase.invoke(createAlarmRequest())
            .receive(on: dispatchQueueProvider.mainQueue)
        
        injectLoading(publisher: publisher)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.handleError(error: error)
                }
            }, receiveValue: { _ in
                self.navigateUp()
            })
            .store(in: &cancellables)
    }
    
    func deleteAlarm() {
        if let alarm = initialAlarm {
            let publisher = deleteAlarmUseCase.invoke(alarm: alarm)
                .receive(on: dispatchQueueProvider.mainQueue)
            
            injectLoading(publisher: publisher)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        self.handleError(error: error)
                    }
                }, receiveValue: { _ in
                    self.navigateUp()
                })
                .store(in: &cancellables)
        }
    }
    
    func onTextChange(_ value: String) {
        uiState.label = value
    }
    
    func onSnoozeChange() {
        uiState.snoozeEnabled.toggle()
    }
    
    func onTimeChange(_ time: TimePickerState) {
        let value = DateTimeUtil.convertToAlarmSaveTime(hour: time.hour, minute: time.minute, period: time.period)
        uiState.timeOfDay = value
    }
    
    func onAudioSelected(_ audio: AlarmAudioModel) {
        uiState.audio = audio
    }
    
    func onRepeatItemClick(_ value: Int) {
        if uiState.repeatDays.contains(value) {
            uiState.repeatDays.removeAll { $0 == value }
        } else {
            uiState.repeatDays.append(value)
        }
    }
    
    //    private func fetchAudio() {
    //        fetchAlarmAudioUseCase()
    //            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    //            .store(in: &cancellables)
    //    }
    
    //    private func observeAudio() {
    //        observeAlarmAudioUseCase()
    //            .receive(on: dispatchQueueProvider.mainQueue)
    //            .sink(receiveValue: { audioList in
    //                if self.uiState.audio == nil {
    //                    self.uiState.audio = audioList.first
    //                }
    //                self.uiState.audioList = audioList
    //            })
    //            .store(in: &cancellables)
    //    }
    
    private func navigateUp() {
        dismissPublisher.send()
    }
}
