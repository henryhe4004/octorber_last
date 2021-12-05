//
//  EditTimelineView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/23.
//

import SwiftUI
import LeanCloud
import HalfModal
import HalfASheet


var imageItems : [GridItem] = [
    GridItem(GridItem.Size.flexible(),spacing:1),
    GridItem(GridItem.Size.flexible(),spacing:1),
    GridItem(GridItem.Size.flexible(),spacing:1)
]
final class TimeLineImage: ObservableObject {
    @Published  var img: [UIImage]
//    @Published var date: [Int]
    @Published var imgUrl : [String]
    @Published var imgObjectId : [String]
    init() {
        img = []
        imgUrl = []
        imgObjectId = []
    }
    func addImage(img1 : UIImage){
        img.append(img1)
    }
    func addImageUrl(img1 : String){
        imgUrl.append(img1)
    }
    func addImageObjectId(objectId : String){
        imgUrl.append(objectId)
    }
    func deleteImage(img1 : Int){
        img.remove(at: img1)
    }
    func deleteImageUrl(img1 : Int){
        imgUrl.remove(at: img1)
    }
    func deleteImageObjectId(objectId : Int){
        imgUrl.remove(at: objectId)
    }
}
struct EditTimelineView: View {
//    @EnvironmentObject var action: NavigationAction
    
   
    @State var isSelected = -1;
    @State var isPresented = false
    @State var showingAlert = false
    @ObservedObject var timeLineImage : TimeLineImage = TimeLineImage()
    @State private var date = Date()
    @State var descriptionEventName = "妍妍"
    @State var thingContent = "未知"
    @State var thingType = "未知"
    @State var isReminder = true
    @State var thingIcon = 0
    
    @Binding var isPushed : Bool
   
    

    var body: some View {
        
        ZStack {
            VStack {

                ScrollView(.vertical){
                    Spacer()
                    HStack {
                        HStack {
                            Text("事件日期：")
                                .font(.system(size: 20))
                                .foregroundColor(Color("EditTimerColor"))
                            DatePicker(selection: $date, displayedComponents: .date) {
                            }

                        }
                        .padding(EdgeInsets(top: 20, leading: 33, bottom: 0, trailing: 33))
                    }
                    Divider().frame(width:320)
                    DescriptionEvent(descriptionEventName: $descriptionEventName, thingContent: $thingContent,timeLineImage: timeLineImage)
                    EventType(isSelected: $isSelected, selectedType: $thingType, isPresented: $isPresented)
                    EnableReminder(isReminder: $isReminder)
                    EventMarkers(eventIcon: $thingIcon)
                }
            }.padding(EdgeInsets(top: -20, leading: 0, bottom: 0, trailing: 0))
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                                        .filter({$0.activationState == .foregroundActive})
                                        .map({$0 as? UIWindowScene})
                                        .compactMap({$0})
                                        .first?.windows
                                        .filter({$0.isKeyWindow}).first
                                    keyWindow!.endEditing(true)
                }
            .navigationBarTitle(Text("编辑时间轴"),displayMode: .inline)
            .navigationBarItems(trailing: Button(action:{

                do {
                        let user = LCApplication.default.currentUser?.objectId?.stringValue!
                        let query = LCQuery(className: "_User")
                        query.whereKey("objectId", .equalTo(user!))
                        _ = query.getFirst() { result1 in
                            switch result1 {
                            case .success(object: let person):
                                //生产uuid
                                do{
                                let uuid = UUID().uuidString
                                // 构建对象
                                let timer = LCObject(className: "TimeLine")
                                // 为属性赋值
                                try timer.set("eventTime", value: date)
                                try timer.set("eventContent", value: thingContent)
                                try timer.set("eventPerson", value: descriptionEventName)
                                try timer.set("eventType", value: thingType)
                                try timer.set("isWarn", value: isReminder)
                                try timer.set("eventIcon", value: thingIcon)
                                try timer.set("UUID",value: uuid)
                                try timer.set("familyId",value:(person.familyTreeId?.intValue!)!)
                                
                                // 将对象保存到云端
                                _ = timer.save { result in
                                    switch result {
                                    case .success:
                                        // 成功保存之后，执行其他逻辑
                                        print("事件保存成功")
                                        let query = LCQuery(className: "TimeLine")
                                        query.whereKey("UUID", .equalTo(uuid))
                                        _ = query.getFirst() { result in
                                            switch result {
                                            case .success(object: let students):
                                                let objectId = students.objectId;
                                                var objects: [LCObject] = []
                                                do{
                                                    for object1 in timeLineImage.imgUrl{
                                                        let object2 = LCObject(className: "TimeLineAndImage")
                                                        try object2.set("timeLineObjectId", value: objectId?.stringValue!)
                                                        try object2.set("imageUrl",value: object1.stringValue!)
                                                        objects.append(object2)
                                                        print("😯😯😯😯😯😯😯😯😯😯😯😯😯😯😯😯😯😯😯\(objects.count)")
                                                    }
                                                    _ = LCObject.save(objects, completion: { (result) in
                                                        switch result {
                                                        case .success:
                                                            timeLineImage.imgUrl.removeAll()
                                                            timeLineImage.img.removeAll()
                                                            break
                                                        case .failure(error: let error):
                                                            print(error)
                                                        }
                                                    })
                                                }catch{
                                                    print(error)
                                                }
                                                break
                                            case .failure(error: let error):
                                                print(error)
                                            }
                                        }
                                        break
                                    
                                    case .failure(error: let error):
                                        // 异常处理
                                        print(error)
                                    }
                                }
                                break
                            }catch{
                                    print(error)
                            }
                            case .failure(error: let error):
                                print(error)
                            }
                        }
                } catch {
                    print(error)
                }
                isPushed = false
            } ){
                Text("确定")
                    .font(.system(size: 22))
            })
            .onAppear(){
                let objectId = LCApplication.default.currentUser?.objectId
                let query = LCQuery(className: "_User")
                let _ = query.get(objectId!) { (result) in
                    switch result {
                    case .success(object: let todo):
                        let username = todo.username?.stringValue
                        self.descriptionEventName = username!
                    case .failure(error: let error):
                        print(error)
                    }
                }
        }
            
        HalfASheet(isPresented: $isPresented, title: "事件类型") {
            VStack {
                CustomTextField(text: $thingType,isFirstResponder: true)
                        .padding(.horizontal,20)
                        .padding(.top,8)
                        .padding(.bottom,8)
                        .background(Color("EventMarkersBackground"))
                               .cornerRadius(20)
                               .shadow(color: .gray, radius: 2)
                        .frame(width: 300, height: 45, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .font(/*@START_MENU_TOKEN@*/.title3/*@END_MENU_TOKEN@*/)
                Button(action: {
                    isPresented = false
                    showingAlert = true
                }) {
                    Text("确定")
                }
                .background(Color("AccentColor"))
                .frame(width:UIScreen.main.bounds.width/2 - 100,height:40)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(30)
            }
                Spacer()
            }
            .height(.proportional(0.5))
            .alert(isPresented:$showingAlert) {
            Alert(title: Text("成功!!"), message: Text("事件类型添加成功"))
                }
            
        }
    }
}




struct DescriptionEvent: View {
    
    @Binding var descriptionEventName : String
    @Binding var thingContent : String
    @State var isPresented : Bool = false
    @ObservedObject var timeLineImage : TimeLineImage
    var body: some View {
        VStack{
            Text("简单描述事件：")
                .foregroundColor(Color("EditTimerColor"))
                .offset(x: -90)
                .font(.system(size: 20))
                .padding(EdgeInsets(top: 0, leading: 33, bottom: 8, trailing: 40))
            
            VStack {
                TextEditor(text: $thingContent)

                .frame(width: 307, height: 162, alignment: .topLeading)
                .background(Color("DescriptionEventTextfield"))
                .padding()
                .colorMultiply(Color("DescriptionEventTextfield"))
            }
            .background(Color("DescriptionEventTextfield"))
            .cornerRadius(20)
            LazyVGrid(columns: imageItems, content: {
                ForEach(0 ..< timeLineImage.img.count,id: \.self){
                    index in
                ZStack{
                    Image(uiImage : timeLineImage.img[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 110, height: 110, alignment: .center)
                        .cornerRadius(10)
                        .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                    
                    Button(action:{
                        timeLineImage.img.remove(at: index)
                        timeLineImage.imgUrl.remove(at: index)
                    }){
                        ZStack{
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 18, height: 18, alignment: .center)
                                
                                
                        Image("叉")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 15, height: 15, alignment: .center)
                        }
                    }.offset(x: 45, y: -45)
                }
                }
                Button(action:{
                    self.isPresented.toggle()
                }){
                HStack{
                    VStack{
                        Image("ic_add_a_photo_48px")
                            .resizable()
                            .frame(width: 40/*@END_MENU_TOKEN@*/, height: 40, alignment: /*@START_MENU_TOKEN@*/.center)
                        Text("记录相片").font(.system(size:12)).foregroundColor(Color.black)
                    }
                }.frame(width: 110, height: 110, alignment: .center)
                .cornerRadius(10)
                .background(Color(red: 245/255, green: 245/255, blue: 245/255)).cornerRadius(10)
                }.fullScreenCover(isPresented: $isPresented, content: {
                    TimeLineImageUIView(timeLineImage:timeLineImage)
                })
            })
            
            Text("描述人：\(descriptionEventName)")
                .foregroundColor(Color("AccentColor"))
                .offset(x: 80)
            
        }
        .padding(EdgeInsets(top: 20, leading: 33, bottom: 0, trailing: 33))
        Divider().frame(width:320)
       
    }
    
    
}

struct EventType: View {
    var EventItems : [GridItem] = [
        GridItem(GridItem.Size.flexible(),spacing: 5),
        GridItem(GridItem.Size.flexible(),spacing: 5),
        GridItem(GridItem.Size.flexible(),spacing: 5)
    ]
    @State var eventTypes = ["生日","纪念日","学业","生活","事业"]
    @Binding var isSelected : Int
    @Binding var selectedType : String
    @Binding var isPresented : Bool
    
    var body: some View {
        VStack{
            HStack{
                Text("事件类型:\(selectedType)")
                    .font(.system(size: 20))
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 8, trailing: 40))
                    .foregroundColor(Color("EditTimerColor"))

                Spacer()
            }
            LazyVGrid(columns: EventItems, content: {
            ForEach (0..<eventTypes.count){
                index in
                Button(action:{
                    isSelected = index
                    selectedType = eventTypes[isSelected]
                })
                {
                    Text(eventTypes[index])
                    
                        .frame(width:100,height:100)
                        .foregroundColor(isSelected == index ? .white : grayColor )
                }
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .animation(.easeInOut)
                .background( isSelected == index ? LinearGradient(gradient: Gradient(colors: [Color.init(red : 255/255,green: 144/255,blue: 13/255), Color.init(red: 255/255, green: 169/255, blue: 54/255)]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(gradient: Gradient(colors: [Color.white, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)).cornerRadius(15)
                    .shadow(color: Color("AccentColor"), radius: 3, x: 0.5, y: 0.5)
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))

            }
                
                Button(action:{
                    isSelected = eventTypes.count
                    withAnimation(){
                        isPresented = true
                    }
                    

                    
                })
                {
                    Image("plusSign")
                }
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .animation(.easeInOut)
            .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)).cornerRadius(15)
                .shadow(color: Color("AccentColor"), radius: 3, x: 0.5, y: 0.5)
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
            })
            
        }.frame(width:360)
//

    }
}

//开启提醒
struct EnableReminder: View {
    @State  var isPressed  = false
    @Binding var isReminder : Bool
    
    
    var body: some View {
        HStack {
            HStack {
                Text("开启提醒")
                    .foregroundColor(Color("fontColor"))
                Button(action: {
                   isPressed = false
                    isReminder = true
                }) {
                    if(isPressed ==  false){
                        HStack {
                            Text("是")
                                .foregroundColor(Color("AccentColor"))
                                .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                                .frame(width: 50, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        .background(Color("Reminder"))
                        .cornerRadius(8)
                            
                    }else{
                        Text("是")
                        .foregroundColor(Color("fontColor"))
                            .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                            .frame(width: 50, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
      
                }
                Button(action: {
                    isPressed = true
                    isReminder = false
                }) {
                    if(isPressed ==  true){
                        HStack {
                            Text("否")
                                .foregroundColor(Color("AccentColor"))
                                .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                                .frame(width: 50, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        .background(Color("Reminder"))
                        .cornerRadius(8)
                            
                    }else{
                        Text("否")
                        .foregroundColor(Color("fontColor"))
                            .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                            .frame(width: 50, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                }

            }
            .padding(EdgeInsets(top: 5, leading: 33, bottom: 0, trailing: 33))
            .offset(x: -70)
        }

    }
}

//事件图标
struct EventMarkers: View {
    @State var isPressedMore = false
    @Binding var eventIcon : Int
    @State var IsPressedIcon = 0
    
    var items : [GridItem] = [
        GridItem(GridItem.Size.flexible(),spacing: 5),
        GridItem(GridItem.Size.flexible(),spacing: 5),
        GridItem(GridItem.Size.flexible(),spacing: 5),
        GridItem(GridItem.Size.flexible(),spacing: 5),
        GridItem(GridItem.Size.flexible(),spacing: 5),
        GridItem(GridItem.Size.flexible(),spacing: 5)
    ]
    var body: some View {
        VStack {
            HStack{
                Text("事件图标:")
                    .foregroundColor(Color("EventMarkersFont"))
//                    .offset()
                Image("eventIcon\(eventIcon)")
                    .frame(width: 20, height:20 )
            }
            .offset(x: -113)

            LazyVGrid(columns: items, content: {
                if(isPressedMore == false){
                    ForEach(0..<30){
                        index in
                    Image("eventIcon\(index)")
                            .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .onTapGesture {
                                eventIcon = index
                            }
                    }.padding(10)
                }else{
                    ForEach(0..<60){
                        index in Image("eventIcon\(index)")
                            .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .onTapGesture {
                                eventIcon = index
                            }
                    }.padding(10)
                }
                
                HStack {
                    Text(isPressedMore ? "收回" : "更多")
                        .foregroundColor(Color("fontColor"))
                        .frame(width: 40, height: 21, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        
                    
                    Image(systemName: "chevron.forward.2")
                        .foregroundColor(Color("fontColor"))
                        .rotationEffect(.degrees(isPressedMore ? -90 : 0))
                        .animation(.easeInOut(duration: 2.0))
                }
                .offset(x: 120)
                .onTapGesture {
                    if(isPressedMore == true){
                        isPressedMore = false
                    }else{
                        isPressedMore = true
                    }
                    
        
                }
               
            })
            .padding()
            .background(Color("EventMarkersBackground"))
            .frame(width: 314, height: isPressedMore ? 550:280, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .cornerRadius(17)
        }
        .padding(EdgeInsets(top: 20, leading: 33, bottom: 0, trailing: 33))
        

    }
}
//struct EditTimelineView_Previews: PreviewProvider {
//    @Binding var isPushed
//    static var previews: some View {
//        EditTimelineView(isPushed: $isPushed)
//    }
//}

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

