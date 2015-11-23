//
//  AppDelegate.swift
//  backtest
//
//  Created by 若尾あすか on 2014/10/24.
//  Copyright (c) 2014年 若尾あすか. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
//import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    //     var userID:String? //ID
    //    beaconinfo
    var trackLocationManager: CLLocationManager!
    var uuid:NSUUID?
    var beaconRegion:CLBeaconRegion?
    
    let Defaults = NSUserDefaults.standardUserDefaults()
    
    var window: UIWindow?
    var lastProximity: CLProximity?
    var alart:String! = "proximity"
    var beacon_number:[Int!] = []
    var BeaconCount_del:Int! = 0
    var send_beacon_number:Int!
    var userID:String!
    var Sproxmity:[String!] = []
    var Sproxmity2:String!
    var Bin:Bool!
    var Accuracy:Double!
    var hasBeacon:Bool!
    var beaconID:String!
    var targetBeacon:[CLBeacon]! = []
    var BeaconNumber_arry:[Int]! = []
    var Acnt:Int!
    var major:[Int!] = []

    
//     サウンドデータとプレイヤー
    //    let sound_data = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("near", ofType: "mp3")!)
    var audioPlayer : AVAudioPlayer!
    //beacon_numbser:beacon_id
    var beaconDictionary:[String:Int]! = ["4197":1,"1693":2,"7093":3,"8446":4,"582":5,"2317":6,"948":7,"1284":8,"8111":9,"6286":10,"2089":11,"9862":12,"7067":13,"8253":14,"4211":15,"8034":16]
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //userIDをもらう
        userID = getSaveId()
        
//        setObjectToUserDefaults([], key: "saveBeacon")
//      setObjectToUserDefaults([], key: "saveId")
//        setObjectToUserDefaults([], key: "saveUrl")
////        

        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: NSURL (fileURLWithPath: NSBundle.mainBundle().pathForResource("near", ofType: "mp3")!), fileTypeHint:nil)
        } catch {
            //Handle the error
            print(error)
        }
        audioPlayer.prepareToPlay()
        
        
        
        // ロケーションマネージャを作成する
        self.trackLocationManager = CLLocationManager();
        // デリゲートを自身に設定
        self.trackLocationManager.delegate = self;
        // セキュリティ認証のステータスを取得
        let status = CLLocationManager.authorizationStatus()
        // まだ認証が得られていない場合は、認証ダイアログを表示
        if(status == CLAuthorizationStatus.NotDetermined) {
            self.trackLocationManager.requestAlwaysAuthorization();
        }
        // BeaconのUUIDを設定
        let uuid:NSUUID? = NSUUID(UUIDString: "00000000-B160-1001-B000-001C4D2CF060")
        
        //Beacon領域を作成
        self.beaconRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: "net.noumenon-th")
        
        // アプリケーションに通知設定を登録
        //        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil))
        //        let notification = UILocalNotification()
        //        notification.category = "NOTIFICATION_CATEGORY_INTERACTIVE"
        //        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    //アプリが非アクティブになりバックグランド実行になった際に呼び出される
    func applicationDidEnterBackground(application: UIApplication) {
        //http://mpon.hatenablog.com/entry/2014/12/06/132934
        // アプリがバックグラウンド状態の場合は位置情報のバックグラウンド更新をする
        // これをしないとiBeaconの範囲に入ったか入っていないか検知してくれない
        let appStatus = UIApplication.sharedApplication().applicationState
        let isBackground = appStatus == .Background || appStatus == .Inactive
        if isBackground {
            //                       self.locationManager!.startUpdatingLocation()
        }
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //位置認証のステータスが変更された時に呼ばれる
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        // 認証のステータス
        var statusStr = "";
        print("CLAuthorizationStatus: \(statusStr)")
        
        // 認証のステータスをチェック
        switch (status) {
        case .NotDetermined:
            statusStr = "NotDetermined"
        case .Restricted:
            statusStr = "Restricted"
        case .Denied:
            statusStr = "Denied"
            print("位置情報を許可していません")
        case .AuthorizedAlways:
            statusStr = "Authorized"
            print("位置情報認証OK")
        default:
            break;
        }
        print(" CLAuthorizationStatus: \(statusStr)")
        //観測を開始させる
        trackLocationManager.startMonitoringForRegion(self.beaconRegion!)
    }
    
    //観測の開始に成功すると呼ばれる
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        
        print("didStartMonitoringForRegion");
        
        //観測開始に成功したら、領域内にいるかどうかの判定をおこなう。→（didDetermineState）へ
        trackLocationManager.requestStateForRegion(self.beaconRegion!);
    }
    
    //領域内にいるかどうかを判定する
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion inRegion: CLRegion) {
        
        switch (state) {
            
        case .Inside: // すでに領域内にいる場合は（didEnterRegion）は呼ばれない
            
            trackLocationManager.startRangingBeaconsInRegion(beaconRegion!);
            // →(didRangeBeacons)で測定をはじめる
            break;
        case .Outside:
            
            // 領域外→領域に入った場合はdidEnterRegionが呼ばれる
            break;
        case .Unknown:
            
            // 不明→領域に入った場合はdidEnterRegionが呼ばれる
            break;
        default:
            break;
        }
    }
    
    //領域に入った時
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        // →(didRangeBeacons)で測定をはじめる
        self.trackLocationManager.startRangingBeaconsInRegion(self.beaconRegion!)
        //self.status.text = "didEnterRegion"
        print("領域に入りました")
    }
    
    //領域から出た時
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        //測定を停止する
        self.trackLocationManager.stopRangingBeaconsInRegion(self.beaconRegion!)
        print("領域から出ました")
    }
    
    //観測失敗
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("monitoringDidFailForRegion \(error)")
    }
    
    //通信失敗
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError \(error)")
    }
    
    //
    //beaconsを受信するデリゲートメソッド。複数あった場合はbeaconsに入る
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region:CLBeaconRegion)  {
        //NSLog("didRangeBeacons");
        var message:String = ""
        
        
        if(beacons.count > 0) {
            BeaconCount_del = beacons.count
            //            print(beacons)
            //            print("count=\(BeaconCount_del)")
            //            println(alart)
            
            for var i = 0; i < beacons.count; i++ {
                print("iループ")
                let nearestBeacon:CLBeacon = beacons[i] as! CLBeacon
                nearestBeacon.accuracy
                beaconID = "\(nearestBeacon.major)\(nearestBeacon.minor)"
                
                var tend:Int! = beaconDictionary["\(beaconID)"]
              
                beacon_number.append(tend)
                //            println(beacon_number)
                
                if (beacon_number[i] == nil) {
                    // beacon なし
                    return
                }
                //ビーコン番号がすでにあったら通知をださない処理
                var yourBeacon = getSaveBeacons()
                
                print("yourBeacon = \(yourBeacon)")
              
                    if(yourBeacon == nil){
                        Acnt = 0
                        //                    print(nearestBeacon)
                        //targetBeacon.append(beacons[i])
                        //                    print(targetBeacon)
                    }
                    else{
                        Acnt = yourBeacon.count
                        print(Acnt)
                    }
                
              
                //            println(Acnt)
                //保存されているビーコン番号と照らし合わせる
                hasBeacon = false
                var currentValue:Int
                
                for ( var j = 0; j < Acnt; j++ ) {
                    currentValue = yourBeacon[j] as! Int
                    print("\(currentValue)と\(beacon_number[i])")
                    if (currentValue == beacon_number[i]) {
                                                hasBeacon = true
                        break
                    }
                                    }
                
                if(hasBeacon == false){
                    targetBeacon.append(beacons[i])
                     print("targetBeacon=\(targetBeacon)")
                    //                    print(beacons[i])
                }
            }
            print(beacon_number)
            
            //            print("hasBeacon\(hasBeacon)")
            BeaconCount_del = targetBeacon.count
            print("count=\(BeaconCount_del)")
            beacon_number.removeAll()
            
            
            
            
            for var l = 0; l < BeaconCount_del; l++ {
                let TargetBeacon:CLBeacon = targetBeacon[l]
                var beaconid:String = "\(targetBeacon[l].major)\(targetBeacon[l].minor)"
                print(beaconid)
                var BeaconNumber:Int =  beaconDictionary["\(beaconid)"]!
                major.append(targetBeacon[l].major as! Int)
                
                print(BeaconNumber)
                print("ビーコン番号配列\(BeaconNumber_arry)")
                BeaconNumber_arry.append(BeaconNumber)
                print("ビーコン番号\(l)は\(BeaconNumber_arry[l])\(TargetBeacon)")
                
                //                if(!hasBeacon){
                print("l=\(l)")
                print(major)
                // 今、受信している番号が配列内に無かったら
                if(TargetBeacon.proximity == CLProximity.Unknown){
                    Sproxmity.append("unknown")
                    
                    //                    return
                }
                else if(TargetBeacon.proximity == CLProximity.Far){
                    Sproxmity.append("far")
                    print("far")
                }
                    
                else if(TargetBeacon.proximity == CLProximity.Near){
                    audioPlayer.play()
                    
                    //                        let notification = createRegionNotification(message)
                    //                        UIApplication.sharedApplication().scheduleLocalNotification(notification)
                    
                    Sproxmity.append("near")
                    print("near")
                }
                else if(TargetBeacon.proximity == CLProximity.Immediate){
                    //message = "おたから\(beacon_number)がとてもちかくにあるよ！"
                    Sproxmity2 = "immediate"
                    Sproxmity.append("immediate")
                    
                    message = "近くに秘宝\(beacon_number)があるぞ！"
                }
                else {
                    message = "近くにチェックエリアは無いようです。"
                }
                
                print("spoall=\(Sproxmity)")
                
                Accuracy = TargetBeacon.accuracy
                if(Sproxmity[l] == "near" || Sproxmity[l] == "immediate"){
                    //post user enter near area
                    //nearpost(userID, beacon_number)
                    //sound effect
                    //audioPlayer.play()
                    print("nearなことをたくさんしています")
                    //                        print(send_beacon_number)
                    if(Sproxmity[l] == "immediate"){
                    }
                    //バイプレーション
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
                
                //
                //                }
                //                else {
                //
                //                    print("AppDelegate: has beacon")
                //
                //                }
                print("むむ")
            }
            print("おくった配列は\(Sproxmity)")
            print("おくった配列は\(BeaconNumber_arry)")
            
            setObjectToUserDefaults(Sproxmity, key:"saveProxmity")
            setObjectToUserDefaults(BeaconNumber_arry, key: "saveBeaconNumber")
            Defaults.synchronize()
        }
        Sproxmity.removeAll()
        targetBeacon.removeAll()
        BeaconNumber_arry.removeAll()
        major.removeAll()
    }
    
    
    
    //ローカル通知
    
    //    func Notification(message: String!)  {
    //        let notification:UILocalNotification = UILocalNotification()
    //        notification.alertBody = message
    //        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    //    }
    //    private func createRegionNotification(message: String) -> UILocalNotification {
    //
    //        // ## 通知を作成し、領域を設定 ##
    //        let notification = UILocalNotification()
    //        notification.soundName = UILocalNotificationDefaultSoundName
    //        notification.alertBody = message
    //
    //        // 一度だけの通知かどうか
    //        notification.regionTriggersOnce = false
    //
    //        return notification
    //    }
    
    
    
    
    
}

