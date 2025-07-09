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
    
    @StateObject var viewModel: AlarmViewModel = Resolver.resolve()
    
    public var body: some View {
        NavigationView {
            VStack {
                if viewModel.uiState.alarms.isEmpty.not() {
                    userListView()
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
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func userListView() -> some View {
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
