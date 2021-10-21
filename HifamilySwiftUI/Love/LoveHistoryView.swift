//
//  LoveHistoryView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/17.
//

import SwiftUI

struct LoveHistoryView: View {
    @ObservedObject var family:Family = Family()
    @ObservedObject var miss:Miss 
    @Binding var loveHistory : Bool
    var body: some View {
        GeometryReader { geometry in
        ZStack{
            Rectangle().fill(Color.gray).opacity(0.5)
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    HStack{
                        Image("Miss family").padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
                        Spacer()
                    }
                    HStack{
                        Text("我收到的思念").font(.system(size: 28)).frame(width: 200, height: 50, alignment: .center).padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0)
                        )
                        Spacer()
                    }.debugPrint(miss.missByCount.count)
                    ForEach(0 ..< miss.MissByHistory.count,id: \.self){ i in
                        HStack{
                            Text("\(miss.MissByHistory[i])今年共思念了你\(miss.missByCount[i])次")
                                .tracking(3)
                                .padding(EdgeInsets(top: 2, leading: 20, bottom: 0, trailing:10 ))
                                .foregroundColor(grayColor)
                            Spacer()
                        }
                    }
                    HStack{
                        Text("我发送的思念").font(.system(size: 28)).frame(width: 200, height: 50, alignment: .center).padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0)
                        )
                        Spacer()
                    }
                    ForEach(0 ..< miss.MissHistory.count,id: \.self){ i in
                        HStack{
                            Text("我今年共思念\(miss.MissHistory[i])了\(miss.missByCount[i])次")
                                .tracking(3)
                                .padding(EdgeInsets(top: 2, leading: 20, bottom: 0, trailing:10 ))
                                .foregroundColor(grayColor)
                            Spacer()
                        }
                    }
                    HStack{
                        Spacer()
                        Button(action: {
                            
                            self.loveHistory = false
                        }) {
                            
                            Text("提交")
                                .padding(10)
                                .foregroundColor(.white)
                                .background(Color("AccentColor").cornerRadius(10))
                        }
                        .padding(EdgeInsets(top:20,leading:10,bottom:20,trailing: 15))
                        .buttonStyle(DefaultButtonStyle())
                    }
                    
                } .frame(width: 280)
                .background(Color(white: 0.99))
                .overlay(RoundedRectangle(cornerRadius: 20.0, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 1.4)).shadow(radius: 1)
                .cornerRadius(20)
                .shadow(color: .gray, radius: 10, x: 0, y: 3)
                .animation(.easeInOut)
            }.frame(width: 300, height: 600, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .offset( y: geometry.size.width/3)
        }
        }
    }
}

struct LoveHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        LoveHistoryView(miss:Miss(), loveHistory: .constant(true))
    }
}
