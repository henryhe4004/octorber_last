//
//  WriteLetterVeiw.swift
//  HifamilySwiftUI
//
//  Created by 吴柏辉 on 2021/9/17.
//

import SwiftUI
import LeanCloud

final class Letters: ObservableObject {
    @Published  var letter:String
    @Published var recipient:String
    @Published var sender:String
    init() {
        letter = ""
        recipient = ""
        sender = ""
    }
}

final class LCLetter: ObservableObject {
    @Published var letterContent:String
    @Published var letterStatus:Int
    @Published var receiveLetterId:String
    @Published var sendLetterId:String
    @Published var letterObjectId:String
    
    @Published var sendName:String
    @Published var receiveName:String
    
    init() {
        letterContent = ""
        receiveLetterId = ""
        sendLetterId = ""
        letterStatus = 0
        letterObjectId = ""
        
        sendName = ""
        receiveName = ""
    }
    
    func insertLetter(letterContent:String, receiveLetterId:String,letterSatus:Int,sendName:String, receiveName:String) {
        // 获取当前用户的Id
        let sendLetterId = LCApplication.default.currentUser?.objectId?.value
        do {
            // 构建对象
            let todo = LCObject(className: "Letter")
            // 为属性赋值
            try todo.set("letterContent", value: letterContent)
            try todo.set("sendLetterId", value: sendLetterId)
            try todo.set("receiveLetterId", value: receiveLetterId)
            try todo.set("letterStatus", value: letterStatus)
            // 将对象保存到云端
            _ = todo.save { result in
                switch result {
                case .success:
                    print(todo.jsonValue)
                    self.letterObjectId = (todo.objectId?.stringValue)!
                    print("***")
                    print(self.letterObjectId)
                    do {
                        // 构建对象
                        let todo = LCObject(className: "LetterM")
                        // 为属性赋值
                        try todo.set("receiveName", value: receiveName)
                        try todo.set("sendName", value: sendName)
                        try todo.set("letterObjectId", value: self.letterObjectId)
                        // 将对象保存到云端
                        _ = todo.save { result in
                            switch result {
                            case .success:
                                print(todo.jsonValue)
                                break
                            case .failure(error: let error):
                                // 异常处理
                                print(error)
                            }
                        }
                    } catch {
                        print(error)
                    }
                    break
                case .failure(error: let error):
                    // 异常处理
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
}


final class LCMumber:ObservableObject {
    
    @Published var mumbersObjectId : [String]
    @Published var mumbersName: [String]
    @Published var familyMumber: [String]
    
    
    init() {
        mumbersObjectId = []
        mumbersName = []
        familyMumber = ["我","爸爸","妈妈","爷爷","奶奶","外婆","外公","孙子","孙女","舅舅"]
    }
    
    func queryFamilyMumber() {
        // 获取当前用户的Id
        let sendLetterId = LCApplication.default.currentUser?.objectId?.value
        let query = LCQuery(className: "_User")
        var familyTreeId = 0
        // 先查出 当前用户的家庭树ID
        query.whereKey("objectId", .equalTo(sendLetterId!))
        
        _ = query.getFirst { result in
            switch result {
            case .success(object: let todo):
                // 获取到了
                familyTreeId = (todo.familyTreeId?.intValue)!
//                print(todo)
                // 查询家庭树下的所有成员objectId
                let query = LCQuery(className: "_User")
                query.whereKey("familyTreeId", .equalTo(familyTreeId))
                _ = query.find { result in
                    switch result {
                    case .success(objects: let mumbers):
//                        print(mumbers)
                        for Item in mumbers {
                            // 如果是自己，不加入
                            if((Item.objectId?.stringValue!)! != sendLetterId) {
                                self.mumbersObjectId.append((Item.objectId?.stringValue!)!)
                                self.mumbersName.append(self.familyMumber[(Item.familyPosition?.intValue!)!])
                            }
                        }
                        print(self.mumbersName)
                        break
                    case .failure(error: let error):
                        print(error)
                    }
                }
            case .failure(error: let error):
                print(error)
            }
        }
    }
}

struct WriteLetterView: View {
    
    @ObservedObject var letterr:Letters = Letters()
    
    @ObservedObject var lcletter:LCLetter = LCLetter()
    
    @ObservedObject var lcmumber:LCMumber = LCMumber()
    
    @State var isselect1 = true
    @State var isselect2 = false
    
    @State var showSheet:Bool = false
    
    @State var isfirst = false
    
    @State var selectedItem = 0
    
    @State var txt:String = "选择你的家人"
    
    
    
    var body: some View {

        VStack {
            Divider()
            VStack{
                VStack {
                    HStack {
                        Text("收件人:")
                            .foregroundColor(Color(UIColor(red: 0.38, green: 0.38, blue: 0.38,alpha:1)))
                            .font(.system(size: 20))
                        TextField(
                            "输入昵称",
                            text: $letterr.recipient
                        ) {isEditing in
                            self.letterr.recipient = letterr.recipient
                        }.font(.system(size: 20))
                        Button(txt) {
                            if(self.showSheet == false) {
                                self.showSheet = true
                            }
                        }.font(.system(size: 20))
                        .sheet(isPresented: self.$showSheet, content:{
                            ContentVeiw(lcmumber: lcmumber, selectedItem: $selectedItem, showSheet: self.$showSheet, txt:$txt)
                        })
                        
                        
                    }.padding(EdgeInsets(top: 28, leading: 33, bottom: 0, trailing: 20))
                    Divider()
                        .frame(width:323 ,height: 1 ,alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding(EdgeInsets(top: -1, leading: 0, bottom: 0, trailing: 0))
                }
                
                VStack {
                    KeyboardHost{
                        TextEditor(text: $letterr.letter)
                            .frame(width: 323, height: 200,alignment: .topLeading)
                                           .foregroundColor(grayColor2)
                                           .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                           .multilineTextAlignment(.leading)
                                           .overlay(RoundedRectangle(cornerRadius: 10.0, style: .continuous).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 1.4)).shadow(radius: 1)
                                       }
                                       .dismissKeyboardOnTap()
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                VStack {
                    HStack {
                        Text("寄信人:")
                            .foregroundColor(Color(UIColor(red: 0.38, green: 0.38, blue: 0.38,alpha:1)))
                            .font(.system(size: 20))
                        TextField(
                            "输入",
                            text: $letterr.sender
                        ) {isEditing in
                            self.letterr.sender = letterr.sender
                        }.font(.system(size: 20))
                        
                    }.padding(EdgeInsets(top: 28, leading: 33, bottom: 0, trailing: 20))
                    Divider()
                        .frame(width:323 ,height: 1 ,alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding(EdgeInsets(top: -1, leading: 0, bottom: 0, trailing: 0))
                }
                VStack {
                    Image("family-letter")
                        .padding(EdgeInsets(top: 14, leading: -110, bottom: 0, trailing: 0))
                }
                VStack {
                    ZStack {
                        Button(action: {
                            lcletter.letterStatus = 0
                            if(isselect1 == false && isselect2 == false) {
                                isselect1 = true
                            }
                            else if(isselect1 == false && isselect2 == true){
                                isselect1 = true
                                isselect2 = false
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 13)
                                    .frame(width: 58, height: 29, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(isselect1 == true ? orangeColor:Color(UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)))
                                Text("公开")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                            }
                        }
                    }
                    ZStack {
                        Button(action: {
                            lcletter.letterStatus = 1
                            if(isselect2 == false && isselect1 == false) {
                                isselect2 = true
                            }
                            else if(isselect1 == true && isselect2 == false){
                                isselect2 = true
                                isselect1 = false
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 13)
                                    .frame(width: 58, height: 29, alignment: .center)
                                    .foregroundColor(isselect2 == true ? orangeColor:Color(UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)))
                                Text("私密")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                            }
                        }
                    }.padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
                }.padding(EdgeInsets(top: 20, leading: 250, bottom: 0, trailing:0))
            }.navigationBarTitle(Text("写家书").foregroundColor(grayColor2)
                .font(.system(size: 22)),displayMode: .inline)
            .navigationBarItems(trailing: Button(
                action:{
                lcletter.insertLetter(letterContent: letterr.letter, receiveLetterId: lcmumber.mumbersObjectId[selectedItem],letterSatus: lcletter.letterStatus,sendName: letterr.sender, receiveName: letterr.recipient)
                
                    // 执行完后全部为空
                    letterr.letter = ""
                    lcletter.letterStatus = 0
                    letterr.sender = ""
                    letterr.recipient = ""

            }){
                Text("寄出")
                    .foregroundColor(orangeColor)
            })
            Spacer()
        }.onAppear() {
            if(lcmumber.mumbersName.count == 0) {
                lcmumber.queryFamilyMumber()
            }
        }
    }
}
