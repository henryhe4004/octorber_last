//
//  HomeView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/14.
//

import SwiftUI
import CoreData



struct HomeView: View {
    //isHaveTree true 为创建者，false为加入者
    @State var isHaveTree = false
    @State var isPresented = false
    @State var isPersonPresented = false
    
    //家庭树的初始值
    var imgsTree = ["tree","second tree","third tree"]
    @State  private var indexTree = 0//默认树
    @State var familyIdWrite = "5526"
    @State var familyMemberCountWrite = "1"
    @State var familyTreeWrite = 0
    
    //左边菜单栏
    @State var showLeftMenu = false
   
    var body: some View {
        
        let drag = DragGesture()
            .onEnded {
                    if $0.translation.width < -100 {
                        withAnimation {
                                    self.showLeftMenu = false
                                }
                            }
                    else if $0.translation.width > 100 {
                        withAnimation {
                                    self.showLeftMenu = true
                        }
                    }
            }
        return GeometryReader { geometry in
        
        ZStack(alignment: .leading) {
            VStack{
                //title
                Title(showLeftMenu : $showLeftMenu)
                Divider()
                //title 下面部分
                TitleDown(familyIdWrite: $familyIdWrite, familyMemberCountWrite: $familyMemberCountWrite,familyTreeWrite:$familyTreeWrite,isHaveTree :$isHaveTree,indexTree:$indexTree)
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .offset(x: self.showLeftMenu  ? 4*geometry.size.width/5: 0)
            .disabled(self.showLeftMenu  ? true : false)
            .transition(.move(edge: .leading))
            
            
            if self.showLeftMenu{
                LeftMenuView()
                    .frame(width: 4*geometry.size.width/5)
                    .transition(.move(edge: .leading))
            }
        }
        .gesture(drag)
        
    }
}

    struct TitleDown: View {
        @Binding var familyIdWrite : String
        @Binding var familyMemberCountWrite : String
        @Binding var familyTreeWrite : Int
        @Binding var isHaveTree : Bool
        @Binding var indexTree : Int
        var imgsTree = ["tree","second tree","third tree"]
        var body: some View {
            VStack {
                
                HStack() {
                    
                    Text("家庭ID：\(familyIdWrite)").font(.system(size: 14))
                    Spacer()
                    Text("总共成员:").font(.system(size: 14))
                        + Text("\(familyMemberCountWrite)").foregroundColor(Color("AccentColor"))
                        .font(.system(size: 16))
                    
                }.padding(EdgeInsets(top: 0, leading: 7, bottom: 10, trailing: 20))
                
                ZStack {
                    
                    HomeLandUIView()
                    HStack {
                        HStack {
                            Image(imgsTree[familyTreeWrite])
                                .animation(.interpolatingSpring(stiffness: 20, damping: 5))
                                .scaledToFit()
                                .offset(y: 20)
                        }
                        .frame(width: 300, height: 220, alignment: .center)
                        
                        //切换家庭树
                        Button(action: {
                            if indexTree == 2{
                                withAnimation{
                                    indexTree = 0
                                }
                                
                            }else{
                                withAnimation{
                                    indexTree = indexTree + 1
                                }
                                
                            }
                            familyTreeWrite = indexTree
                        }) {
                            VStack {
                                CutButton()
                            }
                            
                        }
                        .padding(EdgeInsets(top:280,leading:-80,bottom:0,trailing:0))
                        if(!isHaveTree){
                            AddFamilyButton()
                        }
                        
                    }
                    .padding(EdgeInsets(top:0,leading:0,bottom:0,trailing:0))
                    
                    FamilyBlackboard()
                       
                        
                    Textfield02()

                    
                }
            }.frame(minWidth: 0/*@END_MENU_TOKEN@*/,  maxWidth: .infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0,  maxHeight: /*@START_MENU_TOKEN@*/.infinity, alignment: .topLeading)
            .animation(.interpolatingSpring(stiffness: 20, damping: 5))
        }
    }

//家庭树名字
//家庭树改名字在个人中心处改！！！
class FamilyNameModel: ObservableObject {
        @Published var FamilyTreeName: String = "相亲相爱一家人"
}
    
struct FamilyBlackboard: View {
    //家庭树名字
    @ObservedObject var model = FamilyNameModel()
    @State var isPresented = false
    
        var body: some View {
            
            HStack {
                Text("\(model.FamilyTreeName)")
                .font(.system(size: 16))
                .foregroundColor(Color("FamliyTreeNameColor"))
                .frame(width: 90, height: 0)
                .offset(x: -123, y: 143)
                .multilineTextAlignment(.center)
              
            }
         

        }
    
    }
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            
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
  
    var modalView: some View {
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
            
            //这个是发生申请的button，在这里写链接，发送申请的请求！！！
            Button(action: {
                    familyIDAlert = familyId
                    self.showingAlert = true
                    familyId = ""
                
                //发送申请，查看是否有这个家庭树ID
            }) {
                Text("发送申请")
            }
            .background(Color("AccentColor"))
            .frame(width:UIScreen.main.bounds.width/2 - 80,height:40)
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(30)
            .alert(isPresented:$showingAlert) {
                familyIDAlert != "" ? Alert(title: Text("发送申请成功"), message: Text("已向\(familyIDAlert)家庭发送申请")) : Alert(title: Text("发送申请失败"), message: Text("请输入家庭ID"))
                    }
            .padding(.top,20)
            
            Spacer()
            
        }
        .padding(.top,45)
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
    @Binding var showLeftMenu : Bool
    var body: some View {
        HStack {
            Image("three line")
                .resizable()
                .frame(width:23,
                       height:23,
                       alignment:.center)
                .onTapGesture {
                    withAnimation {
                        self.showLeftMenu  = true
                    }
                    
                }
            Spacer()
            Text("Your family tree")
                .foregroundColor(Color("AccentColor"))
            
            Spacer()
            Button(action: {
//                    self.isPersonPresented = true
                
            }) {
                Image("person")
            }
//            .fullScreenCover(isPresented: $isPersonPresented, content: {
//                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
//            })
            
        }.padding(15)
    }
}

