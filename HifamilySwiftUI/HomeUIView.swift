//
//  HomeUIView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/10/13.
//

import SwiftUI
import LeanCloud

struct HomeUIView: View {
    @State private var index = 3
    @ObservedObject var familyTree:FamilyTree = FamilyTree()
    @ObservedObject var album:Album
    @ObservedObject var miss:Miss = Miss()
    @ObservedObject var myLetter:MyLetter = MyLetter()
    @ObservedObject var familyLetterMumber:LLMumber = LLMumber()
    @ObservedObject var moreLetter:MoreLetter = MoreLetter()
    @ObservedObject var timeLiner:TimeLiner = TimeLiner()
    @Binding var isLogin : Bool
//    @State var isFirstLogin = true
    @Binding var isFirstLogin : LCBool
    @Binding var isPressed1 : Bool
    @Binding var objectId:LCString
    
    var body: some View {
        TabView(selection: $index) {
//            FamilyTreeView()
            ImageUIView(album:album).tabItem { Image(index == 1 ? "Iconly-Bulk-Activity" : "fIconly-Bulk-Activity") }.tag(1).onAppear(perform: {
                    album.update()
                //改回来
//                if #available(iOS 15.0, *) {
//                    let appearance = UITabBarAppearance()
//                    UITabBar.appearance().scrollEdgeAppearance = appearance
//                }
                    
            })
            LetterView(familyLetterMumber:familyLetterMumber, myLetter: myLetter, moreLetter: moreLetter).tabItem { Image(index == 2 ? "Iconly-Bulk-Message" : "fIconly-Bulk-Message") }.tag(2).onAppear(perform: {
                if(familyLetterMumber.mumbersObjectId.isEmpty) {
                    familyLetterMumber.queryFamilyMumber()
                }
                if(myLetter.letters.isEmpty) {
                    myLetter.queryAllMyLetter()
                }
                if(moreLetter.cards.isEmpty) {
                    moreLetter.queryAllMyLetter()
                }
            })
            HomeView(isLogin: $isLogin,isFirstLogin: $isFirstLogin,isPressed1: $isPressed1,objectId: $objectId).tabItem { Image( index == 3 ? "fIconly-Bulk-Home" : "Iconly-Bulk-Home") }.tag(3).onAppear {
                //改回来
//                if #available(iOS 15.0, *) {
//                    let appearance = UITabBarAppearance()
//                    UITabBar.appearance().scrollEdgeAppearance = appearance
//                }
            }
            LoveView(familyTree: familyTree,miss:miss).tabItem { Image( index == 4 ? "Iconly-Bulk-Heart" : "fIconly-Bulk-Heart") }.tag(4).onAppear(perform: {
                familyTree.queryUser()
                miss.queryMiss()
            })

            MyTimeLineView(timeLiner: timeLiner).tabItem { Image(index == 5 ? "fIconly-Bulk-Chart" : "Iconly-Bulk-Chart") }.tag(5).onAppear(
                perform: {
                    timeLiner.queryFamilyId()
                }
            )
                
        
        }
        .navigationBarTitle("",displayMode: .inline)
        .navigationBarHidden(true)

    }
}


