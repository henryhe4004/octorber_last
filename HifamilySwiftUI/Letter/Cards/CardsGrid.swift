//
//  CardsGrid.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/12/6.
//

import SwiftUI
import WaterfallGrid

struct CardsGrid: View {
    
    @Binding var cards: [Cardd]
    @Binding var settings: Settings
    
    var body: some View {
        
        #if os(iOS) && !targetEnvironment(macCatalyst)

        return
            ScrollView(showsIndicators: settings.showsIndicators) {
                WaterfallGrid((0..<cards.count), id: \.self) { index in
                    CardVieww(card: self.cards[index])
                }
                .gridStyle(
                    columnsInPortrait: Int(settings.columnsInPortrait),
                    columnsInLandscape: Int(settings.columnsInLandscape),
                    spacing: CGFloat(settings.spacing),
                    animation: settings.animation
                )
                .padding(settings.padding)
            }
        
        #else

        return
            ScrollView(showsIndicators: settings.showsIndicators) {
                WaterfallGrid((0..<cards.count), id: \.self) { index in
                    CardView(card: self.cards[index])
                }
                .gridStyle(
                    columns: Int(settings.columns),
                    spacing: CGFloat(settings.spacing),
                    animation: settings.animation
                )
                .padding(settings.padding)
            }

        #endif

    }
}

//struct CardsGrid_Previews: PreviewProvider {
//    static let cards = [
//        Cardd(image: "image0", title: Data(), subtitle: LoremIpsum.randomSentences()),
//        Cardd(image: "image1", title: Data(), subtitle: LoremIpsum.randomSentences())
//    ]
//    static let settings: Settings = Settings.default(for: .images)
//    
//    static var previews: some View {
//        CardsGrid(cards: .constant(cards), settings: .constant(settings))
//    }
//}
