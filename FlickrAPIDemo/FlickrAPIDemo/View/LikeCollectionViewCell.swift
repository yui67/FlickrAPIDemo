//
//  LikeCollectionViewCell.swift
//  FlickrAPIDemo
//
//  Created by Mr.z on 2021/4/10.
//

import UIKit

class LikeCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var deleteLikeBtnOutlet: UIButton!
    
    //MARK: - Vars
    var photo: LikePhoto?
    
    
    //MARK: - Helper
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
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
    
    
    @IBAction func likeBtn(_ sender: Any) {
        
        NetWork.shared.deleteLike(deleteLikePhoto: photo!) { (deletelike) in
            if deletelike == 1 {
                
                DispatchQueue.main.async {
                    self.deleteLikeBtnOutlet.addTarget(self, action: #selector(self.btnTouchDown), for: .touchDown)
                }
                
                
            } else {
              
                DispatchQueue.main.async {
                    self.deleteLikeBtnOutlet.addTarget(self, action: #selector(self.btntouchUpInside), for: .touchUpInside)
                    
                }
              
            }
        }
        
    }
    
    @objc func btnTouchDown() {
        deleteLikeBtnOutlet.backgroundColor = UIColor.red
        
    }
    
    @objc func btntouchUpInside() {
        deleteLikeBtnOutlet.backgroundColor = UIColor.black
        
    }
    
}
