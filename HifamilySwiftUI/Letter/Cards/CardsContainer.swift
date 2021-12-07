//
//  CardsContainer.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/12/6.
//

import SwiftUI
import LeanCloud

struct CardsContainer: View {
    
//    @State private var cards: [Cardd] = Generator.Cards.random()
    
//    @State var cards: [Cardd]
    @State var settings: Settings = Settings.default(for: .cards)
    @State var showSettings = false
    
    @ObservedObject var moreLetter:MoreLetter
    
    
//    func queryAllMyLetter() {
//        // 获取当前用户的Id
//        let myLetterId = LCApplication.default.currentUser?.objectId?.value
//
//        let query = LCQuery(className: "Letter")
//
//        query.whereKey("receiveLetterId", .equalTo(myLetterId!))
//        query.whereKey("createdAt", .descending)
//        _ = query.find { result in
//            switch result {
//            case .success(objects: let l):
//                for Item in l {
//                    // 查出来每封信的Id
//                    var mis:Cardd = Cardd(image: "", title: Date(), subtitle: "")
//                    mis.subtitle = (Item.letterContent?.stringValue!)!
//                    let letterId = (Item.objectId?.stringValue!)!
//                    let query = LCQuery(className: "LetterM")
//                    query.whereKey("letterObjectId", .equalTo(letterId))
//                    _ = query.getFirst { result in
//                        switch result {
//                        case .success(object: let todo):
//                            mis.image = (todo.sendName?.stringValue!)!
////                            mis.receiveName = (todo.receiveName?.stringValue!)!
//                            mis.title = (todo.createdAt?.dateValue!)!
//                            self.cards.append(mis)
//                            print("NNNNNNNNNNNNNNNNNNN")
//                            print(mis)
//                        case .failure(error: let error):
//                            print(error)
//                        }
//                    }
//                }
//                break
//            case .failure(error: let error):
//                print(error)
//            }
//        }
//    }
//
    var body: some View {
        NavigationView {
            CardsGrid(cards: .constant(moreLetter.cards), settings: $settings)
        }
        .sheet(isPresented: $showSettings, content: { SettingsView(settings: self.$settings, screen: .cards, isPresented: self.$showSettings) })
        .navigationBarTitle(Text("全部家书").foregroundColor(grayColor2)
                                .font(.system(size: 22)),displayMode: .inline)
        .navigationBarItems(trailing: self.trailingNavigationBarItems())
//        .navigationBarItems(leading: self.leadingNavigationBarItems(), trailing: self.trailingNavigationBarItems())
    }
//    private func leadingNavigationBarItems() -> some View {
//        Button(action: { self.showSettings = true }) {
//            Image(systemName: "gear")
//        }
//    }
    private func trailingNavigationBarItems() -> some View {
        HStack() {
//            Button(action: { self.cards = Generator.Cards.random() }) {
                Image(systemName: "gobackward")
            }
        }
    }
//}

//struct CardsContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        CardsContainer(cards: [Cardd])
//    }
//}

