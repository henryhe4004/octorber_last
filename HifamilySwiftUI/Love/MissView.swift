//
//  MissView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/16.
//

import SwiftUI
import LeanCloud

struct myTextFieldStyle : TextFieldStyle{
    func _body(configuration:TextField<Self._Label>)->some View{
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.gray)
            configuration
//                .padding(.vertical,10)
        }
        .padding(.horizontal,10)
        .background(Color.yellow)
        .cornerRadius(20)
        .shadow(color: .gray, radius: 2)
    }
}

struct TextFieldCleanButtonStyle: TextFieldStyle{
    @Binding var text: String
    func _body(configuration:TextField<Self._Label>)->some View{
        HStack{
            configuration
                .padding()
            if !text.isEmpty{
                Button {
                    self.text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.gray)
                }
                .padding(.trailing , 10)

            }
        }
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(Color.gray,lineWidth: 1)
//        )
//        .padding(.horizontal , 10)
    }
}


struct UnderLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return path
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct UnderLineTextFieldStyle : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.callout)
            .padding(.bottom, 10)
            .foregroundColor(.gray)
            .background(
                UnderLine()
                    .stroke(Color.gray, lineWidth: 1.0)
                    .frame(alignment: .bottom)
            )
    }
}

struct MissView: View {
    @State  var context : String = " "
    @State private var isUpdate = false
    @Binding var missSetting : Bool
    @ObservedObject var familyTree:FamilyTree
    
    var body: some View {
        GeometryReader { geometry in
        VStack {
           
            HStack{
              Text("输出你的个性思恋语句吧～")
                Spacer()
            }.padding(EdgeInsets(top: 30, leading: 10, bottom: 10, trailing: 10))

//                Text("妍妍")
//                    .foregroundColor(.gray)
//                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
//                Spacer()
            KeyboardHost{
                TextField("个性化语句", text : $context)
                    .frame(width:250, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(grayColor2)
                    .textFieldStyle(UnderLineTextFieldStyle())
                    .keyboardType(.default)
                    .padding(EdgeInsets(top: 0, leading: -10, bottom: 10, trailing: 15))
            }
                
            
            HStack{
                Text("例：妍妍摸了摸你并送了一份思念")
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 15))
                    .foregroundColor(grayColor)
                    .font(.system(size: 15))
                Spacer()
            }
            
            HStack{
                Spacer()
                Button(action: {
                    self.isUpdate = true
                    self.missSetting = false
                    do {
                        let objectId = LCApplication.default.currentUser?.objectId?.value
                        let todo = LCObject(className: "_User",objectId: objectId!)
                        try todo.set("missContent", value: context)
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
                }) {
                    Text("提交")
                        .frame(width: 40, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding(10)
                        .foregroundColor(.white)
                        .background(Color("AccentColor").cornerRadius(10))
                }
                .padding(EdgeInsets(top:20,leading:10,bottom:20,trailing: 15))
                .buttonStyle(DefaultButtonStyle())
            }

//            if(isChangeInformantion){
//                Button(action: {
//                    self.isChangeInformantion = false
//                }) {
//                    Text("保存信息")
//
//                }
//                .padding(EdgeInsets(top:10,leading:45,bottom:30,trailing: 40))
//                .buttonStyle(DefaultButtonStyle())
//
//            }else{
//                Button(action: {
//                    self.isChangeInformantion = true
//                }) {
//                    Text("修改信息")
//                        .padding(10)
//                        .foregroundColor(.white)
//                        .background(Color("AccentColor").cornerRadius(10))
//                }
//                .padding(EdgeInsets(top:10,leading:45,bottom:30,trailing: 40))
//                .buttonStyle(DefaultButtonStyle())
//
//            }
            
        }
     
        .frame(width: 300)
        .background(Color(white: 0.99))
        .cornerRadius(20)
        .shadow(color: .gray, radius: 10, x: 0, y: 3)
        .animation(.easeInOut)
        .onTapGesture {
//            self.fold.toggle()
        }
        .overlay(RoundedRectangle(cornerRadius: 20.0, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 1.4)).shadow(radius: 1)
        }
    }
    
}


struct MissView_Previews: PreviewProvider {
    static var previews: some View {
        MissView(missSetting: .constant(true),familyTree:FamilyTree())
    }
}
