//
//  NewsViewController.swift
//  KibaanSample
//
//  Created by Keita Yamamoto on 2018/11/08.
//  Copyright © 2018 altonotes Inc. All rights reserved.
//

import Kibaan

class NewsViewController: SmartViewController {
    
    @IBOutlet weak var tableView: SmartTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.addRefreshControl(attributedTitle: nil, onPullToRefresh: {
            AlertUtils.showNotice(title: "Pull To Refresh", message: "Refresh!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.tableView.endRefreshing()
            })
        })
        tableView.refreshControl?.tintColor = .red
    }
}
