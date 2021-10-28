//
//  OneBlockView.swift
//  HifamilySwiftUI
//
//  Created by 吴柏辉 on 2021/10/28.
//

import SwiftUI

struct OneBlockView: View {
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
    }
}

struct OneBlockView_Previews: PreviewProvider {
    static var previews: some View {
        OneBlockView()
    }
}
