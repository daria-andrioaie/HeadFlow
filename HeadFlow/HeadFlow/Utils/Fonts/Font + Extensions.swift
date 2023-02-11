//
//  Font + Extensions.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 11.02.2023.
//

import Foundation
import SwiftUI

enum MainFontName: String {
    case heavy = "Lato-Heavy"
    case bold = "Lato-Bold"
    case semibold = "Lato-Semibold"
    case regular = "Lato-Regular"
    case medium = "Lato-Medium"
    case light = "Lato-Light"
    case thin = "Lato-Thin"
    case hairline = "Lato-Hairline"
}

extension Font {
    struct Main {
        static func custom(_ fontName: MainFontName, size: CGFloat) -> Font {
            return .custom(fontName.rawValue, size: size)
        }
        
        static func heavy(size: CGFloat) -> Font {
            return custom(.heavy, size: size)
        }
        
        static func bold(size: CGFloat) -> Font {
            return custom(.bold, size: size)
        }
        
        static func semibold(size: CGFloat) -> Font {
            return custom(.semibold, size: size)
        }
        
        static func regular(size: CGFloat) -> Font {
            return custom(.regular, size: size)
        }
        
        static func medium(size: CGFloat) -> Font {
            return custom(.medium, size: size)
        }
        
        static func light(size: CGFloat) -> Font {
            return custom(.light, size: size)
        }
        
        static func thin(size: CGFloat) -> Font {
            return custom(.thin, size: size)
        }
        
        static func hairline(size: CGFloat) -> Font {
            return custom(.hairline, size: size)
        }
        
        //MARK: - Bold
        ///size 22, bold
        static var h1Bold: Font {
            return bold(size: 22)
        }
        
        ///size 16, bold
        static var h2Bold: Font {
            return bold(size: 16)
        }
        
        ///size 14, bold
        static var p1Bold: Font {
            return bold(size: 14)
        }
        
        ///size12, bold
        static var p2Bold: Font {
            return bold(size: 12)
        }
        
        //MARK: - SemiBold
        ///size 16, semibold
        static var h2SemiBold: Font {
            return semibold(size: 16)
        }
        
        ///size 14, semibold
        static var p1SemiBold: Font {
            return semibold(size: 14)
        }
        
        ///size 12, semibold
        static var p2SemiBold: Font {
            return semibold(size: 12)
        }
        
        ///size 10, semibold
        static var body1SemiBold: Font {
            return semibold(size: 10)
        }
        
        //MARK: - Medium
        ///size 14, medium
        static var p1Medium: Font {
            return medium(size: 14)
        }
        
        //MARK: - Regular
        ///size 14, regular
        static var p1Regular: Font {
            return regular(size: 14)
        }
    }
}
