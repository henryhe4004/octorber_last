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
//这里改了！！！
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
    @State var isPressed1 = false
    @State var objectId:LCString = ""
    @ObservedObject var album : Album = Album()
    @ObservedObject var user: InformationUser = InformationUser ()
    @ObservedObject var treeData : FamilyTreeData = FamilyTreeData()
    @ObservedObject var avatarListModel : AvatarListModel = AvatarListModel()
    //左边菜单栏
    @State var showLeftMenu = false
    @State var username = ""
    @State var status = 0
    @State var avatar = ""
    
    var body: some View {
        if let user = LCApplication.default.currentUser {
            HomeUIView(album:album,isLogin: $isLogin, isFirstLogin: $isFirstLogin, isPressed1: $isPressed1, objectId: $objectId).debugPrint(user.objectId!).onAppear(perform: {
                    album.update()
                    //这里首页
          
            })

        } else {
            WhetherLoginBeforeUIView(isLogin: $isLogin,isFirstLogin:$isFirstLogin,isPressed1: $isPressed1,objectId: $objectId,album:album,user:user,treeData:treeData,avatarListModel:avatarListModel)
        }
    }
}

////第二个结构体声明为第一个视图的预览视图
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
