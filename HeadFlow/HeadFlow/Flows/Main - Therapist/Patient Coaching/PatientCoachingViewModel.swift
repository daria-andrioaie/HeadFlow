//
//  PatientCoachingViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 30.04.2023.
//

import Foundation
import SwiftUI

extension PatientCoaching {
    class ViewModel: ObservableObject {
        let therapistService: TherapistServiceProtocol
        let patient: User
        let onBack: () -> Void
        
        var patientName: String {
            patient.firstName + " " + patient.lastName
        }
        init(therapistService: TherapistServiceProtocol,
             patient: User,
             onBack: @escaping () -> Void) {
            self.therapistService = therapistService
            self.patient = patient
            self.onBack = onBack
        }
    }
}
