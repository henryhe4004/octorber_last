//
//  MyTimeLineView.swift
//  HifamilySwiftUI
//
//  Created by 吴柏辉 on 2021/9/22.
//

import SwiftUI

struct MyTimeLineView: View {
    var body: some View {
        NavigationView {
        VStack {
            HStack {
                Image("Iconly-Bulk-Setting")
                    .resizable()
                    .frame(width:23,
                           height:23,
                           alignment:.center)
                Spacer()
                Text("写家书")
                    .foregroundColor(Color.black)
                    .font(.system(size: 22))
                Spacer()
                NavigationLink(destination: EditTimelineView()) { Text("寄出")
                        .foregroundColor(Color.black)
                        .font(.system(size: 22))
                }.navigationBarHidden(true)
                .navigationBarTitle("返回")
            }.padding()
            TimeLineRight()
        }
        }
    }
}

struct MyTimeLineView_Previews: PreviewProvider {
    static var previews: some View {
        MyTimeLineView()
    }
}
