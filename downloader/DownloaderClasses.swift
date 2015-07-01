//
//  downloader.swift
//  downloader
//
//  Created by bijiabo on 15/6/28.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import Foundation
import Alamofire

class DownloadItem : DownloadItemProtocol
{
    var id : Int = 0
    var remoteURL : NSURL
    var cacheRootURL : NSURL
    var filename : String = ""
    
    init(remoteURL : NSURL , cacheRootURL : NSURL)
    {
        self.remoteURL = remoteURL
        self.cacheRootURL = cacheRootURL
    }
}

class Downloader : DownloaderProtocol
{
    var delegate : DownloaderObserverProtocol?
    
    var list : Array<DownloadItemProtocol> = Array<DownloadItemProtocol>()
    
    var requestlist : [Request] = [Request]()
    
    init()
    {
        
    }
    /*
    func download(remoteURL: String , cacheRootURL : NSURL)
    {
        func download(remoteURL , cacheRootURL : cacheRootURL )
    }
    */
    func download(remoteURL: String , cacheRootURL : NSURL , filename : String?) -> Int
    {
        var item : DownloadItemProtocol = DownloadItem(remoteURL: NSURL(string: remoteURL)!, cacheRootURL: cacheRootURL)
        
        //设定id
        /*
        if id != nil
        {
            item.id = id!
        }
        */
        
        var newURL : Bool = true
        
        var id : Int = 0
        
        for var i = 0; i < list.count ; i++
        {
            if list[i].remoteURL == item.remoteURL
            {
                newURL = false
                
                id = i
                
                break
            }
        }
        
        if newURL
        {
            //若路径不存在，则创建
            var isDir : ObjCBool = true
            if NSFileManager.defaultManager().fileExistsAtPath(cacheRootURL.relativePath!, isDirectory: &isDir) == false
            {
                NSFileManager.defaultManager().createDirectoryAtURL(cacheRootURL, withIntermediateDirectories: true, attributes: [NSFileProtectionKey : NSFileProtectionNone], error: nil)
            }
            
            id = list.count
            
            item.id = id
            
            list.append(item)
        }
        
        
        
        //开始下载
        start(id)
        
        return id
    }
    
    func start(index: Int) {
        println("start : index \(index)")

        let item = list[index]
        
        let destination : (NSURL, NSHTTPURLResponse) -> NSURL = {(temporaryURL, response) -> NSURL in
            
            var filename : String = item.remoteURL.lastPathComponent!
            
            if item.filename != ""
            {
                filename = item.filename
            }
            
            let url : NSURL = item.cacheRootURL.URLByAppendingPathComponent(filename)
            
            return url
        }
        
        
        
        if requestlist.count > index
        {
            requestlist[index].resume()
        }
        else
        {
            let request = Alamofire.download(.GET, item.remoteURL, destination)
                .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                    
                    let percent = Float(totalBytesRead) / Float(totalBytesExpectedToRead)
                    
                    if self.delegate?.refreshDownloadProgressFor != nil
                    {
                        self.delegate?.refreshDownloadProgressFor!(id: item.id, progress: percent)
                    }
                    else
                    {
                        println("do not has refreshDownloadProgressFor")
                    }
                }
                .response { (request, response, _, error) in
                    //println(response)
                    println("---------\n\n")
                    self.delegate?.downloadCompleted( item as! AnyObject )
            }
            
            requestlist.append(request)
        }
        
        println(requestlist)
        
    }
    
    func pause(index: Int) {
        if requestlist.count>index
        {
            requestlist[index].suspend()
        }
    }
    
    func cancel(index: Int) {
        
    }
    
    func resume(index: Int) {
        
    }
}
