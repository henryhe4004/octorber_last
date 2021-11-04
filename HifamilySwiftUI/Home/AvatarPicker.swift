//
//  AvatarPicker.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/10/24.
//



import SwiftUI
import YPImagePicker
import LeanCloud

struct AvatarPicker: View {
    @State private var showYPImagePickerView = true
    @Binding var MyImage : UIImage
    @Binding var url : String
    @State var isNavigationBarHidden = false
    @Binding var isLoading : Bool
    var body: some View {
           VStack {
            
            MediaPicker1( MyImage: $MyImage,url: $url, isLoading: $isLoading)
               
           }
//           .navigationBarTitle("", displayMode: .inline)
//           .navigationBarHidden(self.isNavigationBarHidden)
//           .onAppear {
//               self.isNavigationBarHidden = true
//           }

       }
}

struct MediaPicker1: UIViewControllerRepresentable {
    
    @Binding var MyImage : UIImage
    @Binding var url : String
    @Binding var isLoading : Bool
    func makeUIViewController(context: Context) -> YPImagePicker {
        var config = YPImagePickerConfiguration()
        //是否可以滑动
        config.isScrollToChangeModesEnabled = true
        //是否只能拍摄正方形
        config.onlySquareImagesFromCamera = false
        //默认打开前置摄像头
        config.usesFrontCamera = true
        //相册名
        config.albumName = "Hi family"
        //默认打开为相册
        config.startOnScreen = YPPickerScreen.library
        //展示啥
        config.screens = [.library,.photo,.video]
        //提供裁剪
        config.showsCrop = .rectangle(ratio: 1)
        //图片大小
        config.targetImageSize = YPImageSize.original
        //加功能
        config.overlayView = UIView()
        //是否隐藏状态栏
        config.hidesStatusBar = false
        config.hidesBottomBar = true
        config.bottomMenuItemSelectedTextColour = UIColor(Color("AccentColor"))
        config.bottomMenuItemUnSelectedTextColour = UIColor(Color.white)
        //最大5倍变焦
        config.maxCameraZoomFactor = 5.0
        config.library.defaultMultipleSelection = true
        //图片和视频
        config.library.mediaType = YPlibraryMediaType.photo
        config.library.maxNumberOfItems = 9
        //不要预处理为最近一张图片
        config.library.preSelectItemOnMultipleSelection = false;
        config.library.spacingBetweenItems = 3
        config.library.skipSelectionsGallery = false
        
        config.gallery.hidesRemoveButton = false
        
        
        let picker = YPImagePicker(configuration: config)

        picker.didFinishPicking { [unowned picker] items,  cancelled in
            if cancelled{
                print("用户按了取消按钮")
            }else{
                isLoading = true
            for item in items {
                switch item {
                case let .photo(photo) :
                    do {
                        
                        MyImage =  photo.modifiedImage ??  photo.originalImage
                        let image123 = resizedImage(image: MyImage)
                        let file = LCFile(payload: .data(data: image123!.pngData()!))
                        _ = file.save { result in
                            switch result {
                            case .success:
                                if let value = file.url?.value {
                                    print("文件保存完成。URL: \(value)")
                                    let objectId = LCApplication.default.currentUser?.objectId
                                    url=value
                                    do {
                                        let todo = LCObject(className: "_User", objectId: objectId!)
                                        try todo.set("url", value: value)
                                        todo.save { (result) in
                                            switch result {
                                            case .success:
                                                print("图片保存成功")
                                                break
                                            case .failure(error: let error):
                                                print(error)
                                            }
                                        }
                                    } catch {
                                        print(error)
                                    }
                                }
                            case .failure(error: let error):
                                // 保存失败，可能是文件无法被读取，或者上传过程中出现问题
                                print(error)
                            }
                        }
                        print(photo.image.pngData() as Any)
                    }
                case .video(let video) :
                        print(video)
                }
            }
                
             
            }
            picker.dismiss(animated: true, completion: nil)
        }
    
        return picker
    }
    
    func updateUIViewController(_ uiViewController: YPImagePicker, context: Context) {}
    
    typealias UIViewControllerType = YPImagePicker
    
}


