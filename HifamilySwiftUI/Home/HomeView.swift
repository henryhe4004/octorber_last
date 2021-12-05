//
//  HomeView.swift
//  HifamilySwiftUI
//
//  Created爱了by 游 on 2021/9/14.
//

//这里改了
import SwiftUI
import CoreData
import LeanCloud
import Combine
//import EFQRCode
import YPImagePicker
import Kingfisher


//首先通过扩展 UIApplication隐藏键盘
extension UIApplication{
    func endEditing(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

class FamilyTreeData: ObservableObject {
    @Published var isHaveTree = false
    @Published var indexTree = 0
    @Published var familyIdWrite = 0
    @Published var familyMemberCountWrite = 1
    @Published var familyTreeWrite = 0
    @Published var familyTreeName = "无名树"
    @Published var treeObjectId = ""
}


class LandmarkTest:Identifiable{
    // 唯一ID
    var id: Int
    // 图片地址
    var imageurl: String
    var size : CGSize
    var offsetx : CGFloat
    var offsety :CGFloat
    var status : Bool
    init(size:CGSize,imageurl: String,id: Int,status:Bool,offsetx : CGFloat,offsety:CGFloat) {

        self.offsetx = offsetx
        self.offsety = offsety
        self.id = id;
        self.imageurl = imageurl;
        self.status = status
        self.size = size
    }
}
class DraftMarkModel:ObservableObject{
    @Published var landmarkTest : [LandmarkTest]
    init() {
        self.landmarkTest = [LandmarkTest(size: CGSize(width: 10, height: 0),  imageurl: "father", id: 21, status: false,offsetx: 0, offsety: 0 ),
                             LandmarkTest(size: CGSize(width: 10, height: 0),  imageurl: "father", id: 21, status: false, offsetx: 20, offsety: 20 )]
                             
          
    }
}
struct AvatarList{
    var url :String
    let id : Int
    var username : String
    
}
class AvatarListModel:ObservableObject{
    @Published var avatarList = [AvatarList]()
    @Published var arrayCount = 0
    
}
struct HomeView: View {
    
    @StateObject var user = InformationUser()
    @StateObject var treeData = FamilyTreeData()
    @StateObject var draftMarkModel = DraftMarkModel()
   
    //isHaveTree true 为创建者，false为加入者
    //不变
    @State var isPresented = false
    @State var isPersonPresented = false
    @State var familyMemberCountWrite = 1
    //家庭树的初始值
    var imgsTree = ["tree","second tree","third tree"]
    

    
    //左边菜单栏
    @State var showLeftMenu = false
    @State var username = ""
    @State var status = 0
    @State var avatar = ""
   
    
    @Binding var isLogin : Bool
    @Binding var isFirstLogin : LCBool
    @Binding var isPressed1 : Bool
    @Binding var objectId:LCString
    
    @State var offset: CGSize = .zero
    @GestureState var isLongPressed = false


  
    @StateObject  var avatarListModel = AvatarListModel()
    var body: some View {
        
        
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 && treeData.isHaveTree{
                        withAnimation {
                            treeData.familyMemberCountWrite = familyMemberCountWrite
                                    self.showLeftMenu = false
                                }
                            }
                    else if $0.translation.width > 100 && treeData.isHaveTree{
                        withAnimation {
                                    self.showLeftMenu = true
                        }
                    }
            }
        return GeometryReader { geometry in
    
        ZStack(alignment: .leading) {
            VStack{
                //title
                Title(isPersonPresented: $isPersonPresented, showLeftMenu : $showLeftMenu,isLogin: $isLogin,isFirstLogin: $isFirstLogin,isPressed1: $isPressed1,objectId: $objectId, status: $status, treeData: treeData, avatarListModel: avatarListModel)
                Divider()
                //title 下面部分
                TitleDown(avatarListModel: avatarListModel, treeData: treeData, username: $username, avatar: $avatar)
//                DrapView( isLongPressed1: isLongPressed, draftMarkModel: draftMarkModel)

                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .offset(x: self.showLeftMenu  ? 1 * geometry.size.width/2: 0)
            .disabled(self.showLeftMenu  ? true : false)
            .transition(.move(edge: .leading))
            
            
            if self.showLeftMenu{
                LeftMenuView(familyMemberCountWrite:$familyMemberCountWrite )
                    .offset(y: 30)
                    .frame(width: 1 * geometry.size.width/2)
                    .transition(.move(edge: .leading))
            }
        }
        .gesture(drag)
        .onAppear(){
            let objectId = (LCApplication.default.currentUser?.objectId)!
            self.user.objectId = objectId
            let query = LCQuery(className: "_User")
            let _ = query.get(user.objectId) { (result) in
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
                                        let todo = LCObject(className: "_User", objectId: user.objectId)
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
                                            let todo = LCObject(className: "_User", objectId: user.objectId)
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

    }
}
        
        //拖拽部分做不出来
        
        struct DrapView: View{

            @GestureState var isLongPressed1 = false
            
            @ObservedObject var draftMarkModel = DraftMarkModel()
            
            @GestureState private var dragOffset = CGSize.zero
            var body: some View{
                
           
                VStack(alignment: .leading){
                    // 滚动组件; 数据可能为空需要加！强制不为空
                    ScrollView(.horizontal,  showsIndicators: false){
                            // 排列元素的间隔： spacning
                        HStack(spacing: 10){
                            ForEach(Array(draftMarkModel.landmarkTest.enumerated()), id: \.1.id) { (index,item) in
                                        VStack(alignment: .leading){
                                            Image(item.imageurl)
                                                .resizable() // 拉伸图片
                                                .frame(width: 80, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                                .cornerRadius(50)
                                                .offset(x:item.size.width + item.offsetx,y: item.size.height+item.offsety)
                                                .gesture(DragGesture()
                                                            .updating($dragOffset, body: { (value, state, transaction) in
                                                                                    state = value.translation
                                                                                })
                                                           
                                                            .onChanged { (value) in
                                                                print(value.startLocation, value.location, value.translation)
                                                                item.status = true
                                                                item.offsetx = value.location.x
                                                                item.offsety = value.location.y
                                                                
                                                        }
                                                        .onEnded { (value) in
                                                                        item.status = false
                                                            
                                                        }
                                                     
        
                                            )
                                            
                                            .scaleEffect(item.status ? 1.2 : 1)
                                            .animation(.spring())
                                        }
                                    }
                                }
                            }
                        }
                .padding(.bottom,10)

            }
        }

    struct TitleDown: View {
        @ObservedObject var avatarListModel : AvatarListModel
        @StateObject var treeData = FamilyTreeData()
        @Binding var username : String
        @Binding var avatar : String
        
        var imgsTree = ["tree","second tree","third tree"]
        var body: some View {
            GeometryReader { geo in
            VStack {
                
                HStack() {
                    
                    Text("家庭ID：\(treeData.familyIdWrite)").font(.system(size: 14))
                    Spacer()
                    Text("总共成员:").font(.system(size: 14))
                        + Text("\(treeData.familyMemberCountWrite)").foregroundColor(Color("AccentColor"))
                        .font(.system(size: 16))
                    
                }.padding(EdgeInsets(top: 0, leading: 7, bottom: 10, trailing: 20))
                
                ZStack {
                    
                    HomeLandUIView()
                        .offset(x:-3)
                    HStack {
                        HStack {
                            Image(imgsTree[treeData.indexTree])
                                .animation(.interpolatingSpring(stiffness: 20, damping: 5))
                                .scaledToFit()
                                .offset(y: 20)
                        }
                        .frame(width: 300, height: 220, alignment: .center)
                        
                        //切换家庭树
                        Button(action: {
                            if treeData.indexTree == 2{
                                withAnimation{
                                    treeData.indexTree = 0
                                }
                                
                            }else{
                                withAnimation{
                                    treeData.indexTree = treeData.indexTree + 1
                                }
                                
                            }
                            treeData.familyTreeWrite = treeData.indexTree
                            if(treeData.treeObjectId != ""){
                            do {
                                let familyTree = LCObject(className: "familyTree", objectId: treeData.treeObjectId)
                                try familyTree.set("indexTree", value: treeData.familyTreeWrite)
                                familyTree.save { (result) in
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
                        }) {
                            VStack {
                                CutButton()
                            }
                            
                        }
                        .padding(EdgeInsets(top:280,leading:-80,bottom:0,trailing:0))
                        if(!treeData.isHaveTree){
                            AddFamilyButton(username: $username, avatar: $avatar)
                        }
                        
                    }
                    .padding(EdgeInsets(top:0,leading:0,bottom:0,trailing:0))
                    //家庭树名字
                    //家庭树改名字在个人中心处改
                    HStack {
                        Text("\(treeData.familyTreeName)")
                        .font(.system(size: 16))
                        .foregroundColor(Color("FamliyTreeNameColor"))
                        .frame(width: 90, height: 0)
                        .offset(x: -123, y: 143)
                        .multilineTextAlignment(.center)
                      
                    }

                    
                    if(avatarListModel.arrayCount >= 1){
                        VStack(spacing: 10) {
                            HStack{
                                KFImage.url(URL(string:avatarListModel.avatarList[0].url))
                                    .loadDiskFileSynchronously()
                                    .cacheOriginalImage()
                                    .resizable()
                                    .frame(width: 85, height: 85)
                                    .cornerRadius(80)
                                    .overlay(
                                            RoundedRectangle(cornerRadius: 80, style: .continuous)
                                                .stroke(Color.init(red: 255/255, green: 150/255, blue: 40/255), lineWidth: 8)
                                                        )
                                    .offset(x: -20, y: CGFloat(-220))
                                    .contextMenu{
                                        Button{
                                            
                                        } label:{
                                            Text("用户名：\(avatarListModel.avatarList[0].username)")
                                        }
                                    }
                                
                                }
                           
                            }
                    }
                    if(avatarListModel.arrayCount >= 2){
                        HStack{
                            KFImage.url(URL(string:avatarListModel.avatarList[1].url))
                            .loadDiskFileSynchronously()
                            .cacheMemoryOnly()
                            .resizable()
                            .frame(width: 80, height: 80)
                            .cornerRadius(80)
                                .overlay(
                                        RoundedRectangle(cornerRadius: 80, style: .continuous)
                                            .stroke(Color.init(red: 255/255, green: 150/255, blue: 40/255), lineWidth: 7)
                                                    )

                            .offset(x: 90, y: CGFloat(-180))
                                .contextMenu{
                                    Button(action:{
                                    }){
                                        Text("用户名：\(avatarListModel.avatarList[1].username)")
                                    }
                                }                            }
                        }
                    if(avatarListModel.arrayCount >= 3){
                            HStack{
                                KFImage.url(URL(string:avatarListModel.avatarList[2].url))
                                    .loadDiskFileSynchronously()
                                     .cacheOriginalImage()
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(70)
                                    .overlay(
                                            RoundedRectangle(cornerRadius: 70, style: .continuous)
                                                .stroke(Color.init(red: 255/255, green: 150/255, blue: 40/255), lineWidth: 8)
                                                        )
                                    .offset(x: -90, y: CGFloat(-110))
                                    .contextMenu{
                                        Button(action:{
                                        }){
                                            Text("用户名：\(avatarListModel.avatarList[2].username)")
                                        }
                                    }
                                }
                    }
                    if(avatarListModel.arrayCount >= 4){
                            HStack{
                                KFImage.url(URL(string:avatarListModel.avatarList[3].url))
                                    .loadDiskFileSynchronously()
                                     .cacheOriginalImage()
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(70)
                                    .overlay(
                                            RoundedRectangle(cornerRadius: 70, style: .continuous)
                                                .stroke(Color.init(red: 255/255, green: 150/255, blue: 40/255), lineWidth: 8)
                                                        )
                                    .offset(x: 60, y: CGFloat(-80))
                                    .contextMenu{
                                        Button(action:{
                                        }){
                                            Text("用户名：\(avatarListModel.avatarList[3].username)")
                                        }
                                    }
                                }
                    }
                    if(avatarListModel.arrayCount >= 5){
                            HStack{
                                KFImage.url(URL(string:avatarListModel.avatarList[4].url))
                                    .loadDiskFileSynchronously()
                                     .cacheOriginalImage()
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(50)
                                    .overlay(
                                            RoundedRectangle(cornerRadius: 50, style: .continuous)
                                                .stroke(Color.init(red: 255/255, green: 150/255, blue: 40/255), lineWidth: 8)
                                                        )
                                    .offset(x: -80, y: CGFloat(-10))
                                    .contextMenu{
                                        Button(action:{
                                        }){
                                            Text("用户名：\(avatarListModel.avatarList[4].username)")
                                        }
                                    }
                                }
                    }
                    if(avatarListModel.arrayCount >= 6){
                            HStack{
                                KFImage.url(URL(string:avatarListModel.avatarList[5].url))
                                    .loadDiskFileSynchronously()
                                     .cacheOriginalImage()
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(50)
                                    .overlay(
                                            RoundedRectangle(cornerRadius: 50, style: .continuous)
                                                .stroke(Color.init(red: 255/255, green: 150/255, blue: 40/255), lineWidth: 8)
                                                        )
                                    .offset(x: 80, y: CGFloat(0))
                                    .contextMenu{
                                        Button(action:{
                                        }){
                                            Text("用户名：\(avatarListModel.avatarList[5].username)")
                                        }
                                    }
                                }
                    }
                    
                }
            }
            .animation(.interpolatingSpring(stiffness: 20, damping: 5))
            }
        }
    }
}

struct CutButton: View {
    var body: some View {
        HStack {
            Image(systemName: "arrow.triangle.2.circlepath")
                .foregroundColor(Color("AccentColor"))
                .frame(width: 23, height: 23, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Text("切换")
                .fontWeight(.bold)
        }.padding(8)
        .background(Color.white)
        .cornerRadius(13)
        .shadow(color: Color("AccentColor"), radius: 3, x: 2, y: 2.0)
    }
}



struct AddFamilyButton: View {
    @State private var isPresented = false
    @State private var familyId = ""
    @State private var familyIDAlert = ""
    @State private var showingAlert = false
    @Binding var username : String
    @Binding var avatar : String
  
    var modalView: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                Text("输入想加入的家庭ID")
                    .font(.title3)
                    .foregroundColor(Color.gray)
                    .padding(.bottom,10)
                CustomTextField(text: $familyId,isFirstResponder: true)
                    .padding(.horizontal,20)
                    .padding(.top,8)
                    .padding(.bottom,8)
                    .background(Color("EventMarkersBackground"))
                           .cornerRadius(20)
                           .shadow(color: .gray, radius: 2)
                    .frame(width: 300, height: 45, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .font(/*@START_MENU_TOKEN@*/.title3/*@END_MENU_TOKEN@*/)
                
           
                Button(action: {
                        familyIDAlert = familyId
                        self.showingAlert = true
                    //发送申请，查看是否有这个家庭树ID
                    if(familyId != ""){
                        let query = LCQuery(className: "familyTree")
                        query.whereKey("familyId", .equalTo(Int(familyId)!))
                        _ = query.find { result in
                            switch result {
                            case .success(objects: _):
                                let InvitationUser = LCObject(className: "InvitationUser")
                                InvitationUser.treeId = Int(familyIDAlert)
                                InvitationUser.userId = LCApplication.default.currentUser?.id
                                InvitationUser.username = username
                                InvitationUser.url = avatar
                                
                                _ =  InvitationUser.save { result in
                                      switch result {
                                      case .success:
                                          // 成功保存之后，执行其他逻辑
                                          break
                                      case .failure(error: let error):
                                          // 异常处理
                                          print(error)
                                      }
                                  }
                                print("right")
                                break
                            case .failure(error: let error):
                                familyIDAlert = ""
                                print(error)
                            }
                        }
                    }
                    
                    familyId = ""
                }) {
                    Text("发送申请")
                }
                .background(Color("AccentColor"))
                .frame(width:UIScreen.main.bounds.width/2 - 80,height:40)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(30)
                .alert(isPresented:$showingAlert) {
                    familyIDAlert != "" ? Alert(title: Text("发送申请成功"), message: Text("已向\(familyIDAlert)家庭发送申请")) : Alert(title: Text("发送申请失败"), message: Text("请输入正确的家庭ID"))
                        }
                .padding(.top,20)
                
                Spacer()
            }
            .padding(.top,45)
            .frame(width: geo.size.width, height: geo.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .onTapGesture {
                        print("收回键盘")
                        UIApplication.shared.endEditing()
        }
            }
        }
        
    }
    
    var body: some View {
        Button(action: {
            self.isPresented = true
        }) {
            VStack {
                HStack {
                    Image(systemName: "plus.circle")
                        .foregroundColor(Color("AccentColor"))
                        .frame(width: 23, height: 23, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Text("加入")
                        .fontWeight(.bold)
                }.padding(8)
                .background(Color.white)
                .cornerRadius(13)
                .shadow(color: Color("AccentColor"), radius: 3, x: 2, y: 2.0)
            }
        }
        .padding(EdgeInsets(top:400,leading:-70,bottom:0,trailing:0))
        .sheet(isPresented: $isPresented, content: {
                    self.modalView
                })
        
    }
}

//让textfield 成为第一响应者，即进入就聚焦
struct CustomTextField: UIViewRepresentable {

    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var text: String
        var didBecomeFirstResponder = false

        init(text: Binding<String>) {
            _text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }

    }

    @Binding var text: String
    var isFirstResponder: Bool = false

    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        return textField
    }

    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(text: $text)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}

struct Title: View {
    @Binding var isPersonPresented: Bool
    @Binding var showLeftMenu : Bool
    
    @Binding var isLogin : Bool
    @Binding var isFirstLogin : LCBool
    @Binding var isPressed1 : Bool
    @Binding var objectId:LCString
//    @Binding var familyTreeName:String
    @Binding var status : Int
//    @StateObject var treeData = FamilyTreeData()
    
    @ObservedObject var treeData : FamilyTreeData
    @ObservedObject var avatarListModel : AvatarListModel
    
    var body: some View {
        HStack {
            Image("three line")
                .resizable()
                .frame(width:23,
                       height:23,
                       alignment:.center)
            
                .onTapGesture {
                    if(treeData.isHaveTree){
                        withAnimation {
                        self.showLeftMenu  = true
                        }
                    }
                    
                }
            Spacer()
            Text("Your family tree")
                .foregroundColor(Color("AccentColor"))
            
            Spacer()
            Button(action: {
                    self.isPersonPresented = true
                
            }) {
                Image("person")
            }
            .fullScreenCover(isPresented: $isPersonPresented, content: {
                InformUIView(treeData: treeData, isLogin: $isLogin,isFirstLogin: $isFirstLogin,isPressed1: $isPressed1,objectId: $objectId, avatarListModel: avatarListModel)
            })
            
        }.padding(15)
        
    }
}

}

struct Photo: View {
    @Binding var url: String
    var body: some View {
        HStack{
            KFImage.url(URL(string:url))
                .loadDiskFileSynchronously()
                .cacheOriginalImage()
                .resizable()
        }
    }
   
    
}
