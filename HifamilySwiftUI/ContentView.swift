//
//  ContentView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/13.
//

import SwiftUI
import CoreData
import LeanCloud
//第一个结构体遵循View协议，描述视图的内容和布局
extension View {
    func debugPrint(_ value:Any) -> some View {
        #if DEBUG
        print(value)
        #endif
        return self
    }
}


struct ContentView: View {
    //body 属性只返回单个视图，这时组合多个视图把他们放入一个栈中
    @State var isLogin : Bool = false
    @State var isFirstLogin : LCBool = true
    @State var isPressed = false
    @State var objectId:LCString = ""
    
    var body: some View {
//        if let user = LCApplication.default.currentUser {
//            HomeUIView().debugPrint(user.objectId!)
//
//        } else {
            WhetherLoginBeforeUIView(isLogin: $isLogin,isFirstLogin:$isFirstLogin,isPressed1: $isPressed,objectId: $objectId)
            
//        }
    }
}

//第二个结构体声明为第一个视图的预览视图
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
