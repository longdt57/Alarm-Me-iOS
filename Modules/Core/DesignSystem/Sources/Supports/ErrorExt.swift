//
//  ErrorExt.swift
//  iOSApp
//
//  Created by long.do@compass.com on 30/3/25.
//

import Alamofire

extension Error {
    func mapToErrorState() -> ErrorState {
        if let afError = self as? AFError {
            // Handle Alamofire-specific errors
            switch afError {
            case let .sessionTaskFailed(error: underlyingError):
                if let urlError = underlyingError as? URLError,
                   urlError.code == .notConnectedToInternet {
                    return .messageError(ErrorState.MessageError.network())
                }
            case .responseSerializationFailed(reason: .inputDataNilOrZeroLength):
                return .messageError(ErrorState.MessageError.server())
            default:
                break
            }

            // Try to parse and map API error only if underlyingError is Data
            if let responseData = afError.underlyingError as? Data {
                let apiError = parseApiError(responseData: responseData)
                return .messageError(ErrorState.MessageError.api(messageBody: afError.errorDescription))
            } else {
                return .messageError(ErrorState.MessageError.api(messageBody: nil))
            }
        }

        // Default: Return self for unknown error types
        return .messageError(ErrorState.MessageError.common)
    }

    private func parseApiError(responseData: Data) -> ErrorResponse? {
        do {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: responseData)
            return errorResponse
        } catch {
            print("Failed to decode error response: \(error)")
            return nil
        }
    }
}

struct ErrorResponse: Codable {
    let message: String
}
