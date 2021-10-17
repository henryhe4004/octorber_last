//
//  CardView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/10/13.
//

import SwiftUI

struct CardView: View {

    let card: Card

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.white)
                .shadow(radius: 10)

            VStack {
//                Text(card.prompt)
//                    .font(.title)
//                    .foregroundColor(Color("AccentColor"))
             
                Image(systemName:card.answer)
                    .foregroundColor(Color("AccentColor"))
                    .frame(width: 120, height: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                Spacer()
                Text(card.prompt)
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                    
               
            }
            .padding(35)

        }
        .frame(width: 240, height: 240)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}
