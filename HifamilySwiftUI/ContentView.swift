//
//  ContentView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/13.
//

import SwiftUI
import CoreData
import LeanCloud
//第一个结构体遵循View协议，描述视图的内容和布局
extension View {
    func debugPrint(_ value:Any) -> some View {
        #if DEBUG
        print(value)
        #endif
        return self
    }
}


struct ContentView: View {
    //body 属性只返回单个视图，这时组合多个视图把他们放入一个栈中
    
    
   //默认选中索引
    @State var isLogin : Bool = false
    
    var body: some View {
       

            
            LoginUIView(isLogin: $isLogin)
                .fullScreenCover(isPresented: $isLogin, onDismiss: {
                                print("Detail View Dismissed")
                            }) {
                                HomeUIView()
                            }
//
            
        
 
//        .border(Color.blue)
//        .navigationBarHidden(true)
//        .navigationBarTitle(Text("Home"))
//        .edgesIgnoringSafeArea([.top, .bottom])
        

    }
}

//第二个结构体声明为第一个视图的预览视图
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
