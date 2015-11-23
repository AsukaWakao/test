//
//  ThirdViewContoroller.swift
//  wakapeko
//
//  Created by 若尾あすか on 2014/10/23.
//  Copyright (c) 2014年 若尾あすか. All rights reserved.
//

import Foundation
import UIKit

class ThirdViewController: UIViewController {
    
    @IBOutlet weak var map_view: UIWebView!
    
    @IBAction func reload(sender: AnyObject) {
        map_view.reload()
    }
    @IBAction func goback(sender: AnyObject) {
        map_view.goBack()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeWebView()
        //map_view.reload()
        
    }
    
    func initializeWebView() {
        self.map_view.frame = self.view.bounds
        self.map_view.scrollView.bounces = false
        self.view.addSubview(self.map_view)
        
        let url = NSURL(string:"http://peach.mxd.media.ritsumei.ac.jp/services/p_server/map")
        let request =  NSURLRequest(URL: url!)
        self.map_view.loadRequest(request)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(map_view:UIWebView){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(map_view:UIWebView){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    
    
    
}
