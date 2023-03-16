//
//  SessionService.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 14.03.2023.
//

import Foundation
import Alamofire

protocol SessionServiceProtocol {
    func isTokenValid() -> Bool
}

class SessionService: SessionServiceProtocol {
    var path: Constants.ServerPathType = .local
    
    init(path: Constants.ServerPathType) {
        self.path = path
    }
    
    func isTokenValid() -> Bool {
        var isValid = false
        let sessionToken = Session.shared.accessToken
        
        if let sessionToken {
            let semaphore = DispatchSemaphore(value: 0)
            
            let headers: HTTPHeaders = ["Authorization": "Bearer \(sessionToken)"]
            
            AF.request(path.rawValue + "/user/check-token", method: .post, headers: headers)
                .responseDecodable(of: BasicResponse.self) { response in
                    switch response.result {
                        
                    case .success(let validityResponse):
                        if validityResponse.success {
                            isValid = true
                        } else {
                            isValid = false
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        isValid = false
                    }
                    semaphore.signal()
                }
            semaphore.wait()
        } else {
            isValid = false
        }
        
        return isValid
    }
}


class MockSessionService: SessionServiceProtocol {
    func isTokenValid() -> Bool {
        return true
    }
}
