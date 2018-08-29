//
//  AppDelegate.swift
//  irekawatteruDiary
//
//  Created by x16075xx on 2017/04/25.
//  Copyright © 2017年 AIT. All rights reserved.
//

import UIKit
import NCMB
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let userdefault = UserDefaults.standard
        let applicationkey = "ce9128209837260538a4f3922683d305b263bfa9bcc73ceb32ff7fbf17a2ccc5"
        let clientkey = "0e4575a1ae6c7f07b5b0b4e406eab777fc4414b590d60de8788d5d889617b870"
//    let applicationkey = "e417a1144fbee84bb63f1b1180899722fc59a31245a9d24f0792e1d897a44de0"
//    let clientkey = "7efccf9456ebd4937c1d9d300b527546d3fb63be706da0b10ab65fe7fb8ccb1c"

    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        // Use Firebase library to configure APIs
        FIRApp.configure()
        
        // Initialize Google Mobile Ads SDK, application IDを設定
        GADMobileAds.configure(withApplicationID: "1:1021175359531:ios:0b179a5c5d9fa577")
        
        //NCMB初期設定
        NCMB.setApplicationKey(applicationkey, clientKey: clientkey)
        //初回起動のみ
        userdefault.register(defaults: ["firstLaunch" : true])
        
        
        if userdefault.bool(forKey: "firstLaunch") {
            
            userdefault.set(false,forKey:"irekawatteruFlg")
            userdefault.set("",forKey:"irekawatteruId")
            userdefault.set([Int](),forKey:"favorites")
            
            //ローカルの日記初期化
            userdefault.set(0,forKey:"diaryNum")
            userdefault.set([String](),forKey:"diaryText")
            userdefault.set([Date](),forKey:"diaryDate")
            userdefault.set([Bool](),forKey:"comments")
            userdefault.set([0.1411,0.3960,0.5647059083], forKey: "backGround")//RGB#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            userdefault.set("myDiary", forKey: "diaryName")
            userdefault.set(true, forKey: "commentFlg")
            
            // データストアに日記を追加
            let generalData = NCMBObject(className: "general")
            generalData?.objectId = "USD2Do1XAuUY5G5E"
            generalData?.fetchInBackground({ (error) in
                if error != nil {
                    // 取得に失敗した場合の処理
                    self.userdefault.set(false, forKey: "firstLaunch")
                    print("something error")
                }else{
                    let member = NCMBObject(className: "member")
                    let num = generalData?.object(forKey: "memberNum") as! Int
                    member?.setObject(num, forKey : "number")
                    member?.setObject(0, forKey: "diaryNum")
                    member?.setObject("MyDiary", forKey: "diaryName")
                    member?.setObject([0.1411,0.3960,0.5647059083], forKey: "backGround")//RGB#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
                    member?.save(nil) //同期
                    let id = member?.objectId
                    self.userdefault.set(id!, forKey: "myDiaryId")
                    print("id",id ?? "not found ID")
                    
                    generalData?.incrementKey("memberNum")//日記数を増やす
                    self.userdefault.set(num, forKey: "myDiaryNumber")
                    generalData?.save(nil)//同期
                    print("LaunchSucceed")
                    self.userdefault.set(false, forKey: "firstLaunch")
                }
            })
            // off the flag to know if it is first time to launch
        }
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
