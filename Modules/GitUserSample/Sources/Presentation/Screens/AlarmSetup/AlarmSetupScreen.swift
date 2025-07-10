//
//  AlarmSetupScreen.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import SwiftUI
import Combine
import Resolver

struct AlarmSetupScreen: View {
    
    @StateObject var viewModel: AlarmSetupViewModel = Resolver.resolve()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
//    @State private var bottomSheet: AlarmSetupBottomSheet?
    @State private var checkNotificationPermissionAndSave = false
    
    init (alarmModel: AlarmModel? = nil) {
        viewModel.loadAlarmData(alarm: alarmModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                Spacer()
                Text(R.string.localizable.setup_alarm())
                    .font(.headline)
                Spacer()
//                Spacer()
//                    .frame(width: 12)
            }
            .padding()
            
            // Main Content
            AlarmSetupScreenContent(
                uiState: viewModel.uiState,
                onSnoozeChange: {_ in 
                    viewModel.onSnoozeChange()
                },
                onRepeatClick: { 
                    
                },
                onAudioClick: {
                },
                onLabelChange: {
                    viewModel.onTextChange($0)
                },
                onTimeChange: {
                    viewModel.onTimeChange($0)
                },
                onDeleteClick: {
                    viewModel.deleteAlarm()
                }
            )
            .frame(maxWidth: .infinity)
//            .frame(maxHeight: .infinity)
            // Save Button
            Button(action: {
//                checkNotificationPermissionAndSave = true
                viewModel.save()
            }) {
                Text(R.string.localizable.save())
                    .font(.body)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .padding(.horizontal, 20)
            Spacer()
        }
        .showLoading(loadingState: $viewModel.loading)
        .showError(
            error: $viewModel.error,
            primaryAction: { viewModel.onErrorPrimaryAction(errorState: $0) },
            secondaryAction: { viewModel.onErrorSecondaryAction(errorState: $0) }
        )
        .onReceive(viewModel.dismissPublisher) { _ in
            presentationMode.wrappedValue.dismiss()
        }
        .onAppear {
            // any init code here
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(R.string.localizable.setup_alarm())
        .navigationBarTitleDisplayMode(.inline)
    }
}
