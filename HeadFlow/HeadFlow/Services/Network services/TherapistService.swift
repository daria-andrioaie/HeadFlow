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
    func sendInvitation(patientId: String, onRequestCompleted: @escaping (Result<Collaboration, Errors.APIError>) -> Void) async
    func getAllStretchingSessionsForPatient(patientId: String, onRequestCompleted: @escaping (Result<[StretchSummary.Model], Errors.APIError>) -> Void) async
    func getPlannedStretchingSessionForPatient(patientId: String, onRequestCompleted: @escaping (Result<[StretchingExercise], Errors.APIError>) -> Void) async
    func savePlanForPatient(patientId: String, exerciseData: [StretchingExercise], onRequestCompleted: @escaping (Result<[StretchingExercise], Errors.APIError>) -> Void) async
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
            
            AF.request(path.rawValue + "/therapist/allCollaborations", method: .get, headers: headers)
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
            
            AF.request(path.rawValue + "/therapist/searchPatient", method: .post, parameters: parameters, encoder: .json, headers: headers)
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
    
    func sendInvitation(patientId: String, onRequestCompleted: @escaping (Result<Collaboration, Errors.APIError>) -> Void) async {
        let sessionToken = Session.shared.accessToken
        if let sessionToken {

            let headers: HTTPHeaders = ["Authorization": "Bearer \(sessionToken)"]
            let parameters = ["patientId": patientId]
            
            AF.request(path.rawValue + "/therapist/sendInvitation", method: .post, parameters: parameters, encoder: .json, headers: headers)
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
    
    func getAllStretchingSessionsForPatient(patientId: String, onRequestCompleted: @escaping (Result<[StretchSummary.Model], Errors.APIError>) -> Void) async {
        let sessionToken = Session.shared.accessToken
        if let sessionToken {

            let headers: HTTPHeaders = ["Authorization": "Bearer \(sessionToken)"]
            let parameters = ["patientId": patientId]
            
            AF.request(path.rawValue + "/therapist/allSessions", method: .post, parameters: parameters, encoder: .json, headers: headers)
                .responseDecodable(of: StretchingHistoryResponse.self) { response in
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
    
    func getPlannedStretchingSessionForPatient(patientId: String, onRequestCompleted: @escaping (Result<[StretchingExercise], Errors.APIError>) -> Void) async {
        let sessionToken = Session.shared.accessToken
        if let sessionToken {

            let headers: HTTPHeaders = ["Authorization": "Bearer \(sessionToken)"]
            let parameters = ["patientId": patientId]
            
            AF.request(path.rawValue + "/therapist/plannedSession", method: .post, parameters: parameters, encoder: .json, headers: headers)
                .responseDecodable(of: PlannedStretchingSessionResponse.self) { response in
                    switch response.result {
                        
                    case .success(let stretchesResponse):
                        onRequestCompleted(.success(stretchesResponse.plannedSession))
                        
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
    
    func savePlanForPatient(patientId: String, exerciseData: [StretchingExercise], onRequestCompleted: @escaping (Result<[StretchingExercise], Errors.APIError>) -> Void) async {
        let sessionToken = Session.shared.accessToken
        if let sessionToken {

            let headers: HTTPHeaders = ["Authorization": "Bearer \(sessionToken)"]
            let plannedSession = PlannedSession(patientId: patientId, exerciseData: exerciseData)
            
            AF.request(path.rawValue + "/therapist/saveSession", method: .post, parameters: plannedSession, encoder: .json, headers: headers)
                .responseDecodable(of: PlannedStretchingSessionResponse.self) { response in
                    switch response.result {
                        
                    case .success(let stretchesResponse):
                        onRequestCompleted(.success(stretchesResponse.plannedSession))
                        
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
    
    func sendInvitation(patientId: String, onRequestCompleted: @escaping (Result<Collaboration, Errors.APIError>) -> Void) async {
        onRequestCompleted(.success(.init(therapist: .mockPatient1, patient: .mockPatient1, status: .pending)))
    }
    
    func getAllStretchingSessionsForPatient(patientId: String, onRequestCompleted: @escaping (Result<[StretchSummary.Model], Errors.APIError>) -> Void) async {
        DispatchQueue.main.asyncAfter(seconds: 1) {
            onRequestCompleted(.success(StretchSummary.Model.mockedSet))
        }
    }
    
    func getPlannedStretchingSessionForPatient(patientId: String, onRequestCompleted: @escaping (Result<[StretchingExercise], Errors.APIError>) -> Void) async {
        DispatchQueue.main.asyncAfter(seconds: 2) {
            onRequestCompleted(.success([StretchingExercise.mock1, StretchingExercise.mock2, StretchingExercise.mock3]))
        }
    }

    func savePlanForPatient(patientId: String, exerciseData: [StretchingExercise], onRequestCompleted: @escaping (Result<[StretchingExercise], Errors.APIError>) -> Void) async {
        DispatchQueue.main.asyncAfter(seconds: 2) {
            onRequestCompleted(.success(exerciseData))
        }
    }
}
