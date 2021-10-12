//
//  LoadingView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/10/10.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack{
            Rectangle().frame(width: 100, height: 100, alignment: .center)
                .background(Color.gray).opacity(0.1).cornerRadius(15)
            ProgressView("加载中...").progressViewStyle(CircularProgressViewStyle())
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
