//
//  CollectionViewController.swift
//  FlickrAPIDemo
//
//  Created by Mr.z on 2021/4/8.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    //MARK: - Vars
    var page: String?
    var text: String?
    var isLoading = false
    var searchList: SearchData?
    
    //上拉刷新屬性
    var refreshControl: UIRefreshControl!
    var pages = 1
    var hasMore = true
    var isLoadingMore = false
    var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.navigationItem.title = "搜尋的結果 \(text!)"
        
        
        configureCellSize()
        
        
        NetWork.shared.fetchData(pageCount: page! , text: text!, page: pages) { [weak self] (Photo) in
            guard let self = self else{ return }
            if Photo != nil {
                self.searchList = Photo
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadData), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refreshControl)
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        
    }
    
    
    //Cell大小設置
    func configureCellSize() {
        
        let itemSpace: CGFloat = 2
        let columnCount: CGFloat = 2
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let width = floor((collectionView.bounds.width  - itemSpace * (columnCount)) / columnCount)
       
        flowLayout?.itemSize = CGSize(width: width, height: width)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumInteritemSpacing = itemSpace
        flowLayout?.minimumLineSpacing = itemSpace
        flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        
        
    }
    
    //MARK: - Actions
    @objc func reloadData() {
        showLoadingView()
        isLoadingMore = true
        NetWork.shared.fetchData(pageCount: page!, text: text!, page: pages) { [weak self] (Photo) in
            guard let self = self else { return }
            if Photo != nil {
                self.searchList?.photos.photo.append(contentsOf: Photo.photos.photo)
                self.dismissreloadView()
                
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        
     isLoadingMore = false
    }
    
    //判斷滑動位置
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height {
            guard hasMore, !isLoadingMore else {return}
            pages += 1
            reloadData()
        }
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return searchList?.photos.photo.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CollectionViewCell.self)", for: indexPath) as? CollectionViewCell
    
        
        // Configure the cell
        cell?.photo = searchList?.photos.photo[indexPath.row]
        cell?.update()
        
        
        
        if let cell = cell {
            return cell
        } else {
            return CollectionViewCell()
        }
        
    }

    
    //MARK: - Helper
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        UIView.animate(withDuration: 0.25) { self.containerView.alpha = 0.8 }
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    //取消上拉效果
    func dismissreloadView() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }


}
