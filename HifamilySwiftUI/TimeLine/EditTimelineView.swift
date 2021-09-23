//
//  EditTimelineView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/23.
//

import SwiftUI



struct EditTimelineView: View {
    
    @State var isSelected = -1;
//    @State var isAdd = false
    var body: some View {
        
        VStack {
//            UpperNavigationBarEdit()
            ScrollView(.vertical){
                Spacer()
                EventData()
                DescriptionEvent()
                EventType(isSelected: $isSelected)
                EnableReminder()
                EventMarkers()
            }
        }.padding(EdgeInsets(top: -20, leading: 0, bottom: 0, trailing: 0))
        .navigationBarTitle(Text("编辑时间轴").foregroundColor(grayColor2)
            .font(.system(size: 22)),displayMode: .inline)
        .navigationBarItems(trailing: Button(action:{} ){
            Text("确定")
                .foregroundColor(Color.white)
                .font(.system(size: 22))
        })
    }
}


struct UpperNavigationBarEdit: View {
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "chevron.left")
                    .resizable()
                    .foregroundColor(Color.white)
                    .frame(width:13,
                           height:21,
                           alignment:.center)
                Spacer()
                Text("编辑时间轴")
                    .foregroundColor(Color.white)
                    .font(.system(size: 22))
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("确定")
                        .foregroundColor(Color.white)
                        .font(.system(size: 22))
                }
                    .frame(width:45,
                           height:30,
                           alignment:.center)

            }
            .padding(EdgeInsets(top: 50, leading: 15, bottom: 16, trailing: 15))
            .background(Color("TimeLineColor"))

        }

    }
}


struct EventData: View {
    @State private var date = Date()
    
    var body: some View {
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

    }
}

struct DescriptionEvent: View {
    @State var descriptionEventName = "妍妍"
    var body: some View {
        VStack{
            Text("简单描述事件：")
                .foregroundColor(Color("EditTimerColor"))
                .offset(x: -90)
                .font(.system(size: 20))
                .padding(EdgeInsets(top: 0, leading: 33, bottom: 8, trailing: 40))
            
            VStack {
                TextField("请简单描述一下事件",
                          text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .frame(width: 307, height: 162, alignment: .topLeading)
                    .background(Color("DescriptionEventTextfield"))
                    .padding()
            }
            .background(Color("DescriptionEventTextfield"))
            .cornerRadius(20)
            Text("描述人：\(descriptionEventName)")
                .foregroundColor(Color("AccentColor"))
                .offset(x: 100)
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
//    @Binding var isAdd : Bool
    var body: some View {
        VStack{
            HStack{
                Text("事件类型:")
                    .font(.system(size: 20))
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 8, trailing: 40))
                    .foregroundColor(Color("EditTimerColor"))
//                    .foregroundColor(grayColor2)
                Spacer()
            }
            LazyVGrid(columns: EventItems, content: {
            ForEach (0..<eventTypes.count){
                index in
                Button(action:{
                    isSelected = index
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
                })
                {
                    Image("plusSign")
                }
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .animation(.easeInOut)
                .background( isSelected == eventTypes.count ? LinearGradient(gradient: Gradient(colors: [Color.init(red : 255/255,green: 144/255,blue: 13/255), Color.init(red: 255/255, green: 169/255, blue: 54/255)]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(gradient: Gradient(colors: [Color.white, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)).cornerRadius(15)
                    .shadow(color: Color("AccentColor"), radius: 3, x: 0.5, y: 0.5)
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))

            })
            
        }.frame(width:360)
//

    }
}

//开启提醒
struct EnableReminder: View {
    @State var isPressed = false
    
    var body: some View {
        HStack {
            HStack {
                Text("开启提醒")
                    .foregroundColor(Color("fontColor"))
                Button(action: {
                   isPressed = false
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
    @State var eventIcon = 0
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
struct EditTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        EditTimelineView()
    }
}
