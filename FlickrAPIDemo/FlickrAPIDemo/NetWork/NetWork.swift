//
//  NetWork.swift
//  FlickrAPIDemo
//
//  Created by Mr.z on 2021/4/8.
//


import UIKit
import Foundation

class NetWork {
    
    let imageCache = NSCache<NSURL, UIImage>()
    let flickrKey = "80af738ada85b1e17606e9f5cf9c6d14"
    static let shared = NetWork()
    
    func fetchData(pageCount inpageCount: String, text inText: String, page inPage: Int, handler: @escaping(SearchData) -> Void) {
        let url = getURL_Path(inpageCount, text: inText, page: inPage)
        var req = URLRequest(url: url!)
        req.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: req) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else if let response = response, let data = data {
                print("response: \(response)")
                let decoder = try! JSONDecoder().decode(SearchData.self, from: data)
                handler(decoder)
                
            }
        }.resume()
    }
    
    let url = URL(string: "//www.flickr.com/services/rest/？method = flickr.photos.search＆api_key =＆text =＆per_page =＆page =＆format = json＆nojsoncallback = 1＆api_sig = 1c65da3515aafb9c151018dd4472994d")
    
    func getURL_Path(_ pageCount: String, text: String,page:Int) -> URL?{
        //處理中文字串
        let newText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let urlPath = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(flickrKey)&format=json&nojsoncallback=1&per_page=\(pageCount)&text=\(newText)&page=\(page)")
        
        else {
            return nil
        }
        return urlPath
    }
    
    //添加最愛
    func addLike(Photo inPhoto: Photo, handler: @escaping (Int) -> Void) {
        struct keyvalue: Codable {
            let data: Photo
        }
        let url = URL(string: "https://sheetdb.io/api/v1/q5xzqpddkdsmm")
        var req = URLRequest(url: url!)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(keyvalue(data: inPhoto))
        URLSession.shared.dataTask(with: req) { (data, response, error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else if let response = response, let data = data {
                print("response: \(response)")
                if let decoder = try? JSONDecoder().decode([String:Int].self, from: data){
                    if decoder["created"] == 1 {
                        handler(1)
                    } else {
                        handler(0)
                    }
                }
            }
        }.resume()
        
    }
    
    //讀取最愛
    func getLike(handler: @escaping ([LikePhoto]) -> Void) {
        
        let url = URL(string: "https://sheetdb.io/api/v1/q5xzqpddkdsmm")
        var req = URLRequest(url: url!)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: req) { (data, response, error) in
            if let error = error {
                print("error : \(error.localizedDescription)")
            }else if let response = response, let data = data {
                print("response: \(response)")
                _ = try? JSONDecoder().decode([LikePhoto].self, from: data)
                if let decoder = try? JSONDecoder().decode([LikePhoto].self, from: data) {
                    handler(decoder)
                }
            }
        }.resume()
    }
    
    //刪除喜歡
    func deleteLike(deleteLikePhoto inLikePhoto: LikePhoto, handler: @escaping (Int) -> Void) {
        let url = URL(string: "https://sheetdb.io/api/v1/q5xzqpddkdsmm/id/\(inLikePhoto.id)")
        var req = URLRequest(url: url!)
        req.httpMethod = "DELETE"
        req.setValue("applecation/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(inLikePhoto.id)
        URLSession.shared.dataTask(with: req) { (data, response, error) in
            if let error = error {
                print("error : \(error.localizedDescription)")
            }else if let response = response, let data = data {
                print("response: \(response)")
                let decoder = try? JSONDecoder().decode([String:Int].self, from: data)
                if decoder?["delete"] == 1 {
                    handler(1)
                }else {
                    handler(0)
                }
                
            }
        }.resume()
    }
    
}


