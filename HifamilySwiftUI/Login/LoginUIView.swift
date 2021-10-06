//
//  LoginUIView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/10/6.
//

import SwiftUI
import LeanCloud

struct LoginUIView: View {
    var body: some View {
        Home()
            
}
}

struct LoginUIView_Previews: PreviewProvider {
    static var previews: some View {
        LoginUIView()
    }
}

struct Home : View {
    var body: some View{
        GeometryReader {_ in
            VStack{
                Image("welcome")
                    .resizable()
                    .frame(width: 136, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
            }
            VStack{
                HStack{
                    Text("Login")
                }
            }
        }
    }
}
