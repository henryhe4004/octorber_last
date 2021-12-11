//
//  LeftMenuView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/10/14.
//

import SwiftUI
import LeanCloud
import YPImagePicker
import Kingfisher

struct PersonItem{
    let name : String
    let id : Int
    let objectId : String
    let url : String
}

class Person: ObservableObject {
    @Published var items = [PersonItem]()
}


struct LeftMenuView: View {
    
//    @ObservedObject var treeData : FamilyTreeData
    @ObservedObject var person = Person()
    @Binding var familyMemberCountWrite : Int
    @ObservedObject var avatarListModel : AvatarListModel
    

   
    var body: some View {
        VStack(alignment: .leading) {
            if(person.items.count == 0){
                Text("现在还没有人来申请哦")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .offset(y:-UIScreen.main.bounds.height/2 + 100)
            }else{
                
                ForEach(Array(person.items.enumerated()), id: \.1.id) { (index,item) in
                        HStack {
                            VStack {
                                HStack {
                                    if(item.url == "father\n" || item.url == "" || item.url == "father"){
                                        Image("father")
                                            .resizable()
                                            .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                            .shadow(color: Color.gray, radius: 3, x: 5, y: 5)
                                    }else{
                                        KFImage.url(URL(string:item.url))
                                            .resizable()
                                            .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                            .cornerRadius(40)
                                            .shadow(color: Color.gray, radius: 3, x: 5, y: 5)
                                    }
                                    
                                   
                                    Text(item.name)
                                        .foregroundColor(.black)
                                        .font(.headline)
                                        .frame(height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                }
                                .frame(width:UIScreen.main.bounds.width/2, alignment: .leading)
                                    
                                    HStack {
                                        Button(action: {
                                            let todo = LCObject(className: "InvitationUser", objectId: item.objectId)
                                            _ = todo.delete { result in
                                                switch result {
                                                case .success:
//                                                    withAnimation(){
                                                        person.items.remove(at: index)
//                                                    }
                                                    break
                                                case .failure(error: let error):
                                                    print(error)
                                                }
                                            }
                                        }) {
                                            Text("忽略")
                                                .foregroundColor(.red)
                                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                        }
                                        .border(Color.red)
                                        .cornerRadius(10)
                                        Button(action: {
                                            //获取tree ID
                                            //获取object ID
                                            //修改成员加一
                                            //获取tree ID
                                            let queryTreeId = LCQuery(className: "InvitationUser")
                                            let _ = queryTreeId.get(item.objectId) { (result) in
                                                switch result {
                                                case .success(object: let tree):
                                                    let treeId = (tree.get("treeId")?.intValue)!
                                                  
                                                    do {
                                                        let todo = LCObject(className: "InvitationUser", objectId: item.objectId)
                                                        try todo.set("status", value: 1)
                                                        todo.save { (result) in
                                                            switch result {
                                                            case .success:
                                                                    person.items.remove(at: index)
                                                                break
                                                            case .failure(error: let error):
                                                                print(error)
                                                            }
                                                        }
                                                    } catch {
                                                        print(error)
                                                    }

                                                    

                                                //获取object ID
                                                    let queryObjectId = LCQuery(className: "familyTree")
                                                    queryObjectId.whereKey("familyId", .equalTo(treeId))
                                                    _ = queryObjectId.find { result in
                                                        switch result {
                                                        case .success(objects: let id):
                                                            for item in id{
                                                                let objectId = (item.objectId?.stringValue)!
                                                                let familyNum = (item.get("familyNum")?.intValue)!
                                                                familyMemberCountWrite = familyNum
                                                                do {
                                                                    let editFamilyNum = LCObject(className: "familyTree", objectId: objectId)
                                                                    try editFamilyNum.set("familyNum", value: familyNum + 1)
                                                                    editFamilyNum.save { (result) in
                                                                        switch result {
                                                                        case .success:
                                                                            familyMemberCountWrite =  familyNum + 1
                                                                            
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
                                                    

                                                case .failure(error: let error):
                                                    print(error)
                                                }
                                            }
                                         
                                        }) {
                                            Text("同意")
                                                .foregroundColor(.white)
                                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                            
                                                
                                        }
                                        .background(Color.green)
                                        .cornerRadius(10)
                                        
                                    }
                                    .frame(width:UIScreen.main.bounds.width/2 - 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .animation(.easeInOut)
                                
                                  
                                }
                                .frame(width: UIScreen.main.bounds.width/2 - 10,
                                   alignment: .leading)
                            
                            
                        }
                    
                                 
                }
            }
          
            Spacer()
        }
        .padding(.top,20)
//        .padding(.leading,20)
        .edgesIgnoringSafeArea(.all)
        .frame( width:UIScreen.main.bounds.width/2,height:UIScreen.main.bounds.height - 190,alignment: .trailing)
       
        .background(Color(hue: 0.111, saturation: 0.321, brightness: 0.974))
        .cornerRadius(30)
        .onAppear(){
            let objectId = LCApplication.default.currentUser?.objectId
            let query = LCQuery(className: "_User")
            let _ = query.get(objectId!) { (result) in
                switch result {
                case .success(object: let todo):
                    let status = todo.get("status")?.intValue
                    let familyTreeId  = todo.get("familyTreeId")?.intValue
                    if(status == 1){
                        let InvitationUser = LCQuery(className: "InvitationUser")
                        InvitationUser.whereKey("treeId", .equalTo( familyTreeId!))
                        InvitationUser.whereKey("status", .equalTo(0))
                        
                        _ = InvitationUser.find { result in
                            switch result {
                            case .success(objects: let user):
                                for item in user{
                                    let personItem = PersonItem(name:(item.username?.stringValue)!, id: ((item.userId?.intValue)!) ,objectId:(item.objectId?.stringValue)!, url: (item.url?.stringValue)!)
                                    self.person.items.append(personItem)
                                    
        

                                }
                                print(person.items.count)
                               
                                
                                break
                            case .failure(error: let error):
                                print(error)
                            }
                        }
                    }

                case .failure(error: let error):
                    print(error)
                }
            }
        }
    }
}


