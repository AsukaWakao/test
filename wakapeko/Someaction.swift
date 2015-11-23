//
//  Someaction.swift
//  wakapeko
//
//  Created by 若尾あすか on 2015/02/24.
//  Copyright (c) 2015年 若尾あすか. All rights reserved.
//

import UIKit
import AVFoundation

let userDefaults = NSUserDefaults.standardUserDefaults()
//
//func postuser(time_id:String!, kaizokuname:String!){
//    
//    let str = "http://peach.mxd.media.ritsumei.ac.jp/services/tekupeko/registration/?time_id=\(time_id)&nickname=\(kaizokuname)&submit=submit"
//    //http://qiita.com/yukihamada/items/9c0cc2e2074d5cc0d368
//    let encodedString:String! = str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
//    
//    let url = NSURL(string: encodedString)
//    let request = NSURLRequest(URL: url!)
//    
//    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
////        println(NSString(data: data, encoding: NSUTF8StringEncoding))
//    }
//}

func nearpost(time_id:String!,beaconnumber:Int!){
//    println("postid = \(beaconnumber)")
    
    let url = NSURL(string: "http://peach.mxd.media.ritsumei.ac.jp/services/p_server/beacon_check?userid=\(time_id)&beaconid=\(beaconnumber)&act_type=near&submit=submit")
    let request = NSURLRequest(URL: url!)
    
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
//        println(NSString(data: data, encoding: NSUTF8StringEncoding))
    }
}

func post(time_id:String!, beaconnumber:Int!) {
//    println("postid = \(beaconnumber)")
      print("ぽすとしたよ！")
    let url = NSURL(string: "http://peach.mxd.media.ritsumei.ac.jp/services/p_server/beacon_check?userid=\(time_id)&beaconid=\(beaconnumber)&act_type=immidiate&submit=submit")
    print(url)
    let request = NSURLRequest(URL: url!)
    
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
//        println(NSString(data: data, encoding: NSUTF8StringEncoding))
      
    }
}

func playAudio(inout player:AVAudioPlayer) {
//    player.prepareToPlay()
    player.play()
}

func setObjectToUserDefaults(obj:AnyObject!, key:String!) {
    userDefaults.setObject(obj, forKey: key)
    userDefaults.synchronize()
}

func getObjectFromUserDefaults(key:String!) -> AnyObject? {
    return userDefaults.objectForKey(key)
}

func getSaveId() -> String! {
    return userDefaults.stringForKey("saveId")
}

func getSaveUrl() -> String! {
    return userDefaults.stringForKey("saveUrl")
}

func getSaveBeacons() -> [AnyObject]! {
    return userDefaults.arrayForKey("saveBeacon") as Array!
}

func getSaveProxmity() -> [AnyObject]! {
    return userDefaults.arrayForKey("saveProxmity") as Array!
    
func getSaveBeaconNumber() -> [AnyObject]! {
        return userDefaults.arrayForKey("saveBeaconNumer") as Array!
    }

}

func setAlert(title1:String!, message:String!, preferredStyle:UIAlertControllerStyle, title2:String!, style:UIAlertActionStyle, handler:((UIAlertAction!) -> Void)!) -> UIAlertController {
    
    let alert = UIAlertController(
        title: title1,
        message: message,
        preferredStyle: preferredStyle)
    
    alert.addAction(UIAlertAction(
        title: title2,
        style: style,
        handler: handler))
    //アラートを表示する
    return alert
}
