//
//  SMSValidationView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 20.02.2023.
//

import SwiftUI

struct SMSValidation {
    struct ContentView: View {
        @ObservedObject var viewModel: ViewModel
        @FocusState private var isCodeFieldFocused: Bool
        
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        var body: some View {
            ContainerWithNavigationBar(title: nil, leftButtonAction: {
                viewModel.navigationAction(.goBack)
            }) {
                VStack(spacing: 60) {
                    noticeView
                    Group {
                        codeField
                        resendCodeView
                    }
                    .activityIndicator(viewModel.isLoading)
                }
                .padding(.horizontal, 24)
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .onReceive(timer) { _ in
                if viewModel.timeRemaining > 0 {
                    viewModel.timeRemaining -= 1
                }
            }
        }
        
        var noticeView: some View {
            VStack(spacing: 30) {
                HStack(spacing: 0) {
                    Text(Texts.SMSValidation.codeSentToLabel)
                        .font(.Main.regular(size: 20))
                    Text(viewModel.phoneNumber)
                        .font(.Main.bold(size: 20))
                }
                .foregroundColor(.oceanBlue)
                .padding(.top, 40)
                
                Text(Texts.SMSValidation.enterCodeLabel)
                    .multilineTextAlignment(.center)
                    .font(.Main.regular(size: 15))
                    .foregroundColor(.oceanBlue)
            }
        }
        
        var codeField: some View {
            HStack {
                ForEach(0..<4) { index in
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.decoGreen.opacity(0.2))
                        .frame(width: 55, height: 55)
                        .overlay(cellOverlay(index: index))
                }
            }
            .overlay(
                TextField(text: $viewModel.inputCode) { }
                    .focused($isCodeFieldFocused)
                    .keyboardType(.numberPad)
                    .introspectTextField { textField in
                        textField
                            .becomeFirstResponder()
                    }
                    .frame(height: 55)
                    .opacity(0)
            )
        }
        
        @ViewBuilder
        func cellOverlay(index: Int) -> some View {
            let digit = viewModel.inputCode[safe: index]
            
            if let digit = digit {
                Text(digit)
                    .foregroundColor(.oceanBlue)
                    .font(.Main.light(size: 24))
            }
            else if index == viewModel.inputCode.count {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.white)
                    .frame(width: 55, height: 55)
                    .roundedBorder(.danubeBlue, cornerRadius: 20)
            }
        }
        
        var resendCodeView: some View {
            HStack(spacing: 20) {
                Text("\(viewModel.timeRemaining)")
                    .font(.Main.bold(size: 18))
                
                Button {
                    //resend code
                    viewModel.timeRemaining = 30
                } label: {
                    Text(Texts.SMSValidation.resendCodeLabel)
                        .font(.Main.bold(size: 18))
                        .foregroundColor(viewModel.timeRemaining == 0 ? .oceanBlue : .decoGreen)
                }
                .buttonStyle(.plain)
                .disabled(viewModel.timeRemaining != 0)
            }
        }
    }
}

#if DEBUG
struct SMSValidationView_Previews: PreviewProvider {
    static var previews: some View {
        SMSValidation.ContentView(viewModel: .init(phoneNumber: "+40767998715", navigationAction: { _ in }))
    }
}
#endif
