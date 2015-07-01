//
//  TableViewCell.swift
//  downloader
//
//  Created by bijiabo on 15/6/29.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var controlButton: UIButton!
    @IBOutlet var percentView: UIView!
    
    var delegate : DownloadTableView?
    var index : Int = 0
    
    var percent : CGFloat = 0.0 {
        didSet {
            percentView.frame = CGRectMake(0, 0, self.frame.width * percent, self.frame.height)

        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()

        percentView.tag = 100
        
        controlButton.titleLabel?.text = "hello"
        
        controlButton.setTitle("pause", forState: UIControlState.Normal)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

    @IBAction func toggleDownloadStatus(sender: AnyObject) {
        if controlButton.titleLabel!.text == "pause"
        {
            delegate?.pause(index)
            
            controlButton.setTitle("start", forState: UIControlState.Normal)
        }
        else
        {
            delegate?.start(index)
            
            controlButton.setTitle("pause", forState: UIControlState.Normal)
        }
    }
    
    
    
}
