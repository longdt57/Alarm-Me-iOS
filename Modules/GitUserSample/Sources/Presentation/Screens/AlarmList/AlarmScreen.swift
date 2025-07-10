//
//  AlarmScreen.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Resolver
import SwiftUI

public struct AlarmScreen: View {
    
    public init() {}
    
    @State private var showingAlarmSetup = false
    
    @StateObject var viewModel: AlarmViewModel = Resolver.resolve()
    
    public var body: some View {
        NavigationView {
            VStack {
                if viewModel.uiState.alarms.isEmpty.not() {
                    alarmListView()
                } else if viewModel.isLoading().not() {
                    AlarmEmptyView()
                }
            }
            .showLoading(loadingState: $viewModel.loading)
            .showError(
                error: $viewModel.error,
                primaryAction: { errorState in
                    viewModel.onErrorPrimaryAction(errorState: errorState)
                }, secondaryAction: { errorState in
                    viewModel.onErrorSecondaryAction(errorState: errorState)
                }
            )
            .onAppear {
            }
            .navigationTitle(R.string.localizable.alarm())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Navigate or present AlarmSetupScreen
//                        viewModel.navigateToAlarmSetupScreen()
                        showingAlarmSetup = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAlarmSetup) {
                AlarmSetupScreen()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func alarmListView() -> some View {
        AlarmListView(
            alarms: viewModel.uiState.alarms,
            onDelete: { viewModel.deleteAlarm(alarm: $0) },
            onCheckedChange: { viewModel.toggleAlarm(alarm: $0)},
            onClick: {_ in }
            
        )
    }
}

#Preview {
    AlarmScreen()
}
