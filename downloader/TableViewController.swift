//
//  TableViewController.swift
//  downloader
//
//  Created by bijiabo on 15/6/29.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import UIKit

protocol DownloadTableView
{
    func start(index : Int)
    
    func pause (index : Int)
}

class TableViewController: UITableViewController, DownloaderObserverProtocol , DownloadTableView
{

    var model : [Dictionary<String,AnyObject>] = [
        ["remoteURL" : "http://aoss.appshare.cn/a/4/u5q3ew8b.audio" , "id" : 0 , "title": "dsffe" , "localURI" : "u5q3ew8b.m4a"],
        ["remoteURL" : "http://aoss.appshare.cn/a/2/owkxt49i.audio" , "id" : 1 , "title": "24rfs" , "localURI" : "owkxt49i.m4a"],
        ["remoteURL" : "http://aoss.appshare.cn/a/1/kuchplvq.audio" , "id" : 2 , "title": "32rfd" , "localURI" : "kuchplvq.m4a"],
        ["remoteURL" : "http://aoss.appshare.cn/a/5/di34cjru.audio" , "id" : 3 , "title": "edr2k" , "localURI" : "di34cjru.m4a"]
    ]
    
    let cacheRootPath : String = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as! String
    var cacheRootURL : NSURL!

    var downloader : Downloader = Downloader()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cacheRootURL = NSURL(fileURLWithPath: cacheRootPath)!
        cacheRootURL = cacheRootURL.URLByAppendingPathComponent("media/audio")
        
        downloader.delegate = self
        
        for var i=0; i<model.count ; i++
        {
            let urlString : String = model[i]["remoteURL"] as! String
            let url : NSURL = NSURL(string: urlString)!
            
            let id = downloader.download(urlString, cacheRootURL: cacheRootURL , filename : model[i]["localURI"] as? String)
            
            model[i]["id"] = id
            
            println(model[i])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return model.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : TableViewCell = tableView.dequeueReusableCellWithIdentifier("downloadItemCell", forIndexPath: indexPath) as! TableViewCell

        cell.title.text = model[indexPath.row]["title"] as? String
        
        cell.index = indexPath.row
        
        if let progress : Float = model[indexPath.row]["progress"] as? Float
        {
            cell.percent = CGFloat(progress)
        }
        else
        {
            cell.percent = 0
        }
        
        cell.delegate = self
        

        return cell
    }


    
    func downloadCompleted(data : AnyObject) {
        
        let item = data as! DownloadItem
        
        for var i=0;i<model.count;i++
        {
            if (model[i]["id"] as! Int) == item.id
            {
                let cell : TableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i,inSection: 0)) as! TableViewCell
                
                cell.controlButton.setTitle("completed", forState: UIControlState.Normal)
                
                break
            }
        }
    }
    
    func downloadErrorOccurd(data : AnyObject) {
        println("downloadErrorOccurd")
    }
    
    func refreshDownloadProgressFor(#id: Int, progress: Float) {
        println("refreshDownloadProgressFor #id = \(id)  || progress = \(progress)")
        
        for var i=0;i<model.count;i++
        {
            if (model[i]["id"] as! Int) == id
            {
                //let cell : TableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i,inSection: 0)) as! TableViewCell
             
                model[i]["progress"] = progress as AnyObject
                
                //tableView.reloadData()
                
                break
            }
        }
    }

    
    func start(index: Int) {
        
        downloader.start(index)
    }
    
    func pause(index: Int) {
        
        downloader.pause(index)
        
    }
}
