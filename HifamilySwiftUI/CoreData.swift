//
//  CoreData.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/22.
//


import SwiftUI
import CoreData

struct CoreData: View {
    @State var amendName: String = ""
    //我们可以要求它提供当前托管对象内容，并将其分配给一个属性供我们使用
    @Environment(\.managedObjectContext) private var viewContext
    //获取数据库中的数据
    //sortDescriptors属性，这是个数组,按照名称排序
    @FetchRequest(entity: FamilyModel.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(keyPath: \FamilyModel.familyName, ascending: true)],
                  animation:.default)
    var familyModels: FetchedResults<FamilyModel>
    
    let nameArray:[String] = ["暖暖","幸福一家","快乐家族"]
    
    var body: some View {
      
        VStack{
            //增加
            Button("添加"){
                //这里我们等会添加按钮的功能
                //随机获取姓名
                let chosenName = nameArray.randomElement()!
              

                //给数据库写入数据
                let familyModel = FamilyModel(context: self.viewContext)
                familyModel.familyId = UUID()
                familyModel.familyName = "\(chosenName)"
                             //保存当前数据
                try? self.viewContext.save()
                
            }
            //查看
            List{
                //显示Core Data数据库内容的列表
                //将数据库的familyName输出
                //改回来
                ForEach(familyModels, id: \.familyId) { familyModel in
                    Text(familyModel.familyName!)
                                }
                .onDelete(perform: deleteFamily)
            }
            
            //修改
            TextField("修改的内容",text: $amendName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            
            Button("修改"){
                let name2 = amendName
                let familyModel = FamilyModel(context: self.viewContext)
                familyModel.familyId = UUID()
                familyModel.familyName = "\(name2)"
                
                try? self.viewContext.save()
                
                
            }
            //查看
            List{
                //显示Core Data数据库内容的列表
                //将数据库的familyName输出
                //改回来
                ForEach(familyModels, id: \.familyId) { familyModel in
                    Text(familyModel.familyName!)
                                }
                .onDelete(perform: deleteFamily)
            }
            
            
        }
       
    }
    
    //删除的代码
    private func deleteFamily(offsets: IndexSet) {
           withAnimation {
               offsets.map { familyModels[$0] }.forEach(viewContext.delete)

               do {
                   try viewContext.save()
               } catch {
                   // Replace this implementation with code to handle the error appropriately.
                   // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                   let nsError = error as NSError
                   fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
               }
           }
       }

}

struct CoreData_Previews: PreviewProvider {
    static var previews: some View {
        CoreData()
    }
}

