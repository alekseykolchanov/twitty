//
//  TweetListViewController.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 27/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import UIKit

class ListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, ListViewInterface {

    var eventHandler: ListModuleInterface?
    var tableDataSource: TableViewDataSourceProtocol?
    var settingsManager: SettingsManager?
    
    var showAvatar: Bool = true
    
    @IBOutlet weak var tableView: UITableView!
    weak var footerView: AutogrowingTableViewFooterView!
    weak var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //navigationController?.hidesBarsOnSwipe = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        self.refreshControl = refreshControl
        
        let footerView = AutogrowingTableViewFooterView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 70.0))
        tableView.tableFooterView = footerView
        self.footerView = footerView
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        eventHandler?.updateViewOnAppear()
    }
    
    
    override func setupViewAppearances() {
        let searchItem = UIBarButtonItem(image: TwittYxStyleKit.imageOfSearchIcon, style: .Plain, target: self, action: #selector(searchBarButtonItemTapped))
        navigationItem.rightBarButtonItem = searchItem
        
        let settingsItem = UIBarButtonItem(image: TwittYxStyleKit.imageOfSettingsIcon, style: .Plain, target: self, action: #selector(settingsBarButtonItemTapped))
        navigationItem.leftBarButtonItem = settingsItem
    }

    //Actions
    func searchBarButtonItemTapped() {
        eventHandler?.searchAction()
    }
    
    func settingsBarButtonItemTapped() {
        eventHandler?.settingsAction()
    }
    
    func refresh(sender:AnyObject?) {
        eventHandler?.refreshOnTop()
    }
    
    //Invoke in case IsShowAvatar setting did chage
    func reload() {
        
        if let visibleCells = tableView.visibleCells as? [TweetTableViewCell] {
            tableView.beginUpdates()
            for cell in visibleCells {
                cell.showAvatar = showAvatar
            }
            tableView.endUpdates()
        }
    }
    
    //UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableDataSource?.numberOfItems() ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellIdentifier(TableViewCellIdentifier.Tweet) as? TweetTableViewCell,
            let tweet = tableDataSource?.itemAtIndex(indexPath.item) as? Tweet else {
                return UITableViewCell(style: .Default, reuseIdentifier: "")
        }
        
        setupTweetCell(cell, tweet: tweet)
        
        return cell
    }
    
    func setupTweetCell(cell:TweetTableViewCell, tweet: Tweet) {
        cell.userNameLabel.text = tweet.user.userName
        cell.userIdLabel.text = "@"+tweet.user.userAtName
        cell.tweetTextLabel.text = tweet.text
        cell.dateLabel.text = "\(tweet.tweetDate)"
        cell.showAvatar = settingsManager?.showAvatar ?? false
    }
    
    //UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //eventHandler?.selectTweetAction(tweet)
    }
    
    //ListViewInterface
    func addItemsAtIndexes(indexSet:NSIndexSet) {
        let indexPaths = indextSetToIndextPathArray(indexSet)
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
    }
    
    func reloadItems() {
        tableView.reloadData()
    }
    
    func showDownloadAtTop() {
        refreshControl.beginRefreshing()
    }
    
    func hideDownloadAtTop() {
        refreshControl.endRefreshing()
    }
    
    func showDownloadAtBottom() {
        footerView.state = .Downloading
    }
    
    func hideDownloadAtBottom() {
        footerView.state = .Idle
    }
    
    //Helpers
    func indextSetToIndextPathArray(indexSet:NSIndexSet)->[NSIndexPath] {
        
        var indexPathArray: [NSIndexPath] = []
        indexSet.enumerateIndexesUsingBlock { (index, _) in
            indexPathArray.append(NSIndexPath(forItem: index, inSection: 0))
        }
        return indexPathArray
    }

}
