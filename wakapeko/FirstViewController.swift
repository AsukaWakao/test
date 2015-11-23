//
//  FirstViewController.swift
//  wakapeko
//http://log.whitebook.info/swift/2014/11/swift-wkwebview-1.html
//  Created by 若尾あすか on 2014/10/23.
//  Copyright (c) 2014年 若尾あすか. All rights reserved.
//

import UIKit
import AVFoundation
import WebKit


class FirstViewController: UIViewController, WKUIDelegate, WKNavigationDelegate{
    
    //    @IBOutlet weak var tekupekoWeb: UIWebView!
    // サウンドデータとプレイヤー
    var audioPlayer2:AVAudioPlayer!
    
    var userID:String!
    var userPass:String!
    var beacon_id:Int!
    var proximity:[String!] = []
    var BeaconNumber:[Int!] = []
    var proximity_send:String!
    var BeaconCount:Int!
    var accuracy:Double!
    var timer = NSTimer()
    var BEACONID:String!
    var appDel = UIApplication.sharedApplication().delegate as! AppDelegate?
    //    var get_beacon:[Int!] = []
    var webView: WKWebView?
    //    http://peach.mxd.media.ritsumei.ac.jp/services/tekupeko/home/"
    var SetUrl:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        タイマーを回す
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        //       ビューの横幅、高さ、タブバーの高さを取得
        let Width:CGFloat! = self.view?.bounds.width
        let Height:CGFloat! = self.view?.bounds.height
        let TabHeight: CGFloat! = self.tabBarController!.tabBar.frame.size.height
        
        //3.WebKitのインスタンス作成
        self.webView = WKWebView(frame: CGRectMake(0, 0, Width, Height - TabHeight))
        
        //        //4.ここでWebKitをviewに紐付け
        //       self.view = self.webView
        //
        // auido を再生するプレイヤーを作成する
        do {
            try audioPlayer2 = AVAudioPlayer(contentsOfURL: NSURL (fileURLWithPath: NSBundle.mainBundle().pathForResource("fan", ofType: "mp3")!), fileTypeHint:nil)
        } catch {
            //Handle the error
            print(error)
        }
        audioPlayer2.prepareToPlay()
        
        initializeWebView(TabHeight)
    }
    
    func initializeWebView(TabHeight:CGFloat) {
        //ログイン画面からユーザID取得
        SetUrl = getSaveUrl()
        
        if(SetUrl == nil){
            SetUrl = "http://peach.mxd.media.ritsumei.ac.jp/services/p_server/tutorial"
        }
        else if(SetUrl != "http://peach.mxd.media.ritsumei.ac.jp/services/p_server/tutorial"){
            SetUrl = getSaveUrl()
            //            print(SetUrl)
        }
        else{
            SetUrl = "http://peach.mxd.media.ritsumei.ac.jp/services/p_server/tutorial"
        }
        //5.URL作って、表示させる！
        let url = NSURL(string:SetUrl)
        let req = NSURLRequest(URL:url!)
        self.webView!.UIDelegate = self
        self.webView!.navigationDelegate = self
        self.webView!.loadRequest(req)
        self.view.addSubview(self.webView!)
        
        
        // WEBページの読込状況取得のため、Observerに追加
        self.webView!.addObserver(self, forKeyPath: "title", options: .New, context: nil)
        self.webView!.addObserver(self, forKeyPath: "URL", options: .New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject?, change: [String : AnyObject]!, context: UnsafeMutablePointer<Void>) {
        switch keyPath {
        case "title":
            if let title = change[NSKeyValueChangeNewKey] as? NSString {
                checkURL()
            }
        case "URL":
            if let URL = change[NSKeyValueChangeNewKey] as? NSURL {
                //                print("ページ遷移")
                // checkURL()
            }
        default:
            break
        }
    }
    
    
    func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil {
            webView.loadRequest(navigationAction.request)
        }
        return nil
    }
    
    
    
    func checkURL(){
        var currentTitle:String! = webView?.title
        print("\(currentTitle)")
        if currentTitle == "tekupicoきみのページ" {
            var currentUrl = webView!.URL
            var currentUrl_str = webView!.URL?.absoluteString
            var split_arry:[String] = (currentUrl_str?.componentsSeparatedByString("/"))!
            userID = split_arry[6]
            //IDをアプリ内に保存
            setObjectToUserDefaults(currentUrl_str, key: "saveUrl")
            setObjectToUserDefaults(userID, key: "saveId")
            //            print("id=\(ID),title=\(currentTitle),url=\(currentUrl)")
        }
        else{
            return
        }
    }
    
    @objc func update(){
        //        beacon_id = appDel?.send_beacon_number
        BeaconCount = appDel?.BeaconCount_del
        accuracy = appDel?.Accuracy
        //stop_timer = appDel?.hasBeacon
        //        print(beacon_id)
        if(BeaconCount > 0){
            var object = userDefaults.arrayForKey("saveProxmity") as! [String]
            var object2 = userDefaults.arrayForKey("saveBeaconNumber") as! [Int]
            //            print(object2)
            //
            for var k = 0; k < object.count; k++ {
                //        http://qiita.com/watakemi725/items/8c72399c2b9644f0fd4a/
                proximity.append(object[k])
                BeaconNumber.append(object2[k])
                //                print("きた配列は\(proximity)")
                //                print("きた配列は\(BeaconNumber)")
                
            }
            
            for var i = 0; i < proximity.count; i++ {
                print("here!")
                if(proximity.isEmpty != true){
                    var proximityI:String! = proximity[i] as! String
                    print("prxmityI=\(proximityI)")
                    
                    if(proximityI != nil){
                        switch (proximityI) {
                        case "near":
                            break
                        case "immediate":
                            //to store get_beacon
                            store(BeaconNumber[i])
                            print("ちかいよ")
                            break
                        default:
                            
                            print("far")
                        }
                    }
                }
            }
            proximity.removeAll()
            BeaconNumber.removeAll()
            setObjectToUserDefaults([], key: "saveProxmity")
            setObjectToUserDefaults([], key: "saveBeaconNumber")
            userDefaults.synchronize()
        }
        else{
            return
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alert(beacon_id:Int!){
        BEACONID = appDel?.beaconID
        //sounds effect
        audioPlayer2.play()
        print("make alert")
        //make alert
        let alert = UIAlertController(
            title: "おめでとう",
            message: "おたから\(beacon_id)をみつけたぞ！",
            preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(
            title: "ゲットする！",
            style: .Default,
            handler: {action in print("ok") })
        alert.addAction(defaultAction)
        presentViewController(alert, animated: true, completion:nil)
        
        webView?.reload()
    }
    //        alert.addAction(defaultAction)
    //        presentViewController(alert, animated: true, completion:nil)
    
    
    func store(Beacon_Number:Int!){
        print("ここだと")
        print(Beacon_Number)
        if (Beacon_Number == nil){
            return
        }
        
        //objectsを配列として確定させ、前回の保存内容を格納
        if((userDefaults.objectForKey("saveBeacon")) == nil){
            setObjectToUserDefaults([Beacon_Number], key: "saveBeacon")
        }
        print("ここだと")
        var getbeacon = userDefaults.arrayForKey("saveBeacon") as! [Int!]
        //        println(getbeacon)
        
        if (Beacon_Number != nil){
            for beacon in getbeacon {
                if (beacon == Beacon_Number) {
                    return
                }
            }
            post(userID, beaconnumber: Beacon_Number)
            getbeacon.append(Beacon_Number)
            audioPlayer2.play()
            var timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("reload"), userInfo: nil, repeats: false)
            
            
        }
        print(getbeacon)
        setObjectToUserDefaults(getbeacon, key: "saveBeacon")
        
        alert(Beacon_Number)
        
    }
    
    func reload(){
        webView?.reload()
        print("リロードしたよ")
    }
    
    deinit{
        //        監視を解除
        self.webView!.removeObserver(self, forKeyPath: "title")
        self.webView!.removeObserver(self, forKeyPath: "URL")
    }
    
}
