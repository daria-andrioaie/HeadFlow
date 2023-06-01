//
//  FeedbackService.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 01.06.2023.
//

import Foundation
import Alamofire

protocol FeedbackServiceProtocol {
    func sendFeedbackForSession(with sessionId: String, message: String, onRequestCompleted: @escaping (Result<Feedback.Model, Errors.APIError>) -> Void) async
    func getFeedbackForSession(with sessionId: String, onRequestCompleted: @escaping (Result<Feedback.Model, Errors.APIError>) -> Void) async
}

class FeedbackService: FeedbackServiceProtocol {
    var path: Constants.ServerPathType = .local
    
    init(path: Constants.ServerPathType) {
        self.path = path
    }
    
    func sendFeedbackForSession(with sessionId: String, message: String, onRequestCompleted: @escaping (Result<Feedback.Model, Errors.APIError>) -> Void) async {
        let sessionToken = Session.shared.accessToken
        if let sessionToken {

            let headers: HTTPHeaders = ["Authorization": "Bearer \(sessionToken)"]
            let params: [String: String] = ["sessionId": sessionId,
                                            "message": message]
            
            AF.request(path.rawValue + "/feedback/", method: .post, parameters: params, encoder: .json, headers: headers)
                .responseDecodable(of: FeedbackResponse.self) { response in
                    switch response.result {
                        
                    case .success(let feedbackResponse):
                        onRequestCompleted(.success(feedbackResponse.feedback))
                        
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
    
    func getFeedbackForSession(with sessionId: String, onRequestCompleted: @escaping (Result<Feedback.Model, Errors.APIError>) -> Void) async {
        let sessionToken = Session.shared.accessToken
        if let sessionToken {

            let headers: HTTPHeaders = ["Authorization": "Bearer \(sessionToken)"]
            let params: [String: String] = ["sessionId": sessionId]
            
            AF.request(path.rawValue + "/feedback/getFeedback", method: .post, parameters: params, encoder: .json, headers: headers)
                .responseDecodable(of: FeedbackResponse.self) { response in
                    switch response.result {
                        
                    case .success(let feedbackResponse):
                        onRequestCompleted(.success(feedbackResponse.feedback))
                        
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

class MockFeedbackService: FeedbackServiceProtocol {
    func sendFeedbackForSession(with sessionId: String, message: String, onRequestCompleted: @escaping (Result<Feedback.Model, Errors.APIError>) -> Void) async {
        onRequestCompleted(.success(.init(sessionId: sessionId, message: message, date: 1685617551953, therapist: .mockTherapist1)))
    }

    
    func getFeedbackForSession(with sessionId: String, onRequestCompleted: @escaping (Result<Feedback.Model, Errors.APIError>) -> Void) async {
//        onRequestCompleted(.success(.mock1))
        onRequestCompleted(.failure(.init(message: "No feedback")))

    }
}
