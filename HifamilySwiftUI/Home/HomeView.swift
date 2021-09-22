//
//  HomeView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/14.
//

import SwiftUI
import CoreData

//家庭树名字
class FamilyNameModel: ObservableObject {
    @Published var FamilyTreeName: String = "相亲相爱一家人"
}

struct HomeView: View {
    
    @State var isPresented = false
    @State var isPersonPresented = false
    //家庭树名字
    @ObservedObject var model = FamilyNameModel()
    
    //家庭树的初始值
    let imgsTree = ["tree","second tree","third tree"]
    @State  private var indexTree = 0//默认树
    
   //alert弹出框
    let primaryButton = Alert.Button.default(Text("确认")) {
                print("Yes")
            }
    let secondaryButton = Alert.Button.destructive(Text("取消")) {
        var isCancleName = true
        print("No")
    }
    
    var alert: Alert {
            Alert(title: Text("提示"),
                 message: Text("确认修改家庭树的名字为“\(self.model.FamilyTreeName)”"),
                 dismissButton: .default(Text("OK"))
//                 primaryButton: primaryButton,
//                 secondaryButton: secondaryButton
            )
        }
 
    //coredata
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: FamilyModel.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(keyPath: \FamilyModel.familyId, ascending: true)])
    var familyModels: FetchedResults<FamilyModel>
    
    @State var familyIdWrite = "5526"
    @State var familyMemberCountWrite = "1"
    @State var familyTreeWrite = 0
    
   
    var body: some View {
        
        
        VStack{
            
            //title
            HStack {
                
                Image("three line")
                    .resizable()
                    .frame(width:23,
                           height:23,
                           alignment:.center)
                Spacer()
                Text("Your family tree")
                    .foregroundColor(Color("AccentColor"))
                
                Spacer()
                Button(action: {self.isPersonPresented = true}) {
                    Image("person")
                }
                .fullScreenCover(isPresented: $isPersonPresented, content: {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
                })
                    
            }.padding(15)
            
            Divider()
            
            //家庭ID
            VStack {
                
                HStack() {
                    
                Text("家庭ID：\(familyIdWrite)").font(.system(size: 14))
                Spacer()
                Text("在线成员:").font(.system(size: 14))
                    + Text("\(familyMemberCountWrite)").foregroundColor(Color("AccentColor"))
                    .font(.system(size: 16))
                    
                }.padding(EdgeInsets(top: 0, leading: 7, bottom: 10, trailing: 20))
            
            ZStack {
                
                HomeLandUIView()
                HStack {
                    Image(imgsTree[familyTreeWrite])
                        .animation (.interpolatingSpring(stiffness: 20, damping: 3))
                    
                    //切换家庭树
                    Button(action: {
                    
                        if indexTree == 2{
                            indexTree = 0
                        }else{
                            indexTree = indexTree + 1
                        }
                        
                        familyTreeWrite = indexTree
                        
//                        //给数据库写入数据
//                        let familyModel = FamilyModel(context: self.viewContext)
//                        familyModel.familyId = UUID()
//                        familyModel.familyName = model.FamilyTreeName
//                        familyModel.familyMemberCount = 1
//                        familyModel.familyTree = Int16(familyTreeWrite)
//                        //保存当前数据
//                        try? self.viewContext.save()
                        
                        
                    }) {
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundColor(Color("AccentColor"))
                            Text("切换")
                                .fontWeight(.bold)
                        }.padding(8)
                        .cornerRadius(30.0)
                        .background(Color.white)
                        .shadow(color: Color("AccentColor"), radius: 4, x: 2.0, y: 2.0)
                    }
                    .padding(EdgeInsets(top:240,leading:-100,bottom:0,trailing:0))
                    
                }
                .padding(EdgeInsets(top:0,leading:0,bottom:0,trailing:0))

                
                TextField("FamilyTreeName",
                        text: $model.FamilyTreeName,
                        onCommit: {
                            //给数据库写入数据
                            
                            let familyModel = FamilyModel(context: self.viewContext)
                            familyModel.familyId = UUID()
                            familyModel.familyName = model.FamilyTreeName
                            familyModel.familyMemberCount = 1
                            familyModel.familyTree = Int16(familyTreeWrite)
                            isPresented = true
                            familyModel.familyName = model.FamilyTreeName
                            //保存当前数据
                            try? self.viewContext.save()
                            }
                )
                .font(.system(size: 16))
                .foregroundColor(Color("FamliyTreeNameColor"))
                .frame(width: 90, height: 0)
                .offset(x: -123, y: 118)
                .multilineTextAlignment(.center)
                .alert(isPresented: $isPresented) { () -> Alert in
                            alert
                        }
                Textfield02()
                
                
            }
        }.frame(minWidth: 0/*@END_MENU_TOKEN@*/,  maxWidth: .infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0,  maxHeight: /*@START_MENU_TOKEN@*/.infinity, alignment: .topLeading)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            
    }
}
}

