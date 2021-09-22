//
//  HomeLandUIView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/15.
//

import SwiftUI
import CoreData



struct HomeLandUIView: View {
    

    
    var body: some View {
 
        ZStack {
           
            ZStack {
                Image("notice")
                    .padding(.init(top: 300, leading: -180, bottom: 0, trailing: 0))

            }
            RoundedRectangle(cornerRadius: 27)
                .fill(LinearGradient(gradient: .init(colors: [Color("LandColorBefore"), Color("LandColorAfter")]), startPoint:  .leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/ .trailing))
                .frame(minWidth: 300, idealWidth: 400, maxWidth: 600, minHeight: 200, idealHeight: 200, maxHeight: 200, alignment: .top)
                .offset( y: 335)
                .opacity(0.8)
        }
            
        
       
    }
}

struct HomeLandUIView_Previews: PreviewProvider {
    static var previews: some View {
        HomeLandUIView()
    }
}

