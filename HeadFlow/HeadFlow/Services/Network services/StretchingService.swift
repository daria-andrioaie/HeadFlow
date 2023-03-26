//
//  StretchingService.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 24.03.2023.
//

import Foundation
import Alamofire

protocol StretchingServiceProtocol {
    func saveStretchSummary(summary: StretchSummary.Model, onRequestCompleted: @escaping (Result<String, Errors.APIError>) -> Void) async
    func getAllStretchingSessionsForCurrentUser(onRequestCompleted: @escaping (Result<[StretchSummary.Model], Errors.APIError>) -> Void) async
    func getSessionsCountForCurrentUser(onRequestCompleted: @escaping (Result<Int, Errors.APIError>) -> Void) async
}

class StretchingService: StretchingServiceProtocol {
    var path: Constants.ServerPathType = .local
    
    init(path: Constants.ServerPathType) {
        self.path = path
    }

    func saveStretchSummary(summary: StretchSummary.Model, onRequestCompleted: @escaping (Result<String, Errors.APIError>) -> Void) async {
        let sessionToken = Session.shared.accessToken
        if let sessionToken {

            let headers: HTTPHeaders = ["Authorization": "Bearer \(sessionToken)"]
            
            AF.request(path.rawValue + "/stretching/save", method: .post, parameters: summary, encoder: .json,  headers: headers)
                .responseDecodable(of: BasicResponse.self) { response in
                    switch response.result {
                        
                    case .success(let basicResponse):
                        if basicResponse.success {
                            onRequestCompleted(.success("Saved successfully!"))
                        } else {
                            onRequestCompleted(.failure(Errors.APIError(message: basicResponse.message)))
                        }
                        
                    case .failure(let error):
                        if let data = response.data, let apiError = try? JSONDecoder().decode(Errors.APIError.self, from: data) {
                            onRequestCompleted(.failure(apiError))
                        }
                        else {
                            onRequestCompleted(.failure(Errors.APIError(message: "Unexpected error: " + error.localizedDescription)))
                        }
                    }
                }
        } else {
            onRequestCompleted(.failure(Errors.APIError(message: "No token in user defaults.")))
        }
    }
    
    func getAllStretchingSessionsForCurrentUser(onRequestCompleted: @escaping (Result<[StretchSummary.Model], Errors.APIError>) -> Void) async {
        let sessionToken = Session.shared.accessToken
        if let sessionToken {

            let headers: HTTPHeaders = ["Authorization": "Bearer \(sessionToken)"]
            
            AF.request(path.rawValue + "/stretching/allSessions", method: .get, headers: headers)
                .responseDecodable(of: StretchesResponse.self) { response in
                    switch response.result {
                        
                    case .success(let stretchesResponse):
                        onRequestCompleted(.success(stretchesResponse.stretches))
                        
                    case .failure(let error):
                        if let data = response.data, let apiError = try? JSONDecoder().decode(Errors.APIError.self, from: data) {
                            onRequestCompleted(.failure(apiError))
                        }
                        else {
                            onRequestCompleted(.failure(Errors.APIError(message: "Unexpected error: " + error.localizedDescription)))
                        }
                    }
                }
        } else {
            onRequestCompleted(.failure(Errors.APIError(message: "No token in user defaults.")))
        }
    }
    
    func getSessionsCountForCurrentUser(onRequestCompleted: @escaping (Result<Int, Errors.APIError>) -> Void) async {
        let sessionToken = Session.shared.accessToken
        if let sessionToken {

            let headers: HTTPHeaders = ["Authorization": "Bearer \(sessionToken)"]
            
            AF.request(path.rawValue + "/stretching/sessionsCount", method: .get, headers: headers)
                .responseDecodable(of: StretchingSessionsCountResponse.self) { response in
                    switch response.result {
                        
                    case .success(let stretchesResponse):
                        onRequestCompleted(.success(stretchesResponse.count))
                        
                    case .failure(let error):
                        if let data = response.data, let apiError = try? JSONDecoder().decode(Errors.APIError.self, from: data) {
                            onRequestCompleted(.failure(apiError))
                        }
                        else {
                            onRequestCompleted(.failure(Errors.APIError(message: "Unexpected error: " + error.localizedDescription)))
                        }
                    }
                }
        } else {
            onRequestCompleted(.failure(Errors.APIError(message: "No token in user defaults.")))
        }
    }
}


class MockStretchingService: StretchingServiceProtocol {
    func saveStretchSummary(summary: StretchSummary.Model, onRequestCompleted: @escaping (Result<String, Errors.APIError>) -> Void) async {
        
    }
    
    func getAllStretchingSessionsForCurrentUser(onRequestCompleted: @escaping (Result<[StretchSummary.Model], Errors.APIError>) -> Void) async {
        DispatchQueue.main.asyncAfter(seconds: 1) {
            onRequestCompleted(.success(StretchSummary.Model.mockedSet))
        }
    }
    
    func getSessionsCountForCurrentUser(onRequestCompleted: @escaping (Result<Int, Errors.APIError>) -> Void) async {
        
    }
}
