//
//  HFAsyncImage.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 14.05.2023.
//

import SwiftUI
import Kingfisher

struct HFAsyncImage<Placeholder: View>: View {
    
    var url: URL?
    var contentMode: SwiftUI.ContentMode = .fill
    @ViewBuilder var placeholder: Placeholder
    
    var body: some View {
        KFImage(url)
            .placeholder {
                placeholder
            }
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}

extension HFAsyncImage where Placeholder == EmptyView {
    
    init(url: URL?) {
        self.url = url
        self.placeholder = EmptyView()
    }
}

extension HFAsyncImage where Placeholder == Image {
    
    //Note: this initialisers will apply resizable to any placeholder of the type Image
    init(url: URL?, contentMode: SwiftUI.ContentMode = .fill, @ViewBuilder placeholder: () -> Placeholder) {
        self.url = url
        self.contentMode = contentMode
        self.placeholder = placeholder().resizable()
    }
    
    //Note: this initialisers will apply resizable to any placeholder of the type ImoImage
    init(url: URL?, contentMode: SwiftUI.ContentMode = .fill, placeholderImage: HFImage) {
        self.url = url
        self.contentMode = contentMode
        self.placeholder = Image(placeholderImage).resizable()
    }
}

#if DEBUG
struct HFAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 10) {
            HFAsyncImage(url: nil, placeholderImage: .placeholderImage)
                .frame(height: 200)
                .clipped()
            
            HFAsyncImage(url: URL(string: "https://img3.imonet.ro/X3SH/3SH10012EK7/apartament-de-vanzare-2-camere-cluj-napoca-gheorgheni-181093603.jpg"), placeholderImage: .placeholderImage)
                .frame(height: 200)
                .clipped()
            
            HFAsyncImage(url: URL(string: "https://img3.imonet.ro/X3SH/3SH10012EK7/apartament-de-vanzare-2-camere-cluj-napoca-gheorgheni-181093603.jpg"), placeholderImage: .placeholderImage)
        }
    }
}
#endif
