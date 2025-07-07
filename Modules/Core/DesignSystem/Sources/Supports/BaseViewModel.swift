//
//  BaseViewModel.swift
//  app
//
//  Created by Long Do.
//

import Combine
import Foundation

open class BaseViewModel: ObservableObject {

    public init(dispatchQueueProvider: DispatchQueueProvider) {
        self.dispatchQueueProvider = dispatchQueueProvider
    }

    @Published public var loading: LoadingState = .none
    @Published public var error: ErrorState = .none

    public let dispatchQueueProvider: DispatchQueueProvider
    public var cancellables = Set<AnyCancellable>()

    open func showLoading() {
        dispatchQueueProvider.mainQueue.async {
            self.loading = .loading()
        }
    }

    open func isLoading() -> Bool {
        if case .loading = loading {
            return true
        }
        return false
    }

    open func hideLoading() {
        dispatchQueueProvider.mainQueue.async {
            self.loading = .none
        }
    }

    open func handleError(error: Error) {
        dispatchQueueProvider.mainQueue.async {
            self.error = error.mapToErrorState()
        }
    }

    open func hideError() {
        dispatchQueueProvider.mainQueue.async {
            self.error = .none
        }
    }

    open func injectLoading<T: Publisher>(
        publisher: T
    ) -> Publishers.HandleEvents<T> {
        return publisher.handleEvents(
            receiveSubscription: { _ in
                self.showLoading()
            },
            receiveCompletion: { _ in
                self.hideLoading()
            }
        )
    }

    open func onErrorPrimaryAction(errorState: ErrorState) {
        hideError()
    }

    open func onErrorSecondaryAction(errorState: ErrorState) {
        hideError()
    }

    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
}
