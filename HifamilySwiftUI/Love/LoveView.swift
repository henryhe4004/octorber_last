//
//  LoveView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/14.
//

import SwiftUI


struct NavigationConfigurator : UIViewControllerRepresentable{
    var configure:(UINavigationController) -> Void = { _ in }
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>)->UIViewController{
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>){
    if let nc = uiViewController.navigationController{
    self.configure(nc)
    }
    }
}
struct MyButtonStyle : ButtonStyle{
    func makeBody(configuration: Configuration) -> some View{
        configuration.label
            .frame(width: 62, height: 20, alignment: .center)
            .padding()
            .cornerRadius(32.0)
//            .shadow(color: .gray, radius: 3, x: 0, y: 3)
            .overlay(RoundedRectangle(cornerRadius: 32.0, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 1.4)).shadow(radius: 1)
        


    }
}

    final class Family: ObservableObject {
        @Published  var person: [String]
        @Published var num: [Int]
    
        init() {
            person = ["爸爸","妈妈","爷爷","奶奶"]
            num = [1,4,5,7]
        }
        func addPeople(person1 : String) {
            person.append(person1)
        }

        func addNum(number: Int) {
            num.append(number)
        }
    }



struct LoveView: View {
    
    var items : [GridItem] = [
        GridItem(GridItem.Size.flexible(),spacing: 5),
        GridItem(GridItem.Size.flexible(),spacing: 5),
        GridItem(GridItem.Size.flexible(),spacing: 5)
    ]
    @ObservedObject var family:Family = Family()
    let imgsLove = ["big love","Like","love2"]
    @State var who = -1
    @State var isSelected = false
    @State  private var indexLove = 2
    @State private var presenting = false
    @State private var presenting_1 = false
    @State private var present = false
    @State var missSetting : Bool = false
    @State var loveHistory : Bool = false
    @State  var num = 5
    var body: some View {
        
            
                VStack{
                HStack {
                    Image("three line")
                        .resizable()
                        .frame(width:23,
                               height:23,
                               alignment:.center)
                    Spacer()
                    Text("Miss family")
                        .foregroundColor(Color("AccentColor"))
                    
                    Spacer()
                    Image("person")
                        .resizable()
                        .frame(width:23,
                               height:23,
                               alignment:.center)
                }.padding()
                
                Divider()
            ZStack {
                ScrollView(.vertical, showsIndicators: false)
                {
                HStack{
                    VStack(alignment: .leading){
                        Text("选择思念对象")   .font(.system(size: 20))
                    }
                    Spacer()
                }.padding()
                    
                    LazyVGrid(columns: items, content: {
                        ForEach(0..<family.person.count){
                            index in
                            Button(action: {
                                if(isSelected == false ){
                                    if( who == -1 ){
                                        isSelected = true
                                        who = index
//                                                        truePerson[0] = 1
                                    }
                                }else {
                                    if(who == index){
                                        isSelected = false
                                        who = -1
                                    }else{
                                        who = index
                                    }
                                    
                                }
                                                }){
                                
                                VStack {
                                    Text(family.person[index])
                                                            .frame(width: 62, height: 20, alignment: .center)
                                                            .cornerRadius(32)
                                        .foregroundColor(who == index ? .white : grayColor )
                                }
                            
                                        }
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .animation(.easeInOut)
//                                                .buttonStyle(MyButtonStyle())
                       
                                                .background( who == index ? LinearGradient(gradient: Gradient(colors: [Color.init(red : 255/255,green: 144/255,blue: 13/255), Color.init(red: 255/255, green: 169/255, blue: 54/255)]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(gradient: Gradient(colors: [Color.white, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)).cornerRadius(15)
                            .shadow(color: Color("AccentColor"), radius: 3, x: 0.5, y: 0.5)
//                            .overlay(RoundedRectangle(cornerRadius: 15.0, style: .continuous).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 2.0))
                                                .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                                                
                           
                        }
                    })
            
                
                HStack{
                    VStack(alignment: .leading, spacing: nil, content: {
                        Text("点击爱心进行思念")   .font(.system(size: 20))
                    }).padding()
                    Spacer()
                    
                }
                
                HStack{
                    if(isSelected){
                    if(num>0){
                    Button(action: {
                        num=num-1;
                        self.present.toggle()
                    }){
                        HStack {
                            Image(imgsLove[indexLove])
                           
                            .animation(.interpolatingSpring(stiffness: 50, damping: 3))
    //                        .padding()
                                .scaledToFit()
                        }     .frame(width: 400, height: 220, alignment: .center)
                    }
                    .alert(isPresented: $present, content: {
                        Alert(title: Text("向\(family.person[who])寄出你的思念成功，消耗一张思念卷，你还剩下\(num)思念卷"))
                    })
                
                    }
                    else{
                        Button(action: {
                            
                            self.present.toggle()
                        }){
                            HStack {
                                Image(imgsLove[indexLove])
                       
                                .animation(.interpolatingSpring(stiffness: 50, damping: 3))
                                
                                    .padding()
                            }     .frame(width: 400, height: 220, alignment: .center)
                        }
                        .alert(isPresented: $present, content: {
                            Alert(title: Text("寄出你的思念失败，请领取思念卷"))
                        })
                    }
                    }else{
                        Button(action: {
                            
                            self.present.toggle()
                        }){
                            HStack{
                                Image(imgsLove[indexLove])

                                    .animation(.spring(dampingFraction: 0.1))
//                            .animation(.default)
//                           .animation(.interpolatingSpring(stiffness: 50, damping: 3))
                            .padding()
                            }
                            .frame(width: 400, height: 220, alignment: .center)
//                            .border(Color.black)
                        }
                        .alert(isPresented: $present, content: {
                            Alert(title: Text("没有思念对象哦！请选择思念对象"))
                        })
                    }
                }
                HStack{
                    VStack{
                        if(presenting_1 == false){
                        Button(action: {
                            if(presenting_1 == false){
                                num=num+5;
                            }
                            self.presenting.toggle()
                            presenting_1 = true
                            
                        })
                        {
                            HStack{
                                VStack {
                                    Image("second tag")
                                        .foregroundColor(Color("AccentColor"))
                                }
                                .frame(width: 40, height: 40, alignment: .center)
                                .cornerRadius(20.0)
                                .background(Color.white)
                                .overlay(Capsule(style: .continuous).stroke( lineWidth: 1)
                                )
                                Text("思念卷x\(num)")
                                    .foregroundColor(.black)
                                
                                
                            }
                            Spacer()
                        }.padding(EdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 10))
                        .alert(isPresented: $presenting, content: {
                            Alert(title: Text("今日领取5张思念券成功"))
                        })
                        }
                        else{
                        Button(action: {
                            self.presenting.toggle()
                            
                        })
                        {
                            HStack{
                                VStack {
                                    Image("second tag")
                                        .foregroundColor(Color("AccentColor"))
                                }
                                .frame(width: 40, height: 40, alignment: .center)
                                .cornerRadius(20.0)
                                .background(Color.white)
                                .overlay(Capsule(style: .continuous).stroke( lineWidth: 1)
                                )
                                Text("思念卷x\(num)")
                                    .foregroundColor(.black)
                             
                                
                            }
                            Spacer()
                        }.padding(EdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 10))
                        .alert(isPresented: $presenting, content: {
                            Alert(title: Text("今日已经领取5张思念券，请明天再来领取"))
                        })
                        }
                    
                        VStack{
                            Button(action: {
                                if indexLove == 2{
                                    indexLove = 0
                                }else{
                                    indexLove = indexLove + 1
                                }
                            })
                            {
                                HStack{
                                    VStack {
                                        Image("second loop arrow")
                                            .foregroundColor(Color("AccentColor"))
                                    }.padding(8)
                                    .frame(width: 40, height: 40, alignment: .center)
                                    .cornerRadius(20.0)
                                    .background(Color.white)
                                    .overlay(Capsule(style: .continuous).stroke( lineWidth: 1)
                                    )
                                    VStack{
                                        Text("切换爱心")
                                            .foregroundColor(.black)
                                    }
                                }
                                Spacer()
                            }.padding(EdgeInsets(top: 5, leading: 20, bottom: 30, trailing: 10))
                           
                        }
                    }
                    
                }
                VStack{
                    HStack{
                        Text("我收到的今日思念")
                            .font(.system(size: 20))
                        Spacer()
                    }.padding(EdgeInsets(top: 10, leading: 20, bottom: 5, trailing: 10))
                    HStack{
                        Text("爷爷向你寄送了两份思念")
                            .foregroundColor(.gray)
                            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 10))
                        Image("new")
                        Spacer()
                        Text("AM09:41").foregroundColor(.gray)
                            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                    }
                    Divider().padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
                    HStack{
                        Text("妈妈亲了你一下，送了一份思念")
                            .foregroundColor(.gray)
                            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 10))
                        Spacer()
                        Text("AM08:45").foregroundColor(.gray)
                            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                    }
                    Divider().padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
                    
                }
                HStack{
                    VStack{
                        Button(action: {
                            self.loveHistory=true
                        })
                        {
                            HStack{
                                VStack {
                                    Image("eye")
                                        .foregroundColor(Color("AccentColor"))
                                }
                                .frame(width: 40, height: 40, alignment: .center)
                                .cornerRadius(20.0)
                                .background(Color.white)
                                .overlay(Capsule(style: .continuous).stroke( lineWidth: 1)
                                )
                                Text("查看历史思念")
                                    .foregroundColor(.black)
                                
                            }
                            Spacer()
                        }.padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 10))
                        VStack{
                            Button(action: {
                                self.missSetting = true
                            })
                            {
                                HStack{
                                    VStack {
                                        Image("setting")
                                            .foregroundColor(Color("AccentColor"))
                                    }.padding(8)
                                    .frame(width: 40, height: 40, alignment: .center)
                                    .cornerRadius(20.0)
                                    .background(Color.white)
                                    .overlay(Capsule(style: .continuous).stroke( lineWidth: 1)
                                    )
                                    VStack{
                                        Text("设置思念语句")
                                            .foregroundColor(.black)
                                    }
                                }
                                Spacer()
                            }.padding(EdgeInsets(top: 5, leading: 20, bottom: 30, trailing: 10))
                           
                        }
                    }
                    
                }
                
                }.frame(minWidth: 0/*@END_MENU_TOKEN@*/,  maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,  maxHeight: /*@START_MENU_TOKEN@*/.infinity, alignment: .topLeading)
                if(missSetting){
                    ZStack{
                        Rectangle().fill(Color.gray).opacity(0.5)
                    VStack{
                        MissView( missSetting : $missSetting)
                    }
                    }
                }
                
                if(loveHistory){
                    ZStack{
                        Rectangle().fill(Color.gray).opacity(0.5)
                    VStack{
                        LoveHistoryView( loveHistory : $loveHistory)
                    }
                    }
                }
            }
    
        }
    }
    
}


struct LoveView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoveView()
          
        }
    }
}
