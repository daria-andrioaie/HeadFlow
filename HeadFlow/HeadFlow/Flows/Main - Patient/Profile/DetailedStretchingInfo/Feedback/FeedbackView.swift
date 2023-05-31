//
//  FeedbackView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 31.05.2023.
//

import SwiftUI

struct Feedback {
    struct ContentView: View {
        @StateObject var viewModel = ViewModel()
        let patient: User
        
        @ViewBuilder
        var body: some View {
            let userType = Session.shared.currentUser?.type ?? .patient
            
            if userType == .patient {
                therapistMessage
            } else {
                patientFeedback
            }
        }
        
        var patientFeedback: some View {
            HStack(alignment: .bottom, spacing: 15) {
                Feedback.InputView(viewModel: viewModel)

                HFAsyncImage(url: URL(string: "https://res.cloudinary.com/dlxu99ldy/image/upload/v1684178297/cld-sample.jpg"), placeholderImage: .profileImagePlaceholder)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
            .padding(.horizontal, 24)
        }
        
        var therapistMessage: some View {
            HStack(alignment: .bottom) {
                HFAsyncImage(url: URL(string: "https://res.cloudinary.com/dlxu99ldy/image/upload/v1684178297/cld-sample.jpg"), placeholderImage: .profileImagePlaceholder)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 12) {
                    Text("'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s'")
                        .italic()
                        .foregroundColor(.danubeBlue)
                    
                    Text("- Daniela Bucur")
                        .font(.Main.semibold(size: 18))
                        .foregroundColor(.oceanBlue)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.diamond
                    .roundedCorners([.topLeft, .topRight, .bottomRight], radius: 16)
                )
            }
            .padding(.horizontal, 24)
        }
    }
}


struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        Feedback.ContentView(patient: .mockPatient1)
    }
}
