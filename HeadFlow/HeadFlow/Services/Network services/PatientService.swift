//
//  PatientService.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 22.04.2023.
//

import Foundation
import Alamofire

protocol PatientServiceProtocol {
    func getTherapistForCurrentPatient(onRequestCompleted: @escaping (Result<Collaboration, Errors.APIError>) -> Void) async
}

class PatientService: PatientServiceProtocol {
    var path: Constants.ServerPathType = .local
    
    init(path: Constants.ServerPathType) {
        self.path = path
    }
    
    func getTherapistForCurrentPatient(onRequestCompleted: @escaping (Result<Collaboration, Errors.APIError>) -> Void) async {
        let sessionToken = Session.shared.accessToken
        if let sessionToken {

            let headers: HTTPHeaders = ["Authorization": "Bearer \(sessionToken)"]
            
            AF.request(path.rawValue + "/patient/getTherapist", method: .get, headers: headers)
                .responseDecodable(of: Collaboration.self) { response in
                    switch response.result {
                        
                    case .success(let collaboration):
                        onRequestCompleted(.success(collaboration))
                        
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


class MockPatientService: PatientServiceProtocol {
    func getTherapistForCurrentPatient(onRequestCompleted: @escaping (Result<Collaboration, Errors.APIError>) -> Void) async {
        onRequestCompleted(.success(.init(therapist: .mockTherapist1, patient: .mockPatient1, status: .active)))
    }
}
