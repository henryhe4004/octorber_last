//
//  LetterVeiw.swift
//  HifamilySwiftUI
//
//  Created by 吴柏辉 on 2021/9/17.
//

import SwiftUI
import LeanCloud

let orangeColor = Color(UIColor(red: 1, green: 0.66, blue: 0.21, alpha: 1))

let shadowColor = Color(UIColor(red: 1, green: 0.53, blue: 0, alpha: 0.45))

let grayColor = Color(UIColor(red: 0.45, green: 0.45, blue: 0.45,alpha: 1))

let grayColor2 = Color(UIColor(red: 0.55, green: 0.55, blue: 0.55,alpha:1))


struct everyLetter {
    var letterContent:String
    var sendName:String
    var receiveName:String
    var sendTime:Date
}

final class MyLetter:ObservableObject {
    @Published var letterNum:Int
    @Published var letters:[everyLetter]
    
    init() {
        letterNum = 0
        letters = []
    }
    
    func queryAllMyLetter() {
        // 获取当前用户的Id
        let myLetterId = LCApplication.default.currentUser?.objectId?.value
        
        let query = LCQuery(className: "Letter")
        
        query.whereKey("receiveLetterId", .equalTo(myLetterId!))
        query.whereKey("createdAt", .descending)
        _ = query.find { result in
            switch result {
            case .success(objects: let l):
                for Item in l {
                    // 查出来每封信的Id
                    var mis:everyLetter = everyLetter(letterContent: "", sendName: "", receiveName: "", sendTime: Date())
                    mis.letterContent = (Item.letterContent?.stringValue!)!
                    let letterId = (Item.objectId?.stringValue!)!
                    let query = LCQuery(className: "LetterM")
                    query.whereKey("letterObjectId", .equalTo(letterId))
                    _ = query.getFirst { result in
                        switch result {
                        case .success(object: let todo):
                            mis.sendName = (todo.sendName?.stringValue!)!
                            mis.receiveName = (todo.receiveName?.stringValue!)!
                            mis.sendTime = (todo.createdAt?.dateValue!)!
                            self.letters.append(mis)
                        case .failure(error: let error):
                            print(error)
                        }
                    }
                }
                break
            case .failure(error: let error):
                print(error)
            }
        }
        
        let query2 = LCQuery(className: "Letter")
        query2.whereKey("receiveLetterId", .equalTo(myLetterId!))
        let count = query2.count()
        self.letterNum = count.intValue

    }
}

struct peopleLetter {
    var personObjectId:String
    var personName: String
    var personLetterNum: Int
    var thisLetter:[everyLetter]
}

struct spLetter {
    var ObjectId:String
    var Name:String
    var familyMuber:String
    var LetterNum:Int
    var pletter:peopleLetter
}


final class LLMumber:ObservableObject {
    
    @Published var mumbersObjectId: [String]
    @Published var mumbersName: [String]
    @Published var familyMumber: [String]
    @Published var mumbersLetterNum: [Int]
    @Published var pLetter: [peopleLetter]
    
    init() {
        mumbersObjectId = []
        mumbersName = []
        familyMumber = ["我","爸爸","妈妈","爷爷","奶奶","外婆","外公","孙子","孙女","舅舅"]
        mumbersLetterNum = []
        pLetter = []
    }
    
    func queryFamilyMumber() {
        // 获取当前用户的Id
        let sendLetterId = LCApplication.default.currentUser?.objectId?.value
        let query = LCQuery(className: "_User")
        var familyTreeId = 0
        // 先查出 当前用户的家庭树ID
        query.whereKey("objectId", .equalTo(sendLetterId!))
        _ = query.getFirst { result in
            switch result {
            case .success(object: let todo):
                // 获取到了
                familyTreeId = (todo.familyTreeId?.intValue)!
                // 查询家庭树下的所有成员objectId
                let query = LCQuery(className: "_User")
                query.whereKey("familyTreeId", .equalTo(familyTreeId))
                _ = query.find { result in
                    switch result {
                    case .success(objects: let mumbers):
                        for Item in mumbers {
                            // 如果是自己，不加入
                            if((Item.objectId?.stringValue!)! != sendLetterId) {
                                self.mumbersObjectId.append((Item.objectId?.stringValue!)!)
                                self.mumbersName.append(self.familyMumber[(Item.familyPosition?.intValue!)!])
                                let query2 = LCQuery(className: "Letter")
                                query2.whereKey("receiveLetterId", .equalTo((Item.objectId?.stringValue!)!))
                                let count = query2.count()
                                self.mumbersLetterNum.append(count.intValue)
                            }
                        }
                        self.queryFamilyMumberLetter()
                        print(self.mumbersName)
                        break
                    case .failure(error: let error):
                        print(error)
                    }
                }
            case .failure(error: let error):
                print(error)
            }
        }
    }
    
    // 查每个家庭成员的所有书信
    func queryFamilyMumberLetter(){
        for i in 0..<mumbersObjectId.count {
            let peLetter = peopleLetter(personObjectId: self.mumbersObjectId[i], personName: self.mumbersName[i], personLetterNum: self.mumbersLetterNum[i], thisLetter: [])
            pLetter.append(peLetter)
        }
        for j in 0..<pLetter.count {
            let myLetterId = pLetter[j].personObjectId
            let query = LCQuery(className: "Letter")
            query.whereKey("receiveLetterId", .equalTo(myLetterId))
            query.whereKey("createdAt", .descending)
            _ = query.find { result in
                switch result {
                case .success(objects: let l):
                    for i in 0..<l.count {
                        // 查出来每封信的Id
                        var mis:everyLetter = everyLetter(letterContent: "", sendName: "", receiveName: "", sendTime: Date())
                        mis.letterContent = (l[i].letterContent?.stringValue!)!
                        let letterId = (l[i].objectId?.stringValue!)!
                        let query = LCQuery(className: "LetterM")
                        query.whereKey("letterObjectId", .equalTo(letterId))
                        _ = query.getFirst { result in
                            switch result {
                            case .success(object: let todo):
                                mis.sendName = (todo.sendName?.stringValue!)!
                                mis.receiveName = (todo.receiveName?.stringValue!)!
                                mis.sendTime = (todo.createdAt?.dateValue!)!
                                self.pLetter[j].thisLetter.append(mis)
                            case .failure(error: let error):
                                print(error)
                            }
                        }
                    }
                    break
                case .failure(error: let error):
                    print(error)
                }
            }
        }
        print(self.pLetter)
    }
}

final class indexLetter:ObservableObject {
    
    @Published var indexL:Int
    
    init() {
        indexL = -1
    }
    
}


struct LetterView: View {
    @State var name : String = " "
    @State var content : String = " "
    @State var yourName : String = " "
    @State var date : String = " "
    @State var namefirst : String=""
    @State var nameSecond : String=""
    @State var isLetterSelected : Bool = false
    
    @ObservedObject var familyLetterMumber:LLMumber
    @ObservedObject var myLetter:MyLetter
    @ObservedObject var indexLe:indexLetter = indexLetter()
    
    var body: some View{

        NavigationView {
            ZStack {
                VStack {
            // 上层导航栏
            UpperNavigationBar()
            Divider()
            // 滚动视图
            ScrollView(.vertical) {
                    VStack{
                        VStack{
//                            Button(action: {
//                                print("myLetter123num\(self.myLetter.letterNum)")
//                            }) {
//                                Text("test")
//                            }
//
//                            Button(action: {
//                                print("myLetter Content1\(self.myLetter.letters[0])")
//                                print("myLetter Content2\(self.myLetter.letters[1])")
//                                print("myLetter Content3\(self.myLetter.letters[2])")
//                            }) {
//                                Text("test2")
//                            }
//                            Button(action: {
//                                print("########################################")
//                                print("myFamily mumberId\(self.familyLetterMumber.mumbersObjectId)")
//                                print("myFamily mumberName\(self.familyLetterMumber.mumbersName)")
//                                print("myFamily mumberLetterNumber\(self.familyLetterMumber.mumbersLetterNum)")
//                                print("****************************************")
//                                for i in 0..<self.familyLetterMumber.pLetter.count {
//                                    print(i)
//                                    print("\(self.familyLetterMumber.pLetter[i])")
//                                    print("这个人是\(self.familyLetterMumber.mumbersName[i])")
//                                    print("这个人收到的家书数量\(self.familyLetterMumber.pLetter[i].thisLetter.count)")
//                                }
//                            }) {
//                                Text("测试返回家庭成员信息")
//                            }
//
//                            Button(action: {
//                                print("\(familyLetterMumber.pLetter[1])")
//                            }) {
//                                Text("测试当前块")
//                            }
                            if(familyLetterMumber.pLetter.count > 0) {
                                ForEach(0..<familyLetterMumber.pLetter.count, id:\.self) { i in
                                    if(familyLetterMumber.pLetter[i].thisLetter.count >= 3 ) {
                                        ThreeBlockView(name:$familyLetterMumber.mumbersName[i],letter_1: $familyLetterMumber.pLetter[i])
                                    } else if (familyLetterMumber.pLetter[i].thisLetter.count > 0 && familyLetterMumber.pLetter[i].thisLetter.count < 3) {
                                        OneBlockView(name:$familyLetterMumber.mumbersName[i],letter_1: $familyLetterMumber.pLetter[i])
                                        }
                                    }
                                }
                            }
                        HStack {
                            Rectangle()
                                .foregroundColor(orangeColor)
                                .frame(width: 2, height: 21)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                            Text("我收到的家书")
                                .font(.system(size: 19))
                                .foregroundColor(grayColor)
                            Spacer()
                            Text("更多")
                                .font(.system(size: 15))
                                .foregroundColor(Color(UIColor(red: 0.75, green: 0.75, blue: 0.75,alpha:1)))
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                        }.padding(EdgeInsets(top: 18, leading: 25, bottom: 0, trailing: 30))
                        VStack {
                            HStack {
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 152.0, height: 190.0)
                                            .foregroundColor(orangeColor)
                                        VStack {
                                            HStack {
                                                Text("我的妍大宝")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 15.5))
                                                Spacer()
                                            }
                                            .frame(width: 125, height: 21)
                                                
                                            HStack {
                                                Text("多吃点，不要减肥，晚上 不要出门，要学会照顾自 己，常回家看看，给你做 你爱吃的红烧带鱼~🤗")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 11))
                                                    .frame(width: 125, height: 85,alignment: .topLeading)
                                                    .lineSpacing(10.5)
                                            }.frame(height: 100)
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 0))
                                            VStack {
                                                HStack {
                                                    Text("爱你的妈妈")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 13))
                                                        .frame(width: 70,alignment: .trailing)
                                                }.frame(width: 120,height: 21, alignment: .trailing)
                                                HStack {
                                                    Text("2021.07.05")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 8))
                                                }
                                                .frame(width: 120,height: 21, alignment: .trailing)
                                                .padding(EdgeInsets(top: -13, leading: 0, bottom: 0, trailing: 0))
                                            }.padding(EdgeInsets(top: 5, leading: 0, bottom: -5, trailing: 0))
                                            
                                        }.onTapGesture {
                                            isLetterSelected = true
                                            name = "我的妍大宝"
                                            content = "多吃点，不要减肥，晚上 不要出门，要学会照顾自 己，常回家看看，给你做 你爱吃的红烧带鱼~🤗"
                                            yourName = "爱你的妈妈"
                                            namefirst = "智妍"
                                            nameSecond = "艳丽"
                                            date = "2021.07.05"
                                            familyLetterMumber.queryFamilyMumber()
                                        }
                                    }
                                }.frame(width: 152.0, height: 190.0)
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 152.0, height: 137.0)
                                            .foregroundColor(.white)
                                            .shadow(color: shadowColor, radius: 8)
                                        VStack {
                                            HStack {
                                                Text("笨姐姐")
                                                    .foregroundColor(grayColor)
                                                    .font(.system(size: 15.5))
                                                Spacer()
                                            }
                                            .frame(width: 125, height: 21)
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0.1, trailing: 0))

                                            HStack {
                                                Text("😶记得把早饭吃了我去游泳了。都8:30了还不起床")
                                                    .frame(width: 119, height: 60,alignment: .topLeading)
                                                    .lineSpacing(10.5)
                                                    .font(.system(size: 11))
                                                    .foregroundColor(grayColor)
                                            }
                                            .frame(width: 119)
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: -20, trailing: 0))
                                               
                                            VStack {
                                                HStack {
                                                    Spacer()
                                                    Text("老弟")
                                                        .foregroundColor(grayColor)
                                                        .font(.system(size: 13))
                                                        .frame(width: 70,alignment: .trailing)
                                                }
                                                .frame(width: 120,height: 21)
                                                
                                                HStack {
                                                    Spacer()
                                                    Text("2021.07.05")
                                                        .foregroundColor(Color(UIColor(red: 0.55, green: 0.55, blue: 0.55,alpha:1)))
                                                        .font(.system(size: 8))
                                                        .frame(alignment: .trailing)
                                                }
                                                .frame(width: 120)
                                                
                                            }
                                        }
                                        .onTapGesture {
                                            isLetterSelected = true
                                            name = "笨姐姐"
                                            content = "😶记得把早饭吃了我去游泳了。都8:30了还不起床"
                                            yourName = "爱你的弟弟"
                                            namefirst = "智妍"
                                            nameSecond = "广宇"
                                            date = "2021.06.05"
                                        }
                                    }
                                }
                                .frame(width: 152.0, height: 137)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 53, trailing: 0))
                            }
                           
                            HStack {
                                ZStack {
                            
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 152.0, height: 104.0)
                                            .foregroundColor(.white)
                                            .padding(EdgeInsets(top: 53, leading: 0, bottom: 0, trailing: 0))
                                            .shadow(color: shadowColor, radius: 8)
                        
                                    VStack {
                                        VStack {
                                            HStack {
                                                Text("小女")
                                                    .foregroundColor(grayColor)
                                                    .font(.system(size: 15.5))
                                                    .frame(alignment: .leading)
                                            }
                                            .frame(width: 125, height: 21, alignment: .leading)
                                            .padding(EdgeInsets(top: 15, leading: 7, bottom: 0, trailing: 0))
                                            
                                            HStack {
                                                Text("在外学习，不要恋家。在外学在外学习，不要恋家。")
                                                    .lineSpacing(5)
                                                    .font(.system(size: 11))
                                                    .foregroundColor(grayColor)
                                                    .frame(width: 119, height: 25,alignment: .topLeading)
                                            }
                                            .frame(width: 119, height: 60, alignment: .topLeading)
                                            .padding(EdgeInsets(top: 2,leading: 0, bottom: -5, trailing: 0))
                                            
                                            HStack {
                                                Text("爸爸")
                                                    .foregroundColor(grayColor)
                                                    .font(.system(size: 13))
                                                    .frame(width: 70,height:21,alignment: .trailing)
                                            }
                                            .padding(EdgeInsets(top: -39, leading: 0, bottom: 0, trailing: 0))
                                            .frame(width: 110,alignment: .trailing)
                                            HStack {
                                                Text("2021.07.05")
                                                    .foregroundColor(Color(UIColor(red: 0.55, green: 0.55, blue: 0.55,alpha:1)))
                                                    .font(.system(size: 8))
                                                    .frame(alignment: .trailing)
                                            }.frame(width: 110,alignment: .trailing)
                                            .padding(EdgeInsets(top: -26, leading: 0, bottom: 0, trailing: 0))
                                        }
                                        .frame(width: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: -60, trailing: 0))
                        
                                    }
                                }
                                .frame(width: 152)
                               
                                PencilBoxVeiw()
                                
                            }.padding(EdgeInsets(top: -50, leading: 0, bottom: 0, trailing: 0))
                        }
                        .frame(height: 294 )
                    }

                    Spacer().frame(height:25)
                    
                    // 第二块
                    
                    VStack {
                        HStack {
                            Rectangle()
                                .foregroundColor(orangeColor)
                                .frame(width: 2, height: 21)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                            Text("爷爷收到的家书")
                                .font(.system(size: 19))
                                .foregroundColor(grayColor)
                            Spacer()
                            Text("更多")
                                .font(.system(size: 15))
                                .foregroundColor(Color(UIColor(red: 0.75, green: 0.75, blue: 0.75,alpha:1)))
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                        }.padding(EdgeInsets(top: 18, leading: 25, bottom: 0, trailing: 30))
                        
                        VStack {
                            HStack {
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 152.0, height: 190.0)
                                            .foregroundColor(orangeColor)
                                        VStack {
                                            HStack {
                                                Text("爷爷啊")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 15.5))
                                                Spacer()
                                            }
                                            .frame(width: 125, height: 21)
                                                
                                            HStack {
                                                Text("宁可得记得按时吃药啊，🌹你身体需要坚持吃药！还有多和我奶外出走走，必须得加强身体锻炼呀。")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 11))
                                                    .frame(width: 125, height: 85,alignment: .topLeading)
                                                    .lineSpacing(10.5)
                                            }.frame(height: 100)
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 0))
                                            
                                            VStack {
                                                HStack {
                                                    Text("想你的妍妍")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 13))
                                                        .frame(width: 70,alignment: .trailing)
                                                }.frame(width: 120,height: 21, alignment: .trailing)
                                                HStack {
                                                    Text("2021.07.05")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 8))
                                                }
                                                .frame(width: 120,height: 21, alignment: .trailing)
                                                .padding(EdgeInsets(top: -13, leading: 0, bottom: 0, trailing: 0))
                                            }.padding(EdgeInsets(top: 5, leading: 0, bottom: -5, trailing: 0))
                                            
                                        }
                                    }
                                }.frame(width: 152.0, height: 190.0)
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 152.0, height: 137.0)
                                            .foregroundColor(.white)
                                            .shadow(color: shadowColor, radius: 8)
                                        VStack {
                                            HStack {
                                                Text("爷爷听我说")
                                                    .foregroundColor(grayColor)
                                                    .font(.system(size: 15.5))
                                                Spacer()
                                            }
                                            .frame(width: 125, height: 21)
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0.1, trailing: 0))

                                            HStack {
                                                Text("爷爷啊，咱能不能不抽烟了，吸烟有害健康...")
                                                    .frame(width: 119, height: 60,alignment: .topLeading)
                                                    .lineSpacing(10.5)
                                                    .font(.system(size: 11))
                                                    .foregroundColor(grayColor)
                                            }
                                            .frame(width: 119)
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: -20, trailing: 0))
                                               
                                            VStack {
                                                HStack {
                                                    Spacer()
                                                    Text("卑微小老弟")
                                                        .foregroundColor(grayColor)
                                                        .font(.system(size: 13))
                                                        .frame(width: 70,alignment: .trailing)
                                                }
                                                .frame(width: 120,height: 21)
                                                
                                                HStack {
                                                    Spacer()
                                                    Text("2021.07.05")
                                                        .foregroundColor(Color(UIColor(red: 0.55, green: 0.55, blue: 0.55,alpha:1)))
                                                        .font(.system(size: 8))
                                                        .frame(alignment: .trailing)
                                                }
                                                .frame(width: 120)
                                                
                                            }
                                        }
                                    }
                                }
                                .frame(width: 152.0, height: 137)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 53, trailing: 0))
                            }
                           
                            HStack {
                                ZStack {
                            
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 152.0, height: 104.0)
                                            .foregroundColor(.white)
                                            .padding(EdgeInsets(top: 53, leading: 0, bottom: 0, trailing: 0))
                                            .shadow(color: shadowColor, radius: 8)
                        
                                    VStack {
                                        VStack {
                                            HStack {
                                                Text("爹")
                                                    .foregroundColor(grayColor)
                                                    .font(.system(size: 15.5))
                                                    .frame(alignment: .leading)
                                            }
                                            .frame(width: 125, height: 21, alignment: .leading)
                                            .padding(EdgeInsets(top: 15, leading: 7, bottom: 0, trailing: 0))
                                            
                                            HStack {
                                                Text("是不是又去打麻将了？")
                                                    .lineSpacing(5)
                                                    .font(.system(size: 11))
                                                    .foregroundColor(grayColor)
                                                    .frame(width: 119, height: 25,alignment: .topLeading)
                                            }
                                            .frame(width: 119, height: 60, alignment: .topLeading)
                                            .padding(EdgeInsets(top: 2,leading: 0, bottom: -5, trailing: 0))
                                            
                                            HStack {
                                                Text("建民")
                                                    .foregroundColor(grayColor)
                                                    .font(.system(size: 13))
                                                    .frame(width: 70,height:21,alignment: .trailing)
                                            }
                                            .padding(EdgeInsets(top: -39, leading: 0, bottom: 0, trailing: 0))
                                            .frame(width: 110,alignment: .trailing)
                                            HStack {
                                                Text("2021.07.05")
                                                    .foregroundColor(Color(UIColor(red: 0.55, green: 0.55, blue: 0.55,alpha:1)))
                                                    .font(.system(size: 8))
                                                    .frame(alignment: .trailing)
                                            }.frame(width: 110,alignment: .trailing)
                                            .padding(EdgeInsets(top: -26, leading: 0, bottom: 0, trailing: 0))
                                        }
                                        .frame(width: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: -60, trailing: 0))
                        
                                    }
                                }
                                .frame(width: 152)
                                PencilBoxVeiw()
                            }.padding(EdgeInsets(top: -50, leading: 0, bottom: 0, trailing: 0))
                        }
                        .frame(height: 294 )
                    }

                    Spacer().frame(height:25)
                    
                    // 第三块
                    
                    VStack {
                        HStack {
                            Rectangle()
                                .foregroundColor(orangeColor)
                                .frame(width: 2, height: 21)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                            Text("奶奶收到的家书")
                                .font(.system(size: 19))
                                .foregroundColor(grayColor)
                            Spacer()
                            Text("更多")
                                .font(.system(size: 15))
                                .foregroundColor(Color(UIColor(red: 0.75, green: 0.75, blue: 0.75,alpha:1)))
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                        }.padding(EdgeInsets(top: 18, leading: 25, bottom: 0, trailing: 30))
                        
                        VStack {
                            HStack {
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 152.0, height: 190.0)
                                            .foregroundColor(orangeColor)
                                        VStack {
                                            HStack {
                                                Text("吾妻")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 15.5))
                                                Spacer()
                                            }
                                            .frame(width: 125, height: 21)
                                                
                                            HStack {
                                                Text("看今夕思过去，牵手同度三十余，做良母是贤妻，任劳任怨从不计，俩字都括是不易。")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 11))
                                                    .frame(width: 125, height: 85,alignment: .topLeading)
                                                    .lineSpacing(10.5)
                                            }.frame(height: 100)
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 0))
                                            
                                            VStack {
                                                HStack {
                                                    Text("建国")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 13))
                                                        .frame(width: 70,alignment: .trailing)
                                                }.frame(width: 120,height: 21, alignment: .trailing)
                                                HStack {
                                                    Text("2021.07.05")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 8))
                                                }
                                                .frame(width: 120,height: 21, alignment: .trailing)
                                                .padding(EdgeInsets(top: -13, leading: 0, bottom: 0, trailing: 0))
                                            }.padding(EdgeInsets(top: 5, leading: 0, bottom: -5, trailing: 0))
                                            
                                        }
                                    }
                                }.frame(width: 152.0, height: 190.0)
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 152.0, height: 137.0)
                                            .foregroundColor(.white)
                                            .shadow(color: shadowColor, radius: 8)
                                        VStack {
                                            HStack {
                                                Text("亲爱的奶奶")
                                                    .foregroundColor(grayColor)
                                                    .font(.system(size: 15.5))
                                                Spacer()
                                            }
                                            .frame(width: 125, height: 21)
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0.1, trailing: 0))

                                            HStack {
                                                Text("奶奶，你怎么学坏了.....以前打麻将都是我爷爷")
                                                    .frame(width: 119, height: 60,alignment: .topLeading)
                                                    .lineSpacing(10.5)
                                                    .font(.system(size: 11))
                                                    .foregroundColor(grayColor)
                                            }
                                            .frame(width: 119)
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: -20, trailing: 0))
                                               
                                            VStack {
                                                HStack {
                                                    Spacer()
                                                    Text("帅气浩宇")
                                                        .foregroundColor(grayColor)
                                                        .font(.system(size: 13))
                                                        .frame(width: 70,alignment: .trailing)
                                                }
                                                .frame(width: 120,height: 21)
                                                
                                                HStack {
                                                    Spacer()
                                                    Text("2021.07.05")
                                                        .foregroundColor(Color(UIColor(red: 0.55, green: 0.55, blue: 0.55,alpha:1)))
                                                        .font(.system(size: 8))
                                                        .frame(alignment: .trailing)
                                                }
                                                .frame(width: 120)
                                                
                                            }
                                        }
                                    }
                                }
                                .frame(width: 152.0, height: 137)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 53, trailing: 0))
                            }
                           
                            HStack {
                                ZStack {
                            
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 152.0, height: 104.0)
                                            .foregroundColor(.white)
                                            .padding(EdgeInsets(top: 53, leading: 0, bottom: 0, trailing: 0))
                                            .shadow(color: shadowColor, radius: 8)
                        
                                    VStack {
                                        VStack {
                                            HStack {
                                                Text("妈")
                                                    .foregroundColor(grayColor)
                                                    .font(.system(size: 15.5))
                                                    .frame(alignment: .leading)
                                            }
                                            .frame(width: 125, height: 21, alignment: .leading)
                                            .padding(EdgeInsets(top: 15, leading: 7, bottom: 0, trailing: 0))
                                            
                                            HStack {
                                                Text("今天的鸡翅忒好吃！👍")
                                                    .lineSpacing(5)
                                                    .font(.system(size: 11))
                                                    .foregroundColor(grayColor)
                                                    .frame(width: 119, height: 25,alignment: .topLeading)
                                            }
                                            .frame(width: 119, height: 60, alignment: .topLeading)
                                            .padding(EdgeInsets(top: 2,leading: 0, bottom: -5, trailing: 0))
                                            
                                            HStack {
                                                Text("你儿媳")
                                                    .foregroundColor(grayColor)
                                                    .font(.system(size: 13))
                                                    .frame(width: 70,height:21,alignment: .trailing)
                                            }
                                            .padding(EdgeInsets(top: -39, leading: 0, bottom: 0, trailing: 0))
                                            .frame(width: 110,alignment: .trailing)
                                            HStack {
                                                Text("2021.07.05")
                                                    .foregroundColor(Color(UIColor(red: 0.55, green: 0.55, blue: 0.55,alpha:1)))
                                                    .font(.system(size: 8))
                                                    .frame(alignment: .trailing)
                                            }.frame(width: 110,alignment: .trailing)
                                            .padding(EdgeInsets(top: -26, leading: 0, bottom: 0, trailing: 0))
                                        }
                                        .frame(width: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: -60, trailing: 0))
                        
                                    }
                                }
                                .frame(width: 152)
                                PencilBoxVeiw()
                            }.padding(EdgeInsets(top: -50, leading: 0, bottom: 0, trailing: 0))
                        }
                        .frame(height: 294 )
                    }
                
                    Spacer().frame(height:25)
                    
                    // 第四块
                    
                    VStack {
                        HStack {
                            Rectangle()
                                .foregroundColor(orangeColor)
                                .frame(width: 2, height: 21)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                            Text("爸爸收到的家书")
                                .font(.system(size: 19))
                                .foregroundColor(grayColor)
                            Spacer()
                            Text("更多")
                                .font(.system(size: 15))
                                .foregroundColor(Color(UIColor(red: 0.75, green: 0.75, blue: 0.75,alpha:1)))
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                        }.padding(EdgeInsets(top: 18, leading: 25, bottom: 0, trailing: 30))
                        
                        VStack {
                            HStack {
                                ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 152.0, height: 156.0)
                                            .foregroundColor(.white)
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                            .shadow(color: shadowColor, radius: 8)
                        
                                    VStack {
                                        VStack {
                                            HStack {
                                                Text("老爸")
                                                    .foregroundColor(grayColor)
                                                    .font(.system(size: 15.5))
                                                    .frame(alignment: .leading)
                                            }
                                            .frame(width: 125, height: 21, alignment: .leading)
                                            .padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 0))
                                            
                                            HStack {
                                                Text("爸，工作顺利嘛？再过两年我就出来工作啦，给我传授点经验吧😭~")
                                                    .lineSpacing(10.5)
                                                    .font(.system(size: 11))
                                                    .foregroundColor(grayColor)
                                                    .frame(width: 119, height: 70,alignment: .topLeading)
                                            }
                                            .frame(width: 119, height: 60, alignment: .topLeading)
                                            .padding(EdgeInsets(top: 2,leading: 0, bottom: -5, trailing: 0))
                                            
                                            HStack {
                                                Text("小妍妍")
                                                    .foregroundColor(grayColor)
                                                    .font(.system(size: 13))
                                                    .frame(width: 70,height:21,alignment: .trailing)
                                            }
                                            .padding(EdgeInsets(top: 7, leading: 0, bottom: -16, trailing: 0))
                                            .frame(width: 110,alignment: .trailing)
                                            HStack {
                                                Text("2021.07.05")
                                                    .foregroundColor(Color(UIColor(red: 0.55, green: 0.55, blue: 0.55,alpha:1)))
                                                    .font(.system(size: 8))
                                                    .frame(alignment: .trailing)
                                            }.frame(width: 110,alignment: .trailing)
                                            .padding(EdgeInsets(top: 6, leading: 0, bottom: -56, trailing: 0))
                                        }
                                        .frame(width: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 13, trailing: 0))
                        
                                    }
                                }
                                .frame(width: 152)
                                PencilBoxVeiw()
                            }.padding(EdgeInsets(top: -130, leading: 0, bottom: 0, trailing: 0))
                        }
                        .frame(height: 156,alignment: .bottom)
                    }
                    
                    Spacer().frame(height:25)
                    
                    // 第五块
                    
                    VStack {
                        HStack {
                            Rectangle()
                                .foregroundColor(orangeColor)
                                .frame(width: 2, height: 21)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                            Text("妈妈收到的家书")
                                .font(.system(size: 19))
                                .foregroundColor(grayColor)
                            Spacer()
                            Text("更多")
                                .font(.system(size: 15))
                                .foregroundColor(Color(UIColor(red: 0.75, green: 0.75, blue: 0.75,alpha:1)))
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                        }.padding(EdgeInsets(top: 18, leading: 25, bottom: 0, trailing: 30))

                        VStack {
                            HStack {
                                ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 152.0, height: 156.0)
                                            .foregroundColor(.white)
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                            .shadow(color: shadowColor, radius: 8)

                                    VStack {
                                        VStack {
                                            HStack {
                                                Text("美女老妈")
                                                    .foregroundColor(grayColor)
                                                    .font(.system(size: 15.5))
                                                    .frame(alignment: .leading)
                                            }
                                            .frame(width: 125, height: 21, alignment: .leading)
                                            .padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 0))

                                            HStack {
                                                Text("老妈我和我同学今天看到你跳广场舞了😏，哎呦，不错哟~")
                                                    .lineSpacing(10.5)
                                                    .font(.system(size: 11))
                                                    .foregroundColor(grayColor)
                                                    .frame(width: 119, height: 70,alignment: .topLeading)
                                            }
                                            .frame(width: 119, height: 60, alignment: .topLeading)
                                            .padding(EdgeInsets(top: 2,leading: 0, bottom: -5, trailing: 0))

                                            HStack {
                                                Text("你的宝贝儿")
                                                    .foregroundColor(grayColor)
                                                    .font(.system(size: 13))
                                                    .frame(width: 70,height:21,alignment: .trailing)
                                            }
                                            .padding(EdgeInsets(top: 7, leading: 0, bottom: -16, trailing: 0))
                                            .frame(width: 110,alignment: .trailing)
                                            HStack {
                                                Text("2021.07.05")
                                                    .foregroundColor(Color(UIColor(red: 0.55, green: 0.55, blue: 0.55,alpha:1)))
                                                    .font(.system(size: 8))
                                                    .frame(alignment: .trailing)
                                            }.frame(width: 110,alignment: .trailing)
                                            .padding(EdgeInsets(top: 6, leading: 0, bottom: -56, trailing: 0))
                                        }
                                        .frame(width: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 13, trailing: 0))

                                    }
                                }
                                .frame(width: 152)
                                PencilBoxVeiw()
                            }.padding(EdgeInsets(top: -130, leading: 0, bottom: 0, trailing: 0))
                        }
                        .frame(height: 156,alignment: .bottom)
                    }
                      
                    Spacer().frame(height:25)
                    
                       
                    // 第六块
    //                SixBox()
                    }
                  
                }
            }
                if(isLetterSelected == true){
                    DetailLetterView(name:$name,content:$content,yourName:$yourName,date:$date,isLetterSelected: $isLetterSelected,namefirst:$namefirst,nameSecond: $nameSecond)
                }
        }
    }
}

struct UpperNavigationBar: View {
    var body: some View {
        HStack {
            Image("Iconly-Bulk-Setting")
                .resizable()
                .frame(width:23,
                       height:23,
                       alignment:.center)
            Spacer()
            Text("Family letter")
                .foregroundColor(Color("AccentColor"))
                .font(.system(size: 18))
            Spacer()
            Image("message-calendar")
                .resizable()
                .frame(width:23,
                       height:23,
                       alignment:.center)
        }.padding()
    }
}

struct SixBox: View {
    var body: some View {
        VStack {
            HStack {
                Rectangle()
                    .foregroundColor(orangeColor)
                    .frame(width: 2, height: 21)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                Text("妈妈收到的家书")
                    .font(.system(size: 19))
                    .foregroundColor(grayColor)
                Spacer()
                Text("更多")
                    .font(.system(size: 15))
                    .foregroundColor(Color(UIColor(red: 0.75, green: 0.75, blue: 0.75,alpha:1)))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
            }.padding(EdgeInsets(top: 18, leading: 25, bottom: 0, trailing: 30))

            VStack {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 152.0, height: 156.0)
                            .foregroundColor(orangeColor)
                        Image("white pencil")
                            .frame(width: 65.94, height: 65.8, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                }.padding(EdgeInsets(top: -130, leading: 0, bottom: 0, trailing: 0))
                .frame(alignment: .leading)
            }
            .frame(height: 156,alignment: .bottom)
        }
    }
}



struct PencilBox: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 152.0, height: 156.0)
                .foregroundColor(orangeColor)
            Image("white pencil")
                .frame(width: 65.94, height: 65.8, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}

struct PencilBoxVeiw: View {
    var body: some View {
        NavigationLink(destination: WriteLetterView())
        {
            PencilBox()
        }.navigationBarHidden(true)
        .navigationTitle("返回")
    }
}
