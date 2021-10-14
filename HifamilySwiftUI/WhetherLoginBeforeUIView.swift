//
//  WhetherLoginBeforeUIView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/10/14.
//

import SwiftUI

struct WhetherLoginBeforeUIView: View {
    @Binding var isLogin : Bool
    var body: some View {
        LoginUIView(isLogin: $isLogin)
            .fullScreenCover(isPresented: $isLogin, onDismiss: {
                            print("Detail View Dismissed")
                        }) {
                            HomeUIView()
                        }
    }
}


