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
    @State var keyboardHight : CGFloat = 0
    
    
    var body: some View {
        ZStack {
            if(isPressed){
                
                Rectangle()
                    .fill(Color.gray)
                    .opacity(0.5)
                ScrollView(.horizontal, showsIndicators: false) {
                  
                    Spacer()
                    VStack {
                        HStack(alignment: .center) {
                            Spacer()
                                ScrollView{
                                AddMemberCardUIView()
                                    .padding(20)
                                }
                                .frame(width: 280, height: 600, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                
                                .onTapGesture {
                                    isPressed = false
                                }
                                .onAppear {
                                        //键盘抬起
                                         NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.current) { (noti) in
                                           let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                                               let height = value.height
                                            self.keyboardHight = height - UIApplication.shared.windows.first!.safeAreaInsets.bottom
                                         }
                                         //键盘收起
                                      NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.current) { (noti) in
                                                 self.keyboardHight = 0
                                         }
                                     }
                                .offset(y : -keyboardHight/3)
                                
//                            }

                            
                                //显示Core Data数据库内容的列表
                                //将数据库的familyName输出
                            

                            //改回来
                ForEach(memberModels, id: \.name) { memberModel in
                            ScrollView{
                                CardUIView(image:memberModel.avatar! ,memberName:memberModel.name! ,memberIdentity:memberModel.birthday! ,memberTelephone:memberModel.phone!).padding(20)
                                            }
                            .frame(width: 280, height: 600, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                            .onTapGesture {
                                isPressed = false
                            }
                            .onAppear {
                                    //键盘抬起
                                     NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.current) { (noti) in
                                       let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                                           let height = value.height
                                        self.keyboardHight = height - UIApplication.shared.windows.first!.safeAreaInsets.bottom
                                     }
                                     //键盘收起
                                  NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.current) { (noti) in
                                             self.keyboardHight = 0
                                     }
                                 }
                            .offset(y : -keyboardHight/3)
//                                    }


                                }
                                
                        }
                        
                        
                    }
                }
            }else{
                avaterTree(isPressed:$isPressed)
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


struct avaterTree: View {
    @Binding var isPressed : Bool;
    var body: some View {
        VStack {
            HStack {
                Image("grandFather")
                    .onTapGesture {
//                        isPressed = true
                    }
                    .frame(width: 130, height: 130)
                    
                    .offset(x: 10, y: -20)
                Image("grandmother")
                    .onTapGesture {
//                        isPressed = true
                    }
            }
            .frame(width: 300, height: 130)
            HStack {
                Image("father")
                    .onTapGesture {
//                        isPressed = true
                    }
                    .offset(x: -60, y: -50.0)
                Image("mother")
                    .onTapGesture {
//                        isPressed = true
                    }.offset(x: 0, y: -30.0)
            }
            .frame(width: 400, height: 100)
            
            HStack {
                Image("bother")
                    .onTapGesture {
//                        isPressed = true
                    }
                    .offset(x: -80, y: -60)
                Image("sister")
                    .onTapGesture {
//                        isPressed = true
                    }
                    .offset(x: 40, y: -40)
                
            }
            
        }.offset(x: 10, y: -100)
    }
}
