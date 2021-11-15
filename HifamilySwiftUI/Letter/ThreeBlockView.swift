//
//  ThreeBlockView.swift
//  HifamilySwiftUI
//
//  Created by 吴柏辉 on 2021/10/28.
//

import SwiftUI

struct ThreeBlockView: View {
    
//    @ObservedObject var familyLetterMumber:LLMumber
//    @ObservedObject var indexLe:indexLetter
    @Binding var name:String
    @Binding var letter_1:peopleLetter
    
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
                                    Text("\(letter_1.thisLetter[0].receiveName)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15.5))
                                    Spacer()
                                }
                                .frame(width: 125, height: 21)
                                    
                                HStack {
                                    Text("\(letter_1.thisLetter[0].letterContent)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 11))
                                        .frame(width: 125, height: 85,alignment: .topLeading)
                                        .lineSpacing(10.5)
                                }.frame(height: 100)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 0))
                                VStack {
                                    HStack {
                                        Text("\(letter_1.thisLetter[0].sendName)")
                                            .foregroundColor(.white)
                                            .font(.system(size: 13))
                                            .frame(width: 70,alignment: .trailing)
                                    }.frame(width: 120,height: 21, alignment: .trailing)
                                    HStack {
                                        Text("\(letter_1.thisLetter[0].sendTime.formatted(.iso8601.month().day().year().dateSeparator(.dash)))")
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
                                    Text("\(letter_1.thisLetter[1].receiveName)")
                                        .foregroundColor(grayColor)
                                        .font(.system(size: 15.5))
                                    Spacer()
                                }
                                .frame(width: 125, height: 21)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0.1, trailing: 0))

                                HStack {
                                    Text("\(letter_1.thisLetter[1].letterContent)")
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
                                        Text("\(letter_1.thisLetter[1].sendName)老弟")
                                            .foregroundColor(grayColor)
                                            .font(.system(size: 13))
                                            .frame(width: 70,alignment: .trailing)
                                    }
                                    .frame(width: 120,height: 21)
                                    
                                    HStack {
                                        Spacer()
                                        Text("\(letter_1.thisLetter[1].sendTime.formatted(.iso8601.month().day().year().dateSeparator(.dash)))")
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
                                    Text("\(letter_1.thisLetter[2].receiveName)")
                                        .foregroundColor(grayColor)
                                        .font(.system(size: 15.5))
                                        .frame(alignment: .leading)
                                }
                                .frame(width: 125, height: 21, alignment: .leading)
                                .padding(EdgeInsets(top: 15, leading: 7, bottom: 0, trailing: 0))
                                
                                HStack {
                                    Text("\(letter_1.thisLetter[2].letterContent)")
                                        .lineSpacing(5)
                                        .font(.system(size: 11))
                                        .foregroundColor(grayColor)
                                        .frame(width: 119, height: 25,alignment: .topLeading)
                                }
                                .frame(width: 119, height: 60, alignment: .topLeading)
                                .padding(EdgeInsets(top: 2,leading: 0, bottom: -5, trailing: 0))
                                
                                HStack {
                                    Text("\(letter_1.thisLetter[2].sendName)")
                                        .foregroundColor(grayColor)
                                        .font(.system(size: 13))
                                        .frame(width: 70,height:21,alignment: .trailing)
                                }
                                .padding(EdgeInsets(top: -39, leading: 0, bottom: 0, trailing: 0))
                                .frame(width: 110,alignment: .trailing)
                                HStack {
                                    Text("\(letter_1.thisLetter[2].sendTime.formatted(.iso8601.month().day().year().dateSeparator(.dash)))")
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
    }
}

//struct ThreeBlockView_Previews: PreviewProvider {
//    static var previews: some View {
//        ThreeBlockView()
//    }
//}
