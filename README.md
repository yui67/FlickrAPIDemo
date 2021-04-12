# FlickrAPIDemo
Flickr MVC示例项目

这是Flickr图像搜索模块的基本示例，它会根据您的关键字搜索任何关键字，然后用滚动显示图像，并且能上拉去加载更新的图片，拖放会重新整理资料，以及我的最爱功能。

在此项目中使用，** UICollectionView **用于显示搜索结果。

功能：●输入搜寻字串●透过API取得搜寻结果●我的最爱

要求
XCode 9.3或更高版本
斯威夫特4.0
Flickr API文档
使用的API：flickr.photos.search●API文件：https://www.flickr.com/services/api/flickr.photos.search.html 
测试页:https://www.flickr.com/services/api/explore/flickr.photos.search

SheetDB API文档
https://sheetdb.io/api/v1/q5xzqpddkdsmm

-搜索路径：

https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=80af738ada85b1e17606e9f5cf9c6d14&format=json&nojsoncallback=1&per_page=?&text=?&page=?"

struct Photo: Codable {
    let farm: Int
    let secret: String
    let id: String
    let server: String
    let title: String
    var imageUrl: URL {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
    }
    
}
