//
//  WhetherLoginBeforeUIView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/10/14.
//

import SwiftUI
import LeanCloud
struct WhetherLoginBeforeUIView: View {
    @Binding var isLogin : Bool
    @Binding var isFirstLogin : LCBool
    @Binding var isPressed1 : Bool
    @Binding var objectId:LCString
    @ObservedObject var album : Album
    @State var isAnimating = false
    var body: some View {
        
        LoginUIView(isLogin: $isLogin, isFirstLogin: $isFirstLogin, isPressed1: $isPressed1, objectId: $objectId)
      
            .fullScreenCover(isPresented: $isPressed1, onDismiss: {
                            print("3\(isPressed1)")
                        }) {
                IsCreaterView(objectId: $objectId,isPressed:$isPressed1, isLogin: $isLogin)
                        }
            .fullScreenCover(isPresented: $isLogin, onDismiss: {
                            print("Detail View Dismissed")
                        }) {
//                            HomeUIView().onAppear(perform:{album.update()})
                            
                            HomeUIView(album:album,isLogin: $isLogin, isFirstLogin: $isFirstLogin, isPressed1: $isPressed1, objectId: $objectId)
                                            .opacity(isAnimating ? 1 : 0)
                                            .animation(Animation.spring().delay(0.2))
                                            .onAppear(
                                                perform:{
                                                    self.isAnimating.toggle()
                                                    album.update()
                                                }
                                            )

                        }
    }
}


