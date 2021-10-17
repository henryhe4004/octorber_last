//
//  IsCreaterView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/10/17.
//

import SwiftUI

struct IsCreaterView: View {
    var body: some View {
        GeometryReader { geo in
        ZStack {
            Image("family")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                    HStack {
                        Text("创建者")
                            .font(.title2)
                        Spacer()
                        Image("right-arrows")
                    }
                    .padding()
                }
                .frame(width: 308, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color(red: 0.952, green: 0.523, blue: 0.008))
                .foregroundColor(.white)
                .cornerRadius(21)
                
                Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                    HStack {
                        Text("加入者")
                            .font(.title2)
                        Spacer()
                        Image("right-arrows")
                    }
                    .padding()
                }
                .frame(width: 308, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color(red: 0.939, green: 0.635, blue: 0.201))
                .foregroundColor(.white)
                .cornerRadius(21)
                Spacer()
            }
            .frame(width: geo.size.width, height: 2*geo.size.height/3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(.top,20)
            
           
        }
        .frame(width:geo.size.width - 20)
        }
        
    }
}

struct IsCreaterView_Previews: PreviewProvider {
    static var previews: some View {
        IsCreaterView()
    }
}
