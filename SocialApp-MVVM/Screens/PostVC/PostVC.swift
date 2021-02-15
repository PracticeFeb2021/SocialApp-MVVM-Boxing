//
//  PostVC.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit

class PostVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var postTitleLabel: UILabel!
    
    @IBOutlet weak var postBodyLabel: UILabel!
    
    @IBOutlet weak var postAuthorLabel: UILabel!
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    @IBOutlet weak var commentsTableConstraint: NSLayoutConstraint!

    var viewModel: PostViewModelP!
    

    //MARK: - View lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setPost(viewModel.post)
        
        commentsTableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: CommentCell.cellReuseId)
        
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        
        setupViewModel()
        viewModel.ready()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateScrollViewContentSize()
    }
    
    //MARK: - Setup

    private func setupViewModel() {
        
        viewModel.didUpdatePost = { [weak self] post in
            self?.setPost(post)
        }
        viewModel.didUpdateUser = { [weak self] user in
            self?.postAuthorLabel.text = user.name
        }
        viewModel.didUpdateComments = { [weak self] comments in
            self?.commentsTableView.reloadData()
        }
    }
    
    //MARK: - Private

    private func updateScrollViewContentSize(){
        
        commentsTableConstraint.constant = commentsTableView.contentSize.height + 20.0
        var heightOfSubViews: CGFloat = 0.0
        contentView.subviews.forEach { subview in
            if let tableView = subview as? UITableView {
                heightOfSubViews += (tableView.contentSize.height + 20.0)
            } else {
                heightOfSubViews += subview.frame.size.height
            }
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: heightOfSubViews)
    }
    
    private func setPost(_ post: Post) {
        postTitleLabel.text = post.title
        postBodyLabel.text = post.body
    }
}

//MARK: - TableView

extension PostVC: UITableViewDelegate,UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            self.commentsTableView.dequeueReusableCell(withIdentifier: CommentCell.cellReuseId, for: indexPath) as! CommentCell
        
        cell.configure(with: viewModel.comments[indexPath.row])
        return cell
    }
}
