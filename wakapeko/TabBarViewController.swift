//
//  TabBarViewController.swift
//  wakapeko
//
//  Created by 若尾あすか on 2014/10/28.
//  Copyright (c) 2014年 若尾あすか. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController {
    //@IBOutlet weak var user_id: UITextField!
    
    
    @IBOutlet weak var user_pass: UITextField!
    var userID:String!
    var userPASS:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serializeAndPost()
        
        
    }
    
    func serializeAndPost() {
        //時間取得
        let now = NSDate() // 現在日時の取得
        let dateFormatter = NSDateFormatter()
        
        //時間設定　ロケール
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") // ロケールの設定
        dateFormatter.timeStyle = .MediumStyle
        dateFormatter.dateStyle = .MediumStyle
        //        println(dateFormatter.stringFromDate(now)) // -> Jun 24, 2014, 11:01:31 AM
        let today:String! = dateFormatter.stringFromDate(now)
        let pass = getSavePass()
        
        user_pass.text = pass
        
        var id:String! = "\(today)\(pass)"
        userID = id.md5 // MD5 でハッシュ化
        setObjectToUserDefaults(id.md5, key: "saveId")
        //korekaraPOSTする
    }
    
    @IBAction func submit(sender: AnyObject){
        //NSUserDefauldsインスタンスの生成 http://qiita.com/mochizukikotaro/items/9098cd3c091787f9aacb
//        println(userID)
        if(user_pass.text == nil || user_pass.text == ""){
            userPASS = "noname"
        }
        else{
            userPASS = user_pass.text
        }
        postuser(userID,kaizokuname: userPASS)
        setObjectToUserDefaults(userPASS, key:"savePass")
        
        
    }
    
  
}
