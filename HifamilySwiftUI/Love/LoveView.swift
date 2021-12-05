//
//  LoveView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/14.
//

import SwiftUI
import LeanCloud



struct NavigationConfigurator : UIViewControllerRepresentable{
    var configure:(UINavigationController) -> Void = { _ in }
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>)->UIViewController{
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>){
    if let nc = uiViewController.navigationController{
    self.configure(nc)
    }
    }
}
struct MyButtonStyle : ButtonStyle{
    func makeBody(configuration: Configuration) -> some View{
        configuration.label
            .frame(width: 62, height: 20, alignment: .center)
            .padding()
            .cornerRadius(32.0)
//            .shadow(color: .gray, radius: 3, x: 0, y: 3)
            .overlay(RoundedRectangle(cornerRadius: 32.0, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 1.4)).shadow(radius: 1)
    }
}
func checkDay(date:Date)->String{
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .short
    return dateFormatter.string(from: date)
}
func checkDiff(date:Date) -> Int {
  // 计算两个日期差，返回相差天数
  let formatter = DateFormatter()
  let calendar = Calendar.current
  formatter.dateFormat = "yyyy-MM-dd"

  // 当天
  let today = Date()
  let startDate = formatter.date(from: formatter.string(from: today))
  
  // 固定日期
  let endDate = formatter.date(from: formatter.string(from: date))
  
  let diff:DateComponents = calendar.dateComponents([.day], from: endDate!, to: startDate!)
  return diff.day!
}

    final class Family: ObservableObject {
        @Published  var person: [String]
        @Published var num: [Int]
        
        init() {
            person = ["爸爸","妈妈","爷爷","奶奶"]
            num = [1,4,5,7]
        }
        func addPeople(person1 : String) {
            person.append(person1)
        }

        func addNum(number: Int) {
            num.append(number)
        }
    }
final class Miss : ObservableObject{
    @Published var MissMember : [LCObject]
    @Published var MissToday : [String]
    @Published var MissHistory : [String]
    @Published var MissByHistory : [String]
    @Published var missCount : [Int]
    @Published var missByCount : [Int]
    @Published var dateTime : [String]
    @Published var Content : [String]
    @Published var member : [String]
    init(){
        MissMember = []
        MissToday  = []
        MissHistory = []
        MissByHistory = []
        dateTime = []
        Content = []
        missCount = []
        missByCount = []
        member = ["我","爸爸","妈妈","爷爷","奶奶","外婆","外公","孙子","孙女","舅舅"]
    }
    func setempty(){
        missCount = []
        missByCount = []
        MissHistory = []
        MissByHistory = []
    }
    func queryMiss(){
        let objectId = LCApplication.default.currentUser?.objectId?.value
        let missQuery = LCQuery(className: "Miss")
        missQuery.whereKey("receiver",.equalTo(objectId!))
        missQuery.whereKey("createdAt",.descending)
        missQuery.limit = 10
        _ = missQuery.find(){ (result) in
            switch result {
                case .success(objects: let miss):
                    self.MissMember = miss
                    for item in miss{
                        print("miss\((item.updatedAt?.dateValue!)!)")
                        if(checkDiff(date: (item.updatedAt?.dateValue!)!)<=1){
                            print("😊😊😊😊😊😊😊😊")
                            print(checkDiff(date: (item.updatedAt?.dateValue!)!))
                            self.MissToday.append((item.receiver?.stringValue!)!)
                            let contentQuery = LCQuery(className: "_User")
                            contentQuery.whereKey("objectId",.equalTo((item.receiver?.stringValue!)!))
                            _ = contentQuery.getFirst(){ (result) in
                            switch result {
                                case .success(object: let todo):
                                    print("miss\((todo.missContent?.stringValue!)!)")
                                    self.Content.append((todo.missContent?.stringValue!)!)
                                case .failure(error: let error):
                                    print(error)
                                }
                            }
                            self.dateTime.append(checkDay(date: (item.updatedAt?.dateValue!)!))
                        }

                    }
                    break
                case .failure(error: let error):
                    print(error)
            }
        }
    }
    func queryToday(){
        
    }
    func queryMissByHistory(){
        let serial = DispatchQueue(label: "serial",attributes: .init(rawValue:0))
        serial.sync {
        
        let objectId = LCApplication.default.currentUser?.objectId?.value
        let missQuery = LCQuery(className: "Miss")
        print("123")
        var set = Set<String>()
        missQuery.whereKey("receiver",.equalTo(objectId!))
        _ = missQuery.find(){ (result) in
            switch result {
                case .success(objects: let miss):
                    do{
                    for item in miss{
                        set.insert((item.sender?.stringValue)!)
                    }
                    for i in set{
                        let selectCount1 = LCQuery(className:"Miss")
                        selectCount1.whereKey("receiver",.equalTo(objectId!))
                        selectCount1.whereKey("sender", .equalTo("\(i)"))
                        let count = selectCount1.count().intValue
                        self.missByCount.append(count)
                        let selectQuery1 = LCQuery(className: "_User")
                        print("\(i)")
                        selectQuery1.whereKey("objectId", .equalTo("\(i)"))
                    
                        _ = selectQuery1.getFirst { result in
                            switch result {
                            case .success(object: let todo):
                                print("hj")
                                let title = todo.familyPosition?.intValue!
                                self.MissByHistory.append(self.member[title!])
                                print("\(self.member[title!])")
                            case .failure(error: let error):
                                print(error)
                            }
                        }
                    }
                    }
                    break
                case .failure(error: let error):
                    print(error)
                }
        }
        }
    }
    func queryMissHistory(){
//        let serial = DispatchQueue(label: "serial",attributes: .init(rawValue:0))
//
        let objectId = LCApplication.default.currentUser?.objectId?.value
        let missQuery = LCQuery(className: "Miss")
        var set = Set<String>()
        missQuery.whereKey("sender",.equalTo(objectId!))
        _ = missQuery.find(){ (result) in
            switch result {
                case .success(objects: let miss):
                    do{
                    for item in miss{
                        if(set.contains((item.receiver?.stringValue)!)){
                            break
                        }
                        else{
                            let selectCount = LCQuery(className:"Miss")
                            selectCount.whereKey("sender",.equalTo(objectId!))
                            selectCount.whereKey("receiver", .equalTo("\(( item.receiver?.stringValue)!)"))
                            let count = selectCount.count().intValue
                            self.missCount.append(count)
                            let selectQuery1 = LCQuery(className: "_User")
                            selectQuery1.whereKey("objectId",  .equalTo("\(( item.receiver?.stringValue)!)"))
                            _ = selectQuery1.getFirst { result in
                                switch result {
                                case .success(object: let todo):
                                    print("hj")
                                    let title = todo.familyPosition?.intValue!
                                    self.MissHistory.append(self.member[title!])
                                    print("\(self.member[title!])")
                                case .failure(error: let error):
                                    print(error)
                                }
                            }
                            set.insert((item.receiver?.stringValue)!)
                        }
                    }
                    }
                    break
                case .failure(error: let error):
                    print(error)
                }
            
        }
        
    }
}






    final class FamilyTree: ObservableObject {
     
        @Published var familyTreeId : LCNumber
        @Published var missNum : Int
        @Published var familyMember : [LCObject]
        @Published var missContent : String
        
        init(){
            familyTreeId = 0
            familyMember = []
            missNum = 0
            missContent = ""
        }
        func updateTreeId(treeId : LCNumber){
            self.familyTreeId = treeId
        }
        func addFamilyMember( person : [LCObject]){
            familyMember = person
        }
        func queryUser(){
            let sessionToken = LCApplication.default.currentUser?.sessionToken?.value
            let userQuery = LCQuery(className: "_User")
            userQuery.whereKey("sessionToken",.equalTo(sessionToken!))
            _ = userQuery.getFirst(){
                (result) in
                switch result {
                case .success(object: let user):
                    self.missNum = (user.missNum?.intValue!)!
                    self.familyTreeId = user.familyTreeId as! LCNumber
                    self.missContent = (user.missContent?.stringValue)!
                    print("TreeId\(self.familyTreeId)")
                    let query = LCQuery(className: "_User")
                    query.whereKey("familyTreeId",.equalTo(self.familyTreeId) )
                    query.whereKey("sessionToken",.notEqualTo(sessionToken!))
                    _ = query.find { result in
                        switch result {
                        case .success(objects: let user):
                            self.addFamilyMember(person: user)
                            print("test\(user)")
                            break
                        case .failure(error: let error):
                            print(error)
                        }
                    }
                    print(user)
                case .failure(error: let error):
                    // session token 无效
                    print(error)
                }
            }
        }
    }
func queryUser(familyTree:FamilyTree){
    
}
struct LoveView: View {
    
    var items : [GridItem] = [
        GridItem(GridItem.Size.flexible(),spacing: 1),
        GridItem(GridItem.Size.flexible(),spacing: 1),
        GridItem(GridItem.Size.flexible(),spacing: 1)
    ]
    @ObservedObject var familyTree:FamilyTree
    @ObservedObject var family:Family = Family()
    @ObservedObject var miss:Miss
    let imgsLove = ["big love","Like","love2"]
    @State var who = -1
    @State var member = ["我","爸爸","妈妈","爷爷","奶奶","外婆","外公","孙子","孙女","舅舅"]
    @State var isSelected = false
    @State  private var indexLove = 2
    @State private var presenting = false
    @State private var presenting_1 = false
    @State private var present = false
    @State var missSetting : Bool = false
    @State var loveHistory : Bool = false
    @State  var num = 5
    @State var content = ""
    var body: some View {
                VStack{
                HStack {
                    Image("three line")
                        .resizable()
                        .frame(width:23,
                               height:23,
                               alignment:.center)
                    Spacer()
                    Text("Miss family")
                        .foregroundColor(Color("AccentColor"))
                    
                    Spacer()
                    Image("person")
                        .resizable()
                        .frame(width:23,
                               height:23,
                               alignment:.center)
                }.padding()
                    Divider()
            ZStack {
            
                ScrollView(.vertical, showsIndicators: false)
                {
                HStack{
                    VStack(alignment: .leading){
                        Text("选择思念对象")   .font(.system(size: 20))
                    }
                    Spacer()
                }.padding()
                    VStack{
                    LazyVGrid(columns: items, content: {
//                        ForEach(0..<family.person.count){
                        ForEach(0..<familyTree.familyMember.count,id: \.self){
                            index in
                            Button(action: {
                                if(isSelected == false ){
                                    if( who == -1 ){
                                        isSelected = true
                                        who = index
//                                                        truePerson[0] = 1
                                    }
                                }else {
                                    if(who == index){
                                        isSelected = false
                                        who = -1
                                    }else{
                                        who = index
                                    }
                                    
                                }
                                                }){
                                
                                VStack {
//                                    Text(family.person[index])
                                    Text(member[(familyTree.familyMember[index].familyPosition?.intValue!)!]).debugPrint("\(familyTree.familyMember.count)")
                                                            .frame(width: 62, height: 20, alignment: .center)
                                                            .cornerRadius(32)
                                        .foregroundColor(who == index ? .white : grayColor )
                                }
                            
                                        }
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                            .animation(.easeInOut,value:nil)
//                                                .buttonStyle(MyButtonStyle())
                       
                                                .background( who == index ? LinearGradient(gradient: Gradient(colors: [Color.init(red : 255/255,green: 144/255,blue: 13/255), Color.init(red: 255/255, green: 169/255, blue: 54/255)]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(gradient: Gradient(colors: [Color.white, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)).cornerRadius(15)
                            .shadow(color: Color("AccentColor"), radius: 3, x: 0.5, y: 0.5)
//                            .overlay(RoundedRectangle(cornerRadius: 15.0, style: .continuous).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 2.0))
                                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                        }
                    })
                    }.frame(width:390)
                
                HStack{
                    VStack(alignment: .leading, spacing: nil, content: {
                        Text("点击爱心进行思念")   .font(.system(size: 20))
                    }).padding()
                    Spacer()
                    
                }
                
                HStack{
                    if(isSelected){
                        if(familyTree.missNum>0){
                    Button(action: {
                        
                        familyTree.missNum=familyTree.missNum-1;
                        do {
                            let objectId = LCApplication.default.currentUser?.objectId?.value
                            let todo = LCObject(className: "_User",objectId: objectId!)
                            try todo.set("missNum", value: familyTree.missNum)
                            todo.save { (result) in
                                switch result {
                                case .success:
                                    do{
                                    let insertMiss = LCObject(className:"Miss")
                                     try insertMiss.set("familyId",value:familyTree.familyTreeId)
                                        try insertMiss.set("sender", value: objectId!)
                                        try insertMiss.set("receiver",value: familyTree.familyMember[who].objectId!)
                                        insertMiss.save{(result) in
                                            switch result {
                                            case .success:
                                                    break;
                                            case .failure(error:  let error):
                                                print(error)
                                            }
                                        }
                                    }catch{
                                        print(error)
                                    }
                                    break
                                case .failure(error: let error):
                                    print(error)
                                    }
                            }
                                } catch {
                                    print(error)
                                }
                            
                        self.present.toggle()
                    }){
                        HStack {
                            Image(imgsLove[indexLove])
                           
                            .animation(.interpolatingSpring(stiffness: 50, damping: 3))
    //                        .padding()
                                .scaledToFit()
                        }     .frame(width: 400, height: 220, alignment: .center)
                    }
                    .alert(isPresented: $present, content: {
                        Alert(title: Text("向\(member[(familyTree.familyMember[who].familyPosition?.intValue!)!])寄出你的思念成功，消耗一张思念卷，你还剩下\(familyTree.missNum)思念卷"))
                    })
                
                    }
                    else{
                        Button(action: {
                            
                            self.present.toggle()
                        }){
                            HStack {
                                Image(imgsLove[indexLove])
                       
                                .animation(.interpolatingSpring(stiffness: 50, damping: 3))
                                
                                    .padding()
                            }     .frame(width: 400, height: 220, alignment: .center)
                        }
                        .alert(isPresented: $present, content: {
                            Alert(title: Text("寄出你的思念失败，请领取思念卷"))
                        })
                    }
                    }else{
                        Button(action: {
                            
                            self.present.toggle()
                        }){
                            HStack{
                                Image(imgsLove[indexLove])

                                    .animation(.spring(dampingFraction: 0.1))
//                            .animation(.default)
//                           .animation(.interpolatingSpring(stiffness: 50, damping: 3))
                            .padding()
                            }
                            .frame(width: 400, height: 220, alignment: .center)
//                            .border(Color.black)
                        }
                        .alert(isPresented: $present, content: {
                            Alert(title: Text("没有思念对象哦！请选择思念对象"))
                        })
                    }
                }
                HStack{
                    VStack{
//                        if(presenting_1 == false){
                        Button(action: {
                            let sessionToken = LCApplication.default.currentUser?.sessionToken?.value
                            let userQuery = LCQuery(className: "_User")
                            userQuery.whereKey("sessionToken",.equalTo(sessionToken!))
                            _ = userQuery.getFirst(){
                                (result) in
                                switch result {
                                case .success(object: let user):
                                    let updateT = user.missUpdate?.dateValue
                                    var k = 0
                                    if((updateT) != nil){
                                     k = checkDiff(date: updateT!)
                                    }
                                    if(k>=1||(updateT)==nil){
                                        familyTree.missNum = familyTree.missNum + 3
                                        do {
                                            let objectId = LCApplication.default.currentUser?.objectId?.value
                                            let todo = LCObject(className: "_User",objectId: objectId!)
                                            try todo.set("missNum", value: familyTree.missNum)
                                            try todo.set("missUpdate",value: Date())
                                            todo.save { result in
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
                                        content = "今日领取3张思念券成功"
                                    }else{
                                        content = "请明天再领取思念卷"
                                    }
                                    print(user)
                                case .failure(error: let error):
                                    // session token 无效
                                    print(error)
                                }
                            }
                            
//
                            self.presenting.toggle()
//                            presenting_1 = true
//
                        })
                        {
                            HStack{
                                VStack {
                                    Image("second tag")
                                        .foregroundColor(Color("AccentColor"))
                                }
                                .frame(width: 40, height: 40, alignment: .center)
                                .cornerRadius(20.0)
                                .background(Color.white)
                                .overlay(Capsule(style: .continuous).stroke( lineWidth: 1)
                                )
                                Text("思念卷x\(familyTree.missNum)")
                                    .foregroundColor(.black)
                                
                                
                            }
                            Spacer()
                        }.padding(EdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 10))
                        .alert(isPresented: $presenting, content: {
                            Alert(title: Text("\(content)"))
                        })
//                        }
//                        else{
//                        Button(action: {
//                            self.presenting.toggle()
//
//                        })
//                        {
//                            HStack{
//                                VStack {
//                                    Image("second tag")
//                                        .foregroundColor(Color("AccentColor"))
//                                }
//                                .frame(width: 40, height: 40, alignment: .center)
//                                .cornerRadius(20.0)
//                                .background(Color.white)
//                                .overlay(Capsule(style: .continuous).stroke( lineWidth: 1)
//                                )
//                                Text("思念卷x\(familyTree.missNum)")
//                                    .foregroundColor(.black)
//
//
//                            }
//                            Spacer()
//                        }.padding(EdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 10))
//                        .alert(isPresented: $presenting, content: {
//                            Alert(title: Text("今日已经领取5张思念券，请明天再来领取"))
//                        })
//                        }
                    
                        VStack{
                            Button(action: {
                                if indexLove == 2{
                                    indexLove = 0
                                }else{
                                    indexLove = indexLove + 1
                                }
                            })
                            {
                                HStack{
                                    VStack {
                                        Image("second loop arrow")
                                            .foregroundColor(Color("AccentColor"))
                                    }.padding(8)
                                    .frame(width: 40, height: 40, alignment: .center)
                                    .cornerRadius(20.0)
                                    .background(Color.white)
                                    .overlay(Capsule(style: .continuous).stroke( lineWidth: 1)
                                    )
                                    VStack{
                                        Text("切换爱心")
                                            .foregroundColor(.black)
                                    }
                                }
                                Spacer()
                            }.padding(EdgeInsets(top: 5, leading: 20, bottom: 30, trailing: 10))
                           
                        }
                    }
                    
                }
                VStack{
                    HStack{
                              Text("我收到的今日思念")
                                  .font(.system(size: 20))
                              Spacer()
                          }.padding(EdgeInsets(top: 10, leading: 20, bottom: 5, trailing: 10))
                    if(miss.Content.count==0){
                        HStack{
                                             
                                                Text("今日还没有人发送给你思念哦")
                                                   .foregroundColor(.gray)
                                                   .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 10))
                                               
                                           }
                                           Divider().padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
                    }else{
                        ForEach(0..<miss.Content.count,id: \.self){ index in
                            HStack{
                                Text(miss.Content[index])
                                                        .foregroundColor(.gray)
                                                        .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 10))
                                                    Image("new")
                                                    Spacer()
                                Text("\(miss.dateTime[index])").foregroundColor(.gray)
                                                        .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                                                }
                                                Divider().padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
                        }
                    }
//                    HStack{
//                        Text("我收到的今日思念")
//                            .font(.system(size: 20))
//                        Spacer()
//                    }.padding(EdgeInsets(top: 10, leading: 20, bottom: 5, trailing: 10))
//                    HStack{
//                        Text("爷爷向你寄送了两份思念")
//                            .foregroundColor(.gray)
//                            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 10))
//                        Image("new")
//                        Spacer()
//                        Text("AM09:41").foregroundColor(.gray)
//                            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
//                    }
//                    Divider().padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
//                    HStack{
//                        Text("妈妈亲了你一下，送了一份思念")
//                            .foregroundColor(.gray)
//                            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 10))
//                        Spacer()
//                        Text("AM08:45").foregroundColor(.gray)
//                            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
//                    }
//                    Divider().padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
                    
                }
                HStack{
                    VStack{
                        Button(action: {
                            self.loveHistory=true
                            
                        })
                        {
                            HStack{
                                VStack {
                                    Image("eye")
                                        .foregroundColor(Color("AccentColor"))
                                }
                                .frame(width: 40, height: 40, alignment: .center)
                                .cornerRadius(20.0)
                                .background(Color.white)
                                .overlay(Capsule(style: .continuous).stroke( lineWidth: 1)
                                )
                                Text("查看历史思念")
                                    .foregroundColor(.black)
                                
                            }
                            Spacer()
                        }.padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 10))
                        VStack{
                            Button(action: {
                                self.missSetting = true
                            })
                            {
                                HStack{
                                    VStack {
                                        Image("setting")
                                            .foregroundColor(Color("AccentColor"))
                                    }.padding(8)
                                    .frame(width: 40, height: 40, alignment: .center)
                                    .cornerRadius(20.0)
                                    .background(Color.white)
                                    .overlay(Capsule(style: .continuous).stroke( lineWidth: 1)
                                    )
                                    VStack{
                                        Text("设置思念语句")
                                            .foregroundColor(.black)
                                    }
                                }
                                Spacer()
                            }.padding(EdgeInsets(top: 5, leading: 20, bottom: 30, trailing: 10))
                           
                        }
                    }
                }
                }.frame(minWidth: 0/*@END_MENU_TOKEN@*/,  maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,  maxHeight: /*@START_MENU_TOKEN@*/.infinity, alignment: .topLeading)
                if(missSetting){
                    ZStack{
                        Rectangle().fill(Color.gray).opacity(0.5)
                    VStack{
                        MissView( missSetting : $missSetting,familyTree:familyTree)
                            .contentShape(Rectangle())
                    }
                    }
                }
                
                if(loveHistory){
                    ZStack{
                        Rectangle().fill(Color.gray).opacity(0.5)
                    VStack{
                        LoveHistoryView( miss: miss, loveHistory : $loveHistory)
                            .contentShape(Rectangle())
                            .onAppear(perform: {
                            miss.setempty()
                            miss.queryMissHistory()
                            miss.queryMissByHistory()
                        })
                    }
                    }
                }
            }
        }
    }
}


struct LoveView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoveView(familyTree: FamilyTree(),miss:Miss())
          
        }
    }
}
