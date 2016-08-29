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
    
    @IBOutlet weak var tableView: UITableView!
    weak var footerView: AutogrowingTableViewFooterView!
    weak var refreshControl: UIRefreshControl!
    
    var showAvatars: Bool = false {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                if let visibleCells = self.tableView.visibleCells as? [TweetTableViewCell] {
                    self.tableView.beginUpdates()
                    for cell in visibleCells {
                        cell.showAvatar = self.showAvatars
                    }
                    self.tableView.endUpdates()
                }
            }
        }
    }
    
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
        
        showAvatars = !showAvatars
    }
    
    func refresh(sender:AnyObject?) {
        eventHandler?.refreshOnTop()
    }
    
    //Invoke in case IsShowAvatar setting did chage
    func updateVisibleItems() {
        
        if let visibleCellIndexPaths = tableView.indexPathsForVisibleRows {
            
            tableView.beginUpdates()
            for indexPath in visibleCellIndexPaths {
                
                guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? TweetTableViewCell,
                let entity = tableDataSource?.itemAtIndex(indexPath.item) as? ListViewEntity else{
                    continue
                }
                
                setupTweetCell(cell, entity: entity)
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
            let entity = tableDataSource?.itemAtIndex(indexPath.item) as? ListViewEntity else {
                return UITableViewCell(style: .Default, reuseIdentifier: "")
        }
        
        setupTweetCell(cell, entity: entity)
        
        return cell
    }
    
    func setupTweetCell(cell:TweetTableViewCell, entity: ListViewEntity) {
        cell.userNameLabel.text = entity.userName
        cell.userIdLabel.text = entity.userAtName
        cell.tweetTextLabel.text = entity.tweetText
        cell.dateLabel.text = entity.dateString
        cell.tweetId = entity.tweetId
        cell.avatarImageView?.image = entity.avatarImage
        cell.showAvatar = self.showAvatars
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
    
    func updateItemImageAtIndexes(indexSet:NSIndexSet) {
        let indexPaths = indextSetToIndextPathArray(indexSet)
        
        for indexPath in indexPaths {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TweetTableViewCell,
                let entity = tableDataSource?.itemAtIndex(indexPath.item) as? ListViewEntity {
                cell.avatarImageView?.image = entity.avatarImage
            }
        }
        
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
    
    func showAvatars(isShow:Bool) {
        showAvatars = isShow
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
