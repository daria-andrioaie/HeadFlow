//
//  TherapistService.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 19.04.2023.
//

import Foundation
import Alamofire

protocol TherapistServiceProtocol {
    func getAllPatientsForCurrentTherapist(onRequestCompleted: @escaping (Result<[Collaboration], Errors.APIError>) -> Void) async
    func getPatientByEmailAddress(emailAddress: String, onRequestCompleted: @escaping (Result<User, Errors.APIError>) -> Void) async
}

class TherapistService: TherapistServiceProtocol {
    var path: Constants.ServerPathType = .local
    
    init(path: Constants.ServerPathType) {
        self.path = path
    }

    func getAllPatientsForCurrentTherapist(onRequestCompleted: @escaping (Result<[Collaboration], Errors.APIError>) -> Void) async {
        let sessionToken = Session.shared.accessToken
        if let sessionToken {

            let headers: HTTPHeaders = ["Authorization": "Bearer \(sessionToken)"]
            
            AF.request(path.rawValue + "/collaborations/all", method: .get, headers: headers)
                .responseDecodable(of: Array<Collaboration>.self) { response in
                    switch response.result {
                        
                    case .success(let collaborations):
                        onRequestCompleted(.success(collaborations))
                        
                    case .failure(let error):
                        if let data = response.data, let apiError = try? JSONDecoder().decode(Errors.APIError.self, from: data) {
                            onRequestCompleted(.failure(apiError))
                            print(apiError.localizedDescription)
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
    
    func getPatientByEmailAddress(emailAddress: String, onRequestCompleted: @escaping (Result<User, Errors.APIError>) -> Void) async {
        let sessionToken = Session.shared.accessToken
        if let sessionToken {

            let headers: HTTPHeaders = ["Authorization": "Bearer \(sessionToken)"]
            let parameters = ["emailAddress": emailAddress]
            
            AF.request(path.rawValue + "/patient/search", method: .post, parameters: parameters, encoder: .json, headers: headers)
                .responseDecodable(of: User.self) { response in
                    switch response.result {
                        
                    case .success(let patient):
                        onRequestCompleted(.success(patient))
                        
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


class MockTherapistService: TherapistServiceProtocol {
    func getAllPatientsForCurrentTherapist(onRequestCompleted: @escaping (Result<[Collaboration], Errors.APIError>) -> Void) async {
        onRequestCompleted(.success([]))
    }
    
    func getPatientByEmailAddress(emailAddress: String, onRequestCompleted: @escaping (Result<User, Errors.APIError>) -> Void) async {
        onRequestCompleted(.success(.mockPatient1))
//        onRequestCompleted(.failure(.init(message: "No patient found", code: 200)))
    }
}
