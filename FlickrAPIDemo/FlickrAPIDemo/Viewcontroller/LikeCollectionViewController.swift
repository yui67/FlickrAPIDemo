//
//  LikeCollectionViewController.swift
//  FlickrAPIDemo
//
//  Created by Mr.z on 2021/4/10.
//

import UIKit

private let reuseIdentifier = "Cell"

class LikeCollectionViewController: UICollectionViewController {
    
    var photoData = [LikePhoto]()
    var userdefaults = UserDefaults.standard
    var containarView : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let itemSpace: CGFloat = 2
        let columnCount: CGFloat = 2
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let width = floor((collectionView.bounds.width  - itemSpace * (columnCount)) / columnCount)
        print("width",width, collectionView.bounds)
        flowLayout?.itemSize = CGSize(width: width, height: width)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumInteritemSpacing = itemSpace
        flowLayout?.minimumLineSpacing = itemSpace
        flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NetWork.shared.getLike { [weak self] (likePhoto) in
            guard let self = self else { return }
            if likePhoto != nil {
                self.photoData = likePhoto
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photoData.count 
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(LikeCollectionViewCell.self)", for: indexPath) as? LikeCollectionViewCell
        
        cell?.photo = photoData[indexPath.row]
        cell?.update()
        
    
        // Configure the cell
        if let cell = cell {
            return cell
        }else {
            return CollectionViewCell()
        }
        
    }

   
}
