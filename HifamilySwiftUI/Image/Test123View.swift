//
//  Test123View.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/11/2.
//

import SwiftUI

struct Test123View: View {
    @State var s : Bool = true
    var body: some View {
       
            ZStack(alignment: .bottomTrailing){
                if(s==true){
                    Rectangle()
                        .frame(width: 115, height: 115)
                        .opacity(0.2)
                }
                    Image("cat_walk")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 115, height: 115, alignment: .center)
                    .cornerRadius(20)
                if(s==false){
                    Rectangle()
                    .foregroundColor(Color.gray)
                    .frame(width: 25, height: 25)
                    .cornerRadius(5)
                    .border(Color.white)
                    .opacity(0.4)
                }else{
                    ZStack{
                        Rectangle()
                        .foregroundColor(Color.blue)
                        .frame(width: 25, height: 25)
                        .cornerRadius(7)
                        .border(Color.white)
                        .opacity(0.8)
                        Image("right").frame(width: 20, height: 20 )
                        
                    }
                }
            }.cornerRadius(13)
        }
    
}

struct Test123View_Previews: PreviewProvider {
    static var previews: some View {
        Test123View()
    }
}
