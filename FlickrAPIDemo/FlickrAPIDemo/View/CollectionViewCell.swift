//
//  CollectionViewCell.swift
//  FlickrAPIDemo
//
//  Created by Mr.z on 2021/4/8.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var likeButOutlet: UIButton!
    
    //MARK: - Vars
    //NSCache 儲存抓過的圖片
    let imageCache = NSCache<NSURL, UIImage>()
    var photo: Photo?
    var photoData = [Photo]()
    var userDefaults = UserDefaults.standard
    
    func fetchImage(url: URL, completion: @escaping ( UIImage?) -> Void) {
        
        if let image = imageCache.object(forKey: url as NSURL) {
            completion(image)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: url as NSURL)
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func update() {
        let id = photo?.id
        textLabel.text = photo?.title ?? "nil"
        imageView.image = UIImage(systemName: "text.below.photo")
        fetchImage(url: photo!.imageUrl) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                if id == self.photo?.id {
                    self.imageView.image = image
                }
            }
        }
    }
    
    
    @IBAction func likePhoto(_ sender: Any) {
        
        NetWork.shared.addLike(Photo: photo!) { [self] (like) in
            
            if like == 1 {
                
                
                DispatchQueue.main.async {
                    self.likeButOutlet.addTarget(self, action: #selector(btnTouchDown), for: .touchDown)
                }
                
                print("成功")
                
            } else {
                
                DispatchQueue.main.async {
                    self.likeButOutlet.addTarget(self, action: #selector(btnTouchInside), for: .touchUpInside)
                }
                
               
                print("失敗")
                
            }
        }
        
    }
    
    @objc func btnTouchDown() {
        likeButOutlet.backgroundColor = UIColor.red
    }
    
    @objc func btnTouchInside() {
        likeButOutlet.backgroundColor = UIColor.black
    }
    
    
    
}
