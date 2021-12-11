//
//  OneBlockView.swift
//  HifamilySwiftUI
//
//  Created by 吴柏辉 on 2021/10/28.
//

import SwiftUI
import LeanCloud



struct OneBlockView: View {
    
    @ObservedObject var moreLetter:MoreLetter
    
//    @ObservedObject var familyLetterMumber:LLMumber
//    @ObservedObject var indexLe:indexLetter
    @Binding var name:String
    @Binding var letter_1:peopleLetter
    @Binding var isLetterSelected : Bool
//    @Binding var isLetterSelected : Bool
    @Binding var name1 : String
    @Binding
//    @State
    var content : String
//        = "多吃点，不要减肥，晚上 不要出门，要学会照顾自 己，常回家看看，给你做 你爱吃的红烧带鱼~🤗"
    @Binding
//    @State
    var yourName : String
//        = "爱你的妈妈"
    @Binding
//    @State
    var date : String
//        = "2021.07.05"
    @Binding
    var namefirst : String
//    
//    @ObservedObject var familyLetterMumber:LLMumber
//    @ObservedObject var myLetter:MyLetter
//    
    var body: some View {
        VStack {
            HStack {
                Rectangle()
                    .foregroundColor(orangeColor)
                    .frame(width: 2, height: 21)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                Text("\(name)收到的家书")
                    .font(.system(size: 19))
                    .foregroundColor(grayColor)
                Spacer()
            
                // 更多
                
                NavigationLink(destination: CardsContainer(moreLetter: moreLetter))
                {
                    Text("更多")
                        .font(.system(size: 15))
                        .foregroundColor(Color(UIColor(red: 0.75, green: 0.75, blue: 0.75,alpha:1)))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                }.navigationBarHidden(true)
                .navigationTitle("返回")
                
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
                                        Text("\(letter_1.thisLetter[0].receiveName)")
                                            .foregroundColor(grayColor)
                                            .font(.system(size: 15.5))
                                            .frame(alignment: .leading)
                                    }
                                    .frame(width: 125, height: 21, alignment: .leading)
                                    .padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 0))
                                    
                                    HStack {
                                        Text("\(letter_1.thisLetter[0].letterContent)")
                                            .lineSpacing(10.5)
                                            .font(.system(size: 11))
                                            .foregroundColor(grayColor)
                                            .frame(width: 119, height: 70,alignment: .topLeading)
                                    }
                                    .frame(width: 119, height: 60, alignment: .topLeading)
                                    .padding(EdgeInsets(top: 2,leading: 0, bottom: -5, trailing: 0))
                                    
                                    HStack {
                                        Text("\(letter_1.thisLetter[0].sendName)")
                                            .foregroundColor(grayColor)
                                            .font(.system(size: 13))
                                            .frame(width: 70,height:21,alignment: .trailing)
                                    }
                                    .padding(EdgeInsets(top: 7, leading: 0, bottom: -16, trailing: 0))
                                    .frame(width: 110,alignment: .trailing)
                                    HStack {
                                        Text("\(letter_1.thisLetter[0].sendTime.formatted(.iso8601.month().day().year().dateSeparator(.dash)))")
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
                .onTapGesture(perform: {
                    isLetterSelected = true
                    name1 = letter_1.thisLetter[0].receiveName
                    content = letter_1.thisLetter[0].letterContent
                    yourName = letter_1.thisLetter[0].sendName
                    date = letter_1.thisLetter[0].sendTime.formatted(.iso8601.month().day().year().dateSeparator(.dash))
                    namefirst = name
                })
        }
    }
}
