//
//  LeftMenuView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/10/14.
//

import SwiftUI

struct LeftMenuView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Image(systemName: "person")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Profile")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 100)
            HStack{
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Profile")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 100)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 32/255, green: 32/255, blue: 32/255))
        .edgesIgnoringSafeArea(.all)
    }
}

struct LeftMenuView_Previews: PreviewProvider {
    static var previews: some View {
        LeftMenuView()
    }
}
