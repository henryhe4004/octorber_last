//
//  LaunchView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/10/12.
//

import SwiftUI


struct LaunchView: View {
    @State var distance: Double = 0
    @State var brightness: Double = 0
    @State var isAnimating = false
    var body: some View {
        ZStack {
                Image("LaunchBackground")
                        .resizable()
                        .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            
                Image("launchRadius")
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeOut(duration: 3))
                    .offset(x: 0, y: isAnimating ? 100 : 0)
                   
            Text("欢迎您的加入")
                .font(.title)
                    .foregroundColor(/*@START_MENU_TOKEN@*/Color("AccentColor")/*@END_MENU_TOKEN@*/)
                    .bold()
                    .offset(y: 280)

                
        }
        .onAppear{
            self.isAnimating.toggle()
    }
      
        
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
