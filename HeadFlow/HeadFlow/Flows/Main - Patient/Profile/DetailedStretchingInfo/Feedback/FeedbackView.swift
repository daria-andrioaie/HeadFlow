//
//  FeedbackView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 31.05.2023.
//

import SwiftUI

struct Feedback {
    struct ContentView: View {
        @StateObject var viewModel: ViewModel
        
        init(sessionId: String, feedbackService: FeedbackServiceProtocol) {
            self._viewModel = StateObject(wrappedValue: .init(sessionId: sessionId, feedbackService: feedbackService))
        }
        
        @ViewBuilder
        var body: some View {
            if viewModel.isFeedbackLoading {
                ScalingDots(circleWidth: 10)
                    .opacity(0.5)
            } else {
                let userType = Session.shared.currentUser?.type ?? .patient
                if userType == .patient, let feedback = viewModel.feedback {
                    patientFeedback(feedback)
                } else if userType == .therapist {
                    therapistFeedback
                }
            }
        }
        
        @ViewBuilder
        var therapistFeedback: some View {
            if let feedback = viewModel.feedback {
                HStack(alignment: .bottom) {
                    VStack(alignment: .trailing, spacing: 12) {
                        Text("\"\(feedback.message)\"")
                            .italic()
                            .foregroundColor(.danubeBlue)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("- You")
                            .font(.Main.semibold(size: 18))
                            .foregroundColor(.oceanBlue)
                    }
                    .padding(20)
                    .background(Color.diamond
                        .roundedCorners([.topLeft, .topRight, .bottomLeft], radius: 16)
                    )
                    .overlay(editButton(currentMessage: feedback.message),
                             alignment: .topTrailing)
                    
                    HFAsyncImage(url: feedback.therapist.profilePicture, placeholderImage: .profileImagePlaceholder)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                .padding(.horizontal, 24)
            } else {
                HStack(alignment: .bottom, spacing: 15) {
                    Feedback.InputView(viewModel: viewModel)

                    HFAsyncImage(url: Session.shared.currentUser?.profilePicture, placeholderImage: .profileImagePlaceholder)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                .padding(.horizontal, 24)
            }
        }
        
        func editButton(currentMessage: String) -> some View {
            Button {
                viewModel.inputText = currentMessage
                viewModel.feedback = nil
            } label: {
                Text("edit")
                    .foregroundColor(.apricot)
                    .font(.Main.p1Regular)
            }
            .buttonStyle(.plain)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 24))
        }
        
        func patientFeedback(_ feedback: Feedback.Model) -> some View {
            HStack(alignment: .bottom) {
                HFAsyncImage(url: feedback.therapist.profilePicture, placeholderImage: .profileImagePlaceholder)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 12) {
                    Text("\"\(feedback.message)\"")
                        .italic()
                        .foregroundColor(.danubeBlue)
                    
                    Text("- \(feedback.therapist.firstName) \(feedback.therapist.lastName)")
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
        Feedback.ContentView(sessionId: "random_session",
                             feedbackService: MockFeedbackService())
    }
}
