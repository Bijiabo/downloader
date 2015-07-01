//
//  ViewController.swift
//  downloader
//
//  Created by bijiabo on 15/6/28.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, DownloaderObserverProtocol , AVAudioPlayerDelegate
{

    var model : Array<AnyObject> = [
        ["remoteURL" : "http://aoss.appshare.cn/a/4/u5q3ew8b.audio" , "id" : 0],
        ["remoteURL" : "http://aoss.appshare.cn/a/2/owkxt49i.audio" , "id" : 1],
        ["remoteURL" : "http://aoss.appshare.cn/a/1/kuchplvq.audio" , "id" : 2],
        ["remoteURL" : "http://aoss.appshare.cn/a/5/di34cjru.audio" , "id" : 3]
    ]
    
    let cacheRootPath : String = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as! String
    var cacheRootURL : NSURL!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cacheRootURL = NSURL(fileURLWithPath: cacheRootPath)!
        cacheRootURL = cacheRootURL.URLByAppendingPathComponent("media/audio")
        
        var downloader : Downloader = Downloader()
        downloader.delegate = self
        
        
        for item in model
        {
            let urlString : String = item["remoteURL"] as! String
            let url : NSURL = NSURL(string: urlString)!
            
            downloader.download(urlString, cacheRootURL: cacheRootURL , filename : nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func downloadCompleted(data : AnyObject) {
        
        let item = data as! DownloadItem
        
        println(item.remoteURL)
        println("downloadCompleted")
    }
    
    func downloadErrorOccurd(data : AnyObject) {
        println("downloadErrorOccurd")
    }

    func refreshDownloadProgressFor(#id: Int, progress: Float) {
        println("refreshDownloadProgressFor #id = \(id)  || progress = \(progress)")
    }
}

