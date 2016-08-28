//
//  TweetListViewController.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 27/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import UIKit

class ListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    var eventHandler: ListModuleInterface?
    
    var showAvatar: Bool = true
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


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
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return UITableViewCell(style: .Default, reuseIdentifier: "")
    }
    
    //UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //eventHandler?.selectTweetAction(tweet)
    }
    

}
