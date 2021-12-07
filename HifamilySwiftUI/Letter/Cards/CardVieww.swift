//
//  CardView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/12/6.
//

import SwiftUI

struct CardVieww: View {
    let card: Cardd
    
    var body: some View {
        VStack() {
            Text("\(card.image)")
                .layoutPriority(97)
                .clipped()
                .aspectRatio(contentMode: .fit)
                .fixedSize(horizontal: false, vertical: true)
                .padding(EdgeInsets(top: 10, leading: 8, bottom: 5, trailing: 0))
                .font(.system(size: 25))
            HStack() {
                VStack(alignment: .leading) {
                    Text("\(card.title.formatted(.iso8601.month().day().year().dateSeparator(.dash)))")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.bottom, 8)
                        .fixedSize(horizontal: false, vertical: true)
                        .layoutPriority(98)
                    
                    Text("\(card.subtitle)")
                        .font(.caption)
                        .fixedSize(horizontal: false, vertical: true)
                        .layoutPriority(99)
                        .frame(alignment: .topLeading)
                        .padding(EdgeInsets(top: 0, leading: 10,bottom: 0, trailing: 0))
                }
                Spacer()
            }
            .padding([.leading, .trailing, .bottom], 8)
        }
        .cornerRadius(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.5))
        )
    }
}

//struct CardVieww_Previews: PreviewProvider {
//    static var previews: some View {
//        CardVieww(card: Cardd(image: "信件内容", title: "发信人", subtitle: "时间"))
//            .padding()
//            .previewLayout(.sizeThatFits)
//    }
//}

