//
//  Textfield02.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/20.
//

import SwiftUI
import CoreData


struct Textfield02: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: MemberModel.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(keyPath: \MemberModel.familyId, ascending: true)])
    var memberModels: FetchedResults<MemberModel>
    
    @State var isPressed = false //是否按压图片
    
    
    var body: some View {
        ZStack {
            if(isPressed){
                
                Rectangle()
                    .fill(Color.gray)
                    .opacity(0.5)
                ScrollView(.horizontal, showsIndicators: false) {
                  
                    Spacer()
                    VStack {
                        HStack(alignment: .center, spacing: 10) {
                            Spacer()

                            Image(systemName: "arrow.left")
                                .resizable(resizingMode: .tile)
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(Color("AccentColor"))
                                .onTapGesture {
                                    isPressed = false
                                }
                                .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .padding()
                            KeyboardHost{
                                ScrollView{
                                AddMemberCardUIView()
                                }
                            }

                            
                                //显示Core Data数据库内容的列表
                                //将数据库的familyName输出
                            

                            //改回来
                ForEach(memberModels, id: \.name) { memberModel in
                        KeyboardHost {
                            ScrollView{
                                CardUIView(image:memberModel.avatar! ,memberName:memberModel.name! ,memberIdentity:memberModel.birthday! ,memberTelephone:memberModel.phone!).padding()
                                            }
                                    }


                                }
                                
                        }
                        
                        
                    }
//                    Spacer()
                }
            }else{
                VStack {
                    HStack {
                        Image("grandFather")
                            .onTapGesture {
                                isPressed = true
                            }
                            .frame(width: 130, height: 130)

                            .offset(x: 10, y: -20)
                        Image("grandmother")
                            .onTapGesture {
                                isPressed = true
                            }
                    }
                    .frame(width: 300, height: 130)
                    HStack {
                        Image("father")
                            .onTapGesture {
                                isPressed = true
                            }
                            .offset(x: -60, y: -50.0)
                        Image("mother")
                            .onTapGesture {
                                isPressed = true
                            }.offset(x: 0, y: -30.0)
                    }
                    .frame(width: 400, height: 100)
                 
                    HStack {
                        Image("bother")
                            .onTapGesture {
                                isPressed = true
                            }
                            .offset(x: -80, y: -60)
                        Image("sister")
                            .onTapGesture {
                                isPressed = true
                            }
                            .offset(x: 40, y: -40)
                        
                    }

                }.offset(x: 10, y: -100)
            }
           
        }
    }
}

struct Textfield02_Previews: PreviewProvider {
    static var previews: some View {
        Textfield02()
    }
}

struct KeyboardHost<Content: View>: View {
    let view: Content
    
    @State private var keyboardHeight: CGFloat = 0
    
    private let showPublisher = NotificationCenter.Publisher.init(
        center: .default,
        name: UIResponder.keyboardWillShowNotification
    ).map { (notification) -> CGFloat in
        if let rect = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
            return rect.size.height
        } else {
            return 0
        }
    }
    
    private let hidePublisher = NotificationCenter.Publisher.init(
        center: .default,
        name: UIResponder.keyboardWillHideNotification
    ).map {_ -> CGFloat in 0}
    
    // Like HStack or VStack, the only parameter is the view that this view should layout.
    // (It takes one view rather than the multiple views that Stacks can take)
    init(@ViewBuilder content: () -> Content) {
        view = content()
    }
    
    var body: some View {
        VStack {
            view
            Rectangle()
                .frame(height: keyboardHeight/3)
                .animation(.default)
                .foregroundColor(.clear)
        }.onReceive(showPublisher.merge(with: hidePublisher)) { (height) in
            self.keyboardHeight = height
        }
    }
}

