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
                let objectId = (LCApplication.default.currentUser?.objectId)!
                self.user.objectId = objectId
                let query = LCQuery(className: "_User")
                let _ = query.get(user.objectId!) { (result) in
                    switch result {
                    case .success(object: let todo):
                        let createrId = (todo.id?.intValue)!
                        let status = (todo.status?.intValue)!
                        let url = (todo.url?.stringValue)!
                        self.avatar = url
                        self.status = status
                        self.username = (todo.username?.stringValue)!
    
                        //树上的头像
                        let familyId = (todo.familyTreeId?.intValue)!
                        if(familyId != 0){
                            let user = LCQuery(className: "_User")
                            user.whereKey("familyTreeId", .equalTo(familyId))
                            user.whereKey("status", .equalTo(1))
                            _ = user.find { result in
                                switch result {
                                case .success(objects: let user):
                                    for item in user{
                                        let avatar = AvatarList(url: (item.url?.stringValue)!, id: (item.id?.intValue)!,username: (item.username?.stringValue)!)
                                        self.avatarListModel.avatarList.append(avatar)
                                    }
                                    avatarListModel.arrayCount = avatarListModel.avatarList.count
                                    break
                                case .failure(error: let error):
                                    print(error)
                                }
                            }
    
                            let InvitationUser = LCQuery(className: "InvitationUser")
                            InvitationUser.whereKey("treeId", .equalTo(familyId))
                            InvitationUser.whereKey("status", .equalTo(1))
                            _ = InvitationUser.find { result in
                                switch result {
                                case .success(objects: let user):
                                    for item in user{
                                        let avatar = AvatarList(url: (item.url?.stringValue)!, id: (item.userId?.intValue)!,username: (item.username?.stringValue)!)
                                        self.avatarListModel.avatarList.append(avatar)
                                    }
                                    avatarListModel.arrayCount = avatarListModel.avatarList.count
    
                                    break
                                case .failure(error: let error):
                                    print(error)
                                }
                            }
    
                        }
    
    
                        if(status == 1){
                            //创建者
    
                            treeData.isHaveTree = true
                            let familyTree = LCQuery(className: "familyTree")
                            familyTree.whereKey("createrId", .equalTo(createrId))
                            _ = familyTree.find { result in
                                switch result {
                                case .success(objects: let tree):
                                    for item in tree{
                                    let treeName = (item.familyName?.stringValue)!
                                    let treeId = (item.familyId?.intValue)!
                                    let familyNum = (item.familyNum?.intValue)!
                                        self.treeData.familyMemberCountWrite = familyNum
                                        self.treeData.familyIdWrite = treeId
                                        self.treeData.treeObjectId = (item.objectId?.stringValue)!
                                        self.treeData.familyTreeName = treeName
                                        print("treeName:"+treeName)
                                        self.treeData.indexTree = (item.indexTree?.intValue)!
    
    
    
                                        //更新
                                        do {
                                            let todo = LCObject(className: "_User", objectId: user.objectId!)
                                            try todo.set("familyTreeId", value: treeId)
                                            todo.save { (result) in
                                                switch result {
                                                case .success:
                                                    break
                                                case .failure(error: let error):
                                                    print(error)
                                                }
                                            }
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    break
    
                                case .failure(error: let error):
                                    print(error)
                                }
                            }
                        }else{
                            //加入者???
                            treeData.isHaveTree = false
                            let query = LCQuery(className: "InvitationUser")
                            query.whereKey("userId", .equalTo(createrId))
                            _ = query.find { result in
                                switch result {
                                case .success(objects: let students):
                                    for item in students{
                                        let status = (item.status?.intValue)!
                                        let treeId = (item.treeId?.intValue)!
                                        if(status == 1){
                                            do {
                                                let todo = LCObject(className: "_User", objectId: user.objectId!)
                                                try todo.set("familyTreeId", value: treeId)
                                                todo.save { (result) in
                                                    switch result {
                                                    case .success:
                                                        //加入者
    
                                                        let treeId = todo.familyTreeId?.intValue
                                                        if(treeId == nil){
                                                            self.treeData.familyIdWrite = 0
                                                        }else{
                                                            self.treeData.familyIdWrite = treeId!
                                                            let familyTree = LCQuery(className: "familyTree")
                                                            familyTree.whereKey("familyId", .equalTo(treeId!))
                                                            _ = familyTree.find { result in
                                                                switch result {
                                                                case .success(objects: let tree):
                                                                    for item in tree{
                                                                    let treeName = item.familyName?.stringValue
                                                                    let familyNum = item.familyNum?.intValue
                                                                        self.treeData.familyMemberCountWrite = familyNum!
                                                                        self.treeData.treeObjectId = (item.objectId?.stringValue)!
                                                                        self.treeData.familyTreeName = treeName!
                                                                        self.treeData.indexTree = (item.indextree?.intValue)!
    
    
    
                                                                    }
                                                                    break
    
                                                                case .failure(error: let error):
                                                                    print(error)
                                                                }
                                                            }
                                                        }
                                                        break
                                                    case .failure(error: let error):
                                                        print(error)
                                                    }
                                                }
                                            } catch {
                                                print(error)
                                            }
                                        }
                                    }
                                    break
                                case .failure(error: let error):
                                    print(error)
                                }
                            }
    
    
    
                        }
    
    
                    case .failure(error: let error1):
                        print(error1)
                    }
    
                }
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
