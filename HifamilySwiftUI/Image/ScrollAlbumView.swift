//import SwiftUI
//
//struct ScrollAlbumView : View{
//    @State private var items: [Item] = []
//    @State private var headerRefreshing: Bool = false
//    @State private var footerRefreshing: Bool = false
//    @State private var listState = ListState()
//
//    var body: some View {
//        NavigationView {
//            pullToRefreshScrollBody
//                .navigationTitle("Refresh Demo")
//                .navigationBarTitleDisplayMode(.inline)
//                .onAppear(perform: loadData)
//        }
//    }
//
//    var pullToRefreshScrollBody: some View {
//        headerFooterRefresh
//    //        headerRefresh
//    //        footerRefresh
//    }
//
//    // 只对头部进行数据下拉刷新
//    var headerRefresh: some View {
//        ScrollView {
//            PullToRefreshView(header: RefreshDefaultHeader()) {
//
//            }.environmentObject(listState)
//        }
//        .addPullToRefresh(isHeaderRefreshing: $headerRefreshing, onHeaderRefresh: reloadData)
//    }
//    // 只对尾部进行数据上拉加载
//    var footerRefresh: some View {
//        ScrollView {
//            PullToRefreshView(footer: RefreshDefaultFooter()) {
//
//            }.environmentObject(listState)
//        }
//        .addPullToRefresh(isFooterRefreshing: $footerRefreshing, onFooterRefresh: loadMoreData)
//    }
//    // 下拉刷新、上拉加载
//    var headerFooterRefresh: some View {
//        ScrollView {
//            PullToRefreshView(header: RefreshDefaultHeader(), footer: RefreshDefaultFooter()) {
//
//            }.environmentObject(listState)
//        }
//        .addPullToRefresh(isHeaderRefreshing: $headerRefreshing, onHeaderRefresh: reloadData,
//                          isFooterRefreshing: $footerRefreshing, onFooterRefresh: loadMoreData)
//    }

//    private func loadData() {
//        var tempItems: [Item] = []
//        for index in 0..<10 {
//            if index >= itemsData.count {
//                // 如果已经没有数据，则终止添加
//                listState.setNoMore(true)
//                break
//            }
//            let item = itemsData[index]
//            
//            tempItems.append(item)
//        }
//        self.items = tempItems
//    }
//
//    private func reloadData() {
//        print("begin refresh data ...\(headerRefreshing)")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            loadData()
//            headerRefreshing = false
//            print("end refresh data ...\(headerRefreshing)")
//        }
//    }
//
//    private func loadMoreData() {
//        print("begin load more data ... \(footerRefreshing)")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            let startIndex = items.count
//            for index in 0..<10 {
//                let finalIndex = startIndex + index
//                if finalIndex >= itemsData.count {
//                    // 如果已经没有数据，则终止添加
//                    listState.setNoMore(true)
//                    break
//                }
//                let item = itemsData[finalIndex]
//                
//                self.items.append(item)
//            }
//            footerRefreshing = false
//            print("end load more data ... \(footerRefreshing)")
//        }
//    }
//}
