//
//  BaseViewModelTests.swift
//  iOSAppTests
//
//  Created by Long Do on 01/01/2025.
//

import Alamofire
import Combine
@testable import DesignSystem
import XCTest

class BaseViewModelTests: XCTestCase {

    // Test instance
    private var viewModel: BaseViewModel!
    private var mockDispatchQueueProvider: MockDispatchQueueProvider!

    private let error = NSError(domain: "SomeError", code: 1, userInfo: nil)
    private let networkError = AFError.sessionTaskFailed(error: MockError.testError)
    private let serverError = AFError
        .responseSerializationFailed(reason: AFError.ResponseSerializationFailureReason.inputDataNilOrZeroLength)

    override func setUp() {
        super.setUp()
        mockDispatchQueueProvider = MockDispatchQueueProvider()
        viewModel = BaseViewModel(dispatchQueueProvider: mockDispatchQueueProvider)
    }

    override func tearDown() {
        viewModel = nil
        mockDispatchQueueProvider = nil
        super.tearDown()
    }

    func testShowLoading() {
        // Arrange
        // The view model starts with .none, we will call showLoading

        // Act
        viewModel.showLoading()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert
            XCTAssertEqual(self.viewModel.loading, .loading())
        }
    }

    func testIsLoading() {
        // Arrange
        // Initially, loading should be .none

        // Act
        let isLoadingInitially = viewModel.isLoading()
        viewModel.showLoading()
        let isLoadingAfterShow = viewModel.isLoading()
        viewModel.hideLoading()
        let isLoadingAfterHide = viewModel.isLoading()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert
            XCTAssertFalse(isLoadingInitially) // .none
            XCTAssertTrue(isLoadingAfterShow) // .loading
            XCTAssertFalse(isLoadingAfterHide) // .none
        }
    }

    func testHideLoading() {
        // Arrange
        viewModel.showLoading() // Set to loading first

        // Act
        viewModel.hideLoading()

        // Assert
        XCTAssertEqual(viewModel.loading, .none)
    }

    func testHandleError_genericError() {
        // Arrange
        let error = MockError.testError

        // Act
        viewModel.handleError(error: error)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert
            XCTAssertEqual(self.viewModel.error, .messageError(ErrorState.MessageError.common))
        }
    }

    func testHandleError_dataNotFoundError() {
        // Act
        viewModel.handleError(error: networkError)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert
            XCTAssertEqual(self.viewModel.error, .messageError(ErrorState.MessageError.network()))
        }
    }

    func testHandleError_otherError() {
        // Act
        viewModel.handleError(error: error)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert
            XCTAssertEqual(self.viewModel.error, .messageError(ErrorState.MessageError.common))
        }
    }

    func testHideError() {
        // Arrange
        viewModel.handleError(error: MockError.testError) // Set error state

        // Act
        viewModel.hideError()

        // Assert
        XCTAssertEqual(viewModel.error, .none)
    }

    func testOnErrorPrimaryAction() {
        // Arrange
        viewModel.handleError(error: serverError) // Set error state

        // Act
        viewModel.onErrorPrimaryAction(errorState: ErrorState.messageError(.server()))

        // Assert
        XCTAssertEqual(viewModel.error, .none)
    }

    func testOnErrorSecondaryAction() {
        // Arrange
        viewModel.handleError(error: networkError) // Set error state

        // Act
        viewModel.onErrorSecondaryAction(errorState: ErrorState.messageError(.network()))

        // Assert
        XCTAssertEqual(viewModel.error, .none)
    }

    func testDeinit_cancelsCancellables() {
        // Arrange
        var viewModel: BaseViewModel? = BaseViewModel(dispatchQueueProvider: mockDispatchQueueProvider)

        // Act
        let cancellables = viewModel?.cancellables
        viewModel = nil

        // Assert
        XCTAssertEqual(cancellables?.isEmpty, true)
    }
}

class MockDispatchQueueProvider: DispatchQueueProvider {
    var backgroundQueue: DispatchQueue = .main
    var mainQueue: DispatchQueue = .main
}

enum MockError: Error {
    case testError
}
