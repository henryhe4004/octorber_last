//
//  ContentView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/13.
//

import SwiftUI
import CoreData
//第一个结构体遵循View协议，描述视图的内容和布局

struct ContentView: View {
    //body 属性只返回单个视图，这时组合多个视图把他们放入一个栈中
    @State private var index = 3 //默认选中索引
    var body: some View {
        //VStack 是垂直栈,HStack 是水平栈,Group 是一个容器，它可以把视图内容组织起来，每个子视图会继承自己所处环境的配置
        //可以使用NavigationLink让列表的行实现点击跳转到其他视图页面
        //可以使用foregroundColor(_:)来改变它的颜色，当isFavorite为真时，星标显示
        TabView(selection: $index) {
//            FamilyTreeView()
            ImageUIView().tabItem { Image(index == 1 ? "Iconly-Bulk-Activity" : "fIconly-Bulk-Activity") }.tag(1)
            LetterView().tabItem { Image(index == 2 ? "Iconly-Bulk-Message" : "fIconly-Bulk-Message") }.tag(2)
            HomeView().tabItem { Image( index == 3 ? "fIconly-Bulk-Home" : "Iconly-Bulk-Home") }.tag(3)
            LoveView().tabItem { Image( index == 4 ? "Iconly-Bulk-Heart" : "fIconly-Bulk-Heart") }.tag(4)
            MyTimeLineView().tabItem { Image(index == 5 ? "fIconly-Bulk-Chart" : "Iconly-Bulk-Chart") }.tag(5)
            
        }

    }
}

//第二个结构体声明为第一个视图的预览视图
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
