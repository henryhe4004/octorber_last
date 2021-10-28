//
//  ThreeBlockView.swift
//  HifamilySwiftUI
//
//  Created by 吴柏辉 on 2021/10/28.
//

import SwiftUI

struct ThreeBlockView: View {
    var body: some View {
        VStack {
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
    }
}

struct ThreeBlockView_Previews: PreviewProvider {
    static var previews: some View {
        ThreeBlockView()
    }
}
