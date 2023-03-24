//
//  AuthenticationService.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 02.03.2023.
//

import Foundation
import Alamofire
import RealmSwift

protocol AuthenticationServiceProtocol {
    var notificationsService: NotificationsServiceProtocol { get }
    
    func register(username: String, phoneNumber: String, onRequestCompleted: @escaping (Result<User, Errors.APIError>) -> Void) async
    func login(phoneNumber: String, onRequestCompleted: @escaping (Result<User, Errors.APIError>) -> Void) async
    func logout(onRequestCompleted: @escaping (Result<String, Errors.APIError>) -> Void) async

    func verifyOTP(_ otp: String, for phoneNumber: String, onRequestCompleted: @escaping (Result<String, Errors.APIError>) -> Void) async
    func resendOTP(for phoneNumber: String, onRequestCompleted: @escaping (Result<String, Errors.APIError>) -> Void) async
    
    func socialSignIn(socialToken: String, onRequestCompleted: @escaping (Result<String, Errors.APIError>) -> Void) async
}

class AuthenticationService: AuthenticationServiceProtocol {
    
    var path: Constants.ServerPathType = .local
    
    var notificationsService: NotificationsServiceProtocol
    
    init(path: Constants.ServerPathType, notificationsService: NotificationsServiceProtocol) {
        self.path = path
        self.notificationsService = notificationsService
    }
    
    func register(username: String, phoneNumber: String, onRequestCompleted: @escaping (Result<User, Errors.APIError>) -> Void) async {
        let parameters = ["username": username, "phoneNumber": phoneNumber]
        
        AF.request(path.rawValue + "/user/signup", method: .post, parameters: parameters, encoder: .json)
            .responseDecodable(of: AuthenticationResponse.self) { response in
                switch response.result {
                    
                case .success(let authenticationResponse):
                    onRequestCompleted(.success(authenticationResponse.user))
                    
                case .failure(let error):
                    if let data = response.data, let apiError = try? JSONDecoder().decode(Errors.APIError.self, from: data) {
                        onRequestCompleted(.failure(apiError))
                    }
                    else {
                        onRequestCompleted(.failure(Errors.APIError(message: "Unexpected error: " + error.localizedDescription)))
                    }
                }
            }
    }
    
    func login(phoneNumber: String, onRequestCompleted: @escaping (Result<User, Errors.APIError>) -> Void) async {
        let parameters = ["phoneNumber": phoneNumber]
        AF.request(path.rawValue + "/user/login", method: .post, parameters: parameters, encoder: .json)
            .responseDecodable(of: AuthenticationResponse.self) { response in
                switch response.result {
                    
                case .success(let authenticationResponse):
                    onRequestCompleted(.success(authenticationResponse.user))

                case .failure(let error):
                    if let data = response.data, let apiError = try? JSONDecoder().decode(Errors.APIError.self, from: data) {
                        onRequestCompleted(.failure(apiError))
                    }
                    else {
                        onRequestCompleted(.failure(Errors.APIError(message: "Unexpected error: " + error.localizedDescription)))
                    }
                }
            }
    }
    
    func verifyOTP(_ otp: String, for phoneNumber: String, onRequestCompleted: @escaping (Result<String, Errors.APIError>) -> Void) async {
        let parameters = ["otp": otp, "phoneNumber": phoneNumber]
        AF.request(path.rawValue + "/otp/verify", method: .post, parameters: parameters, encoder: .json)
            .responseDecodable(of: AuthenticationResponse.self) { response in
                switch response.result {
                    
                case .success(let verificationResponse):
                    if let token = verificationResponse.token {
                        let user = verificationResponse.user
                        Session.shared.saveCurrentUser(userId: user.id, token: token)
                        
                        self.notificationsService.saveNotificationsStatusOfUser(userId: user.id, notificationsStatusPresented: false)
                        
                        onRequestCompleted(.success(token))

                    } else {
                        onRequestCompleted(.failure(Errors.APIError(message: "Unexpected error while decoding user and token.")))
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
    }
    
    func resendOTP(for phoneNumber: String, onRequestCompleted: @escaping (Result<String, Errors.APIError>) -> Void) async {
        let parameters = ["phoneNumber": phoneNumber]
        AF.request(path.rawValue + "/otp/resend", method: .post, parameters: parameters, encoder: .json)
            .responseDecodable(of: BasicResponse.self) { response in
                switch response.result {
                    
                case .success(let basicResponse):
                    if basicResponse.success {
                        onRequestCompleted(.success("Code was resent!"))
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
    }
    
    func logout(onRequestCompleted: @escaping (Result<String, Errors.APIError>) -> Void) async {
        let sessionToken = Session.shared.accessToken
        if let sessionToken {
            let headers: HTTPHeaders = ["Authorization": "Bearer \(sessionToken)"]
            
            AF.request(path.rawValue + "/user/logout", method: .post, headers: headers)
                .responseDecodable(of: BasicResponse.self) { response in
                    switch response.result {
                        
                    case .success(let logoutResponse):
                        if logoutResponse.success {
                            onRequestCompleted(.success(logoutResponse.message))
                        } else {
                            onRequestCompleted(.failure(Errors.APIError(message: logoutResponse.message)))
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
    
    func socialSignIn(socialToken: String, onRequestCompleted: @escaping (Result<String, Errors.APIError>) -> Void) async {
        let parameters = ["socialToken": socialToken]
        
        AF.request(path.rawValue + "/user/social-sign-in", method: .post, parameters: parameters, encoder: .json)
            .responseDecodable(of: AuthenticationResponse.self) { response in
                switch response.result {
                    
                case .success(let authenticationResponse):
                    if let token = authenticationResponse.token {
                        let user = authenticationResponse.user
                        Session.shared.saveCurrentUser(userId: user.id, token: token)
                        
                        self.notificationsService.saveNotificationsStatusOfUser(userId: user.id, notificationsStatusPresented: false)
                        
                        onRequestCompleted(.success(token))
                    } else {
                        onRequestCompleted(.failure(Errors.APIError(message: "Unexpected error while decoding user and token.")))
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
    }
}

class MockAuthenticationService: AuthenticationServiceProtocol {
    var notificationsService: NotificationsServiceProtocol = MockNotificationsService()
    
    func register(username: String, phoneNumber: String, onRequestCompleted: @escaping (Result<User, Errors.APIError>) -> Void) async {
        
    }
    
    func login(phoneNumber: String, onRequestCompleted: @escaping (Result<User, Errors.APIError>) -> Void) async {
        
    }
    
    func verifyOTP(_ otp: String, for phoneNumber: String, onRequestCompleted: @escaping (Result<String, Errors.APIError>) -> Void) async {
        
    }
    
    func resendOTP(for phoneNumber: String, onRequestCompleted: @escaping (Result<String, Errors.APIError>) -> Void) async {
        
    }
    
    func logout(onRequestCompleted: @escaping (Result<String, Errors.APIError>) -> Void) async {
        
    }
    
    func socialSignIn(socialToken: String, onRequestCompleted: @escaping (Result<String, Errors.APIError>) -> Void) async {
        
    }
}
