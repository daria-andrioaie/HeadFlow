//
//  AuthenticationService.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 02.03.2023.
//

import Foundation
import Alamofire

protocol AuthenticationServiceProtocol {
    func register(username: String, phoneNumber: String, onRequestCompleted: @escaping (Result<User, Errors.APIError>) -> Void) async
    func login(phoneNumber: String, onRequestCompleted: @escaping (Result<User, Errors.APIError>) -> Void) async
    func verifyOTP(_ otp: String, for phoneNumber: String, onRequestCompleted: @escaping (Result<String, Errors.APIError>) -> Void) async
    func resendOTP(for phoneNumber: String, onRequestCompleted: @escaping (Result<String, Errors.APIError>) -> Void) async
}

struct UserDTO: Decodable {
    let user: User
}

struct TokenDTO: Decodable {
    let token: String
}

struct BasicResponseDTO: Decodable {
    let success: Bool
    let message: String
}


class AuthenticationService: AuthenticationServiceProtocol {
    let localPath = "http://daria.local:3000/api/v1/"
    
    func register(username: String, phoneNumber: String, onRequestCompleted: @escaping (Result<User, Errors.APIError>) -> Void) async {
        let parameters = ["username": username, "phoneNumber": phoneNumber]
        
        AF.request(localPath + "user", method: .post, parameters: parameters, encoder: .json)
            .responseDecodable(of: UserDTO.self) { response in
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
        AF.request(localPath + "user/login", method: .post, parameters: parameters, encoder: .json)
            .responseDecodable(of: UserDTO.self) { response in
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
        AF.request(localPath + "otp/verify", method: .post, parameters: parameters, encoder: .json)
            .responseDecodable(of: TokenDTO.self) { response in
                switch response.result {
                    
                case .success(let verificationResponse):
                    onRequestCompleted(.success(verificationResponse.token))
                    
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
        AF.request(localPath + "otp/resend", method: .post, parameters: parameters, encoder: .json)
            .responseDecodable(of: BasicResponseDTO.self) { response in
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
}

class MockAuthenticationService: AuthenticationServiceProtocol {
    func register(username: String, phoneNumber: String, onRequestCompleted: @escaping (Result<User, Errors.APIError>) -> Void) async {
        
    }
    
    func login(phoneNumber: String, onRequestCompleted: @escaping (Result<User, Errors.APIError>) -> Void) async {
        
    }
    
    func verifyOTP(_ otp: String, for phoneNumber: String, onRequestCompleted: @escaping (Result<String, Errors.APIError>) -> Void) async {
        
    }
    
    func resendOTP(for phoneNumber: String, onRequestCompleted: @escaping (Result<String, Errors.APIError>) -> Void) async {
        
    }
}
