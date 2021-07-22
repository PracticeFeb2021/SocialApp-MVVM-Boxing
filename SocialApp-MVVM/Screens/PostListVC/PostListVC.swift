//
//  PostListVC.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit

class PostListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: PostListViewModel!
    
    var netService: NetworkingService!
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "Posts"
        
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: PostCell.cellReuseId)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        bindViewModel()
        viewModel.ready()
    }
    
    //MARK: - Setup 
    
    private func bindViewModel() {
        
        viewModel.didSelectPost = { [weak self] selectedPost in
            guard let weakSelf = self else {
                return
            }
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PostVC") as! PostVC
            vc.viewModel = PostViewModel(weakSelf.netService)
            vc.viewModel.post.value = selectedPost
            weakSelf.navigationController?.pushViewController(vc, animated: true)
        }
        viewModel.posts.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
}

//MARK: - TableView

extension PostListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.value.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !viewModel.posts.value.isEmpty else {
            return UITableViewCell()
        }
        let cell =
            self.tableView.dequeueReusableCell(withIdentifier: PostCell.cellReuseId, for: indexPath) as! PostCell
        cell.configure(with: viewModel.posts.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}
