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
            
          
                
            HStack() {
                VStack(alignment: .leading) {
                    
                    Text("智妍:").frame(alignment: .topLeading)
                            .font(.system(size: 18))
                            .layoutPriority(97)
                            .clipped()
                            .aspectRatio(contentMode: .fit)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(EdgeInsets(top: 20, leading: 9, bottom: 10, trailing: 0))
                            .font(.system(size: 25))
                  
                    Text("\(card.subtitle)")
                        .font(.caption)
                        .fixedSize(horizontal: false, vertical: true)
                        .layoutPriority(99)
                        .frame(alignment: .topLeading)
                        .padding(EdgeInsets(top: 0, leading: 10,bottom: 0, trailing: 0))
                    Text("寄信人:\(card.image)").frame(alignment: .topLeading)
                        .font(.system(size: 10))
                        .layoutPriority(97)
                        .clipped()
                        .aspectRatio(contentMode: .fit)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(EdgeInsets(top: 5, leading: 8, bottom: 0, trailing: 0))
                        .font(.system(size: 25))
                    Text("收信人:智妍").frame(alignment: .topLeading)
                            .font(.system(size: 10))
                            .layoutPriority(97)
                            .clipped()
                            .aspectRatio(contentMode: .fit)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                            .font(.system(size: 25))
                    Text("\(card.title.formatted(.iso8601.month().day().year().dateSeparator(.dash)))")
                        .frame(alignment: .topTrailing)
                        .font(.system(size: 10))
                        .foregroundColor(.primary)
                        .padding(.bottom, 8)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                        .layoutPriority(98)
                }
                Spacer()
            }
            .padding([.leading, .trailing, .bottom], 8)
        }
        .cornerRadius(20)
//        .shadow(color: .gray, radius: 10, x: 0, y: 3)
        .overlay(RoundedRectangle(cornerRadius: 20.0, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 1.4)).shadow(radius: 1)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.secondary.opacity(0.5))
                .shadow(color: Color.white, radius: 5)
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

