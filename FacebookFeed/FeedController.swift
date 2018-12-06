//
//  ViewController.swift
//  FacebookFeed
//
//  Created by Armin Spahic on 29/11/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var posts: [Post] = [Post]()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupNSUrlCache()
        setupCollectionView()
        setupNavBar()
        
                let postMark = Post()
                postMark.name = "Mark Zuckerberg"
                postMark.profileImageName = "zuckprofile"
                postMark.statusText = "By giving people the power to share, we're making the world more transparent."
                postMark.statusImageName = "zuckdog"
                postMark.numLikes = 400
                postMark.numComments = 123
        postMark.statusImageURL = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/mark_zuckerberg_background.jpg"
        
                let postSteve = Post()
                postSteve.name = "Steve Jobs"
                postSteve.profileImageName = "steve_profile"
                postSteve.statusText = "Design is not just what it looks like and feels like. Design is how it works.\n\n" +
                    "Being the richest man in the cemetery doesn't matter to me. Going to bed at night saying we've done something wonderful, that's what matters to me.\n\n" +
                "Sometimes when you innovate, you make mistakes. It is best to admit them quickly, and get on with improving your other innovations."
                postSteve.statusImageName = "steve_status"
                postSteve.numLikes = 1000
                postSteve.numComments = 55
        postSteve.statusImageURL = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/steve_jobs_background.jpg"
        
                let postGandhi = Post()
                postGandhi.name = "Mahatma Gandhi"
                postGandhi.profileImageName = "gandhi_profile"
                postGandhi.statusText = "Live as if you were to die tomorrow; learn as if you were to live forever.\n" +
                    "The weak can never forgive. Forgiveness is the attribute of the strong.\n" +
                "Happiness is when what you think, what you say, and what you do are in harmony."
                postGandhi.statusImageName = "gandhi_status"
                postGandhi.numLikes = 333
                postGandhi.numComments = 22
        postGandhi.statusImageURL = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/gandhi_status.jpg"
        
        
                posts.append(postMark)
                posts.append(postSteve)
                posts.append(postGandhi)

    }
    
    func setupNSUrlCache() {
        
        let memoryCapacity = 500 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "myDiskPath")
        URLCache.shared = urlCache
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor.blue
        navigationItem.title = "Facebook Feed"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = UIColor(red: 51/255, green: 90/255, blue: 149/255, alpha: 1)

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        cell.post = posts[indexPath.item]
        cell.feedController = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let statusText = posts[indexPath.item].statusText {
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
            
            let knownHeight: CGFloat = 8+44+4+4+200+4+30+8+0.5+44
            return CGSize(width: view.frame.width, height: rect.height + knownHeight + 24)
        }
        return CGSize(width: view.frame.width, height: 400
        )
    }
    
    let blackView = UIView()
    let zoomView = UIImageView()
    let navBarCoverView = UIView()
    let tabBarCoverView = UIView()
    
    var statusImageView: UIImageView?

    @objc func zoomOut() {
        
        if let startingFrame = statusImageView?.superview?.convert((statusImageView?.frame)!, to: nil) {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.zoomView.frame = startingFrame
                self.blackView.removeFromSuperview()
                self.navBarCoverView.removeFromSuperview()
                self.tabBarCoverView.removeFromSuperview()
            }) { (completed) in
                self.zoomView.removeFromSuperview()
                self.statusImageView?.alpha = 1
            }
        }
    }
    
  func animate(statusImageView: UIImageView) {
        // converts cells imageView frame to superviews frame
        self.statusImageView = statusImageView
        if let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            
            statusImageView.alpha = 0
            
            if let keyWindow = UIApplication.shared.keyWindow {
                
                blackView.backgroundColor = UIColor.black
                blackView.frame = keyWindow.frame
                blackView.alpha = 0
                view.addSubview(blackView)
                blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
                
                navBarCoverView.frame = CGRect(x: 0, y: 0, width: 1000, height: 20 + 70)
                navBarCoverView.backgroundColor = UIColor.black
                navBarCoverView.alpha = 0
                keyWindow.addSubview(navBarCoverView)
                
                tabBarCoverView.frame = CGRect(x: 0, y: keyWindow.frame.height - 100, width: 1000, height: 100)
                tabBarCoverView.backgroundColor = UIColor.black
                tabBarCoverView.alpha = 0
                keyWindow.addSubview(tabBarCoverView)
            }
            
            zoomView.backgroundColor = UIColor.blue
            zoomView.frame = startingFrame
            zoomView.image = statusImageView.image
            zoomView.isUserInteractionEnabled = true
            zoomView.contentMode = .scaleAspectFill
            zoomView.clipsToBounds = true
            view.addSubview(zoomView)
            zoomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                let y = (self.view.frame.height / 2) - statusImageView.frame.height / 2
                self.zoomView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: statusImageView.frame.height)
                self.blackView.alpha = 1
                self.navBarCoverView.alpha = 1
                self.tabBarCoverView.alpha = 1
            }, completion: nil)
        }
    }
}

//var imageCache = NSCache<AnyObject, AnyObject>()

class FeedCell: BaseCell {
    
    var feedController: FeedController?
    
    @objc func animate() {
        feedController?.animate(statusImageView: statusImageView)
    }
    
    var post: Post? {
        didSet {
            if let name = post?.name {
                let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
                attributedText.append(NSAttributedString(string: "\nDecember 18 * San Francisco", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                
                attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
                
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "globe_small")
                attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
                attributedText.append(NSAttributedString(attachment: attachment))
                
                nameLabel.attributedText = attributedText
            }
            
            if let statusName = post?.statusText {
                statusTextView.text = statusName
            }
            
            if let imageName = post?.profileImageName {
                profileImageView.image = UIImage(named: imageName)
            }
            
//            if let statusImageName = post?.statusImageName {
//                statusImageView.image = UIImage(named: statusImageName)
//            }
            statusImageView.image = nil
            
            if let statusImageUrl = post?.statusImageURL {
                
//                if let image = imageCache.object(forKey: statusImageUrl as AnyObject) {
//                    statusImageView.image = image as? UIImage
//                } else {
                
                    URLSession.shared.dataTask(with: URL(string: statusImageUrl)!) { (data, response, error) in
                        
                        if error != nil {
                            print(error)
                            return
                        }
                        
                        let image = UIImage(data: data!)
                        
                   //     imageCache.setObject(image!, forKey: statusImageUrl as AnyObject)
                        
                        DispatchQueue.main.async {
                            self.statusImageView.image = image
                            self.loader.stopAnimating()
                        }
                        }.resume()
                    
               // }
                
               
            }
        }
    }
    
    let profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let nameLabel: UILabel = {

        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    let statusTextView: UITextView = {
       let textView = UITextView()
        textView.text = "Meanwhile, Beast turned to the dark side."
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let statusImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let likesCommentsLabel: UILabel = {
        let label = UILabel()
        label.text = "488 Likes   10.7k Comments"
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let dividerLineView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let loader: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.startAnimating()
        ai.isHidden = false
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = UIColor.black
        return ai
    }()
    
    let likeButton: UIButton = {
       FeedCell.buttonForTitle(title: "Like", imageName: "like")
    }()
    
    let commentButton: UIButton = {
       FeedCell.buttonForTitle(title: "Comment", imageName: "comment")
    }()
    
    let shareButton: UIButton = {
       FeedCell.buttonForTitle(title: "Share", imageName: "share")
    }()
    
    static func buttonForTitle(title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }
    
    override func setupViews() {
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextView)
        addSubview(statusImageView)
        addSubview(likesCommentsLabel)
        addSubview(dividerLineView)
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        addSubview(loader)
        
       statusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))

        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-4-[v3(30)]-8-[v4(0.5)][v5(44)]|", views: profileImageView, statusTextView, statusImageView, likesCommentsLabel, dividerLineView, likeButton)
        addConstraintsWithFormat(format: "H:|[v0]|", views: statusImageView)
        addConstraintsWithFormat(format: "V:|-8-[v0]", views: nameLabel)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: statusTextView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: likesCommentsLabel)
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: dividerLineView)
        addConstraintsWithFormat(format: "H:|[v0(v2)][v1(v2)][v2]|", views: likeButton, commentButton, shareButton)
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: commentButton)
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: shareButton)
        
        addConstraint(NSLayoutConstraint(item: loader, attribute: .centerY, relatedBy: .equal, toItem: self.statusImageView, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: loader, attribute: .centerX, relatedBy: .equal, toItem: self.statusImageView, attribute: .centerX, multiplier: 1, constant: 0))
    }
}

