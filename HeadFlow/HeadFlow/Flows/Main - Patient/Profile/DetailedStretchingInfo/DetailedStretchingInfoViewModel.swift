//
//  DetailedStretchingInfoViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 25.03.2023.
//

import Foundation
import SwiftUI

extension DetailedStretchingInfo {
    class ViewModel: ObservableObject {
        @MainActor
        func pdfRendering(patient: User, stretchingSession: StretchSummary.Model) -> URL {
            if #available(iOS 16.0, *) {
                let renderer = ImageRenderer(content:
                    DetailedStretchingInfo.PDFSummaryView(patient: patient,
                                                          stretchingSession: stretchingSession)
                )
                let date = stretchingSession.date.toCalendarDate(.numeric).replacing("/", with: "-")
                let path = "summary-" + patient.firstName + "-" + patient.lastName + "-" + date + ".pdf"
        
                let url = URL.documentsDirectory.appending(path: path)
                
                renderer.render { size, context in
                    var box = CGRect(origin: .zero, size: size)
                    
                    guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                        return
                    }
                    
                    pdf.beginPDFPage(nil)
                    
                    context(pdf)
                    
                    pdf.endPage()
                    pdf.closePDF()
                }
                
                return url
            } else {
                return URL(string: "https://www.google.com/")!
            }
        }
    }
}
