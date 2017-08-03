//
//  EditViewController.swift
//  irekawatteruDiary
//
//  Created by x16075xx on 2017/04/27.
//  Copyright © 2017年 AIT. All rights reserved.
//

import UIKit
import NCMB

class EditViewController: UIViewController {
    
    var tagNum:Int=0
    var diaryText:[String] = []
    var diaryDate:[Date] = []
    var diaryId:[String] = []
    var comments:[Bool] = [false]
    let userDefault = UserDefaults.standard
    var senderText:String = ""
    var flg:Bool = false
    @IBOutlet weak var editText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LunchedEditView!!!")
        flg = userDefault.value(forKey: "irekawatteruFlg") as! Bool
        editText.text = senderText
        //キーボード召喚
        editText.becomeFirstResponder()
        //変数読み込み
        if(!flg){
            if userDefault.value(forKey: "diaryDate") != nil{
                diaryDate = userDefault.value(forKey: "diaryDate") as! [Date]
                print("diaryDate",diaryDate)
            }else{
                print("diaryDate is nil")
            }
            
            if userDefault.value(forKey: "diaryText") != nil{
                diaryText = userDefault.value(forKey: "diaryText") as! [String]
                print("diaryText",diaryText)
            }else{
                print("diaryText is nil")
            }
            
            if userDefault.value(forKey: "comments") != nil{
                comments = userDefault.value(forKey: "comments") as! [Bool]
                print("CommentFlg",diaryText)
            }else{
                print("commentFlg is nil")
            }
            
            if(userDefault.value(forKey:"diaryId") != nil){
                diaryId = userDefault.value(forKey: "diaryId") as! [String]
                print("diaryId",diaryId)
            }else{
                print("diaryId is nil")
            }
            
        }else{
            if userDefault.value(forKey: "irekawatteruText") != nil{
                diaryText = userDefault.value(forKey: "irekawatteruText") as! [String]
                print("diaryText",diaryText)
            }else{
                print("diaryText is nil")
            }
            
            if userDefault.value(forKey: "irekawatteruDate") != nil{
                diaryDate = userDefault.value(forKey: "irekawatteruDate") as! [Date]
                print("diaryDate",diaryDate)
            }else{
                print("diaryDate is nil")
            }
            
            if userDefault.value(forKey: "comments") != nil{
                comments = userDefault.value(forKey: "comments") as! [Bool]
                print("CommentFlg",diaryText)
            }else{
                print("commentFlg is nil")
            }
            
            if(userDefault.value(forKey:"irekawatteruDiaryId") != nil){
                diaryId = userDefault.value(forKey: "irekawatteruDiaryId") as! [String]
                print("irekawatteruDiaryId",diaryId)
            }else{
                print("irekawatteruDiaryId is nil")
            }
            
        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }

    @IBAction func saveDiary(_ sender: Any) {
        print("TagNum",tagNum)
        let date = Date()
        
        switch tagNum {
            
            //Add Diary
            case -1:
                
                saveLocalDiary(tag: tagNum, date: date, comment: false)
                
                let obj = NCMBObject(className: "diary")
                
                //diaryクラスに保存
                obj?.setObject(editText.text, forKey: "text")
                obj?.setObject(date, forKey: "date")
                
                //親のポインタを設定
                let parent = NCMBObject(className: "member")
                let key:String
                if(flg){
                    key = userDefault.string(forKey: "irekawatteruId")!
                    obj?.setObject(true, forKey: "comments")
                }else{
                    key = userDefault.string(forKey: "myDiaryId")!
                    obj?.setObject(false, forKey: "comments")
                }
                print("Key: "+key)
                parent?.objectId = key
                obj?.setObject(parent, forKey: "myDiary")
                
                //親のdiaryNumをインクリメントしておく
                parent?.incrementKey("diaryNum")
                // データストアへの保存を実施
                parent?.save(nil)
            
                // データストアへの保存を実施
                obj?.saveInBackground({ (error) in
                    if error != nil {
                        // 保存に失敗した場合の処理
                        print("save Faild")
                    }else{
                        // 保存に成功した場合の処理
                        print("save Succeed")
                    }
                })
            
            //editDiary
            default:
                
                // 一致するtextを検索するNCMBQueryを作成
                let query = NCMBQuery(className: "diary")
                query?.whereKey("text", equalTo: diaryText[tagNum])
                print("TEXT",diaryText[tagNum])
                var obj:NCMBObject = NCMBObject()
                var results:[AnyObject] = []
                do {
                    results = try query!.findObjects() as [AnyObject]
                } catch  let error1 as NSError  {
                    print("\(error1)")
    
                }
                if results.count > 0 {
                    obj = results[0] as! NCMBObject
                }
                print("ID",obj.objectId)
                
                saveLocalDiary(tag: tagNum, date: date, comment: false)
                obj.setObject(editText.text, forKey: "text")
                obj.saveInBackground({ (error) in
                    if error != nil {
                        // 更新に失敗した場合の処理
                        print(error)
                        print("updateFailed")
                    }else{
                        // 更新に成功した場合の処理
                        print("updateScceed")
                    }
                })
            }
        //textFieldのキーボード閉じる
        editText.resignFirstResponder()
    }
    
    
    func saveLocalDiary(tag: Int,date:Date, comment:Bool){
        if(tag == -1){
            //ローカルに日記を保存
            diaryText.append(editText.text)
            diaryDate.append(date)
            comments.append(comment)
        }else{
            //更新
            diaryText[tagNum] = editText.text
            diaryDate[tagNum] = date
        }
        if flg {
            userDefault.set(diaryText, forKey: "irekawatteruText")
            userDefault.set(diaryText.count, forKey:"irekawatteruNum")
            userDefault.set(diaryDate, forKey:"irekawatteruDate")
            userDefault.set(comments, forKey: "comments")
        }else{
            userDefault.set(diaryText, forKey: "diaryText")
            userDefault.set(diaryText.count, forKey:"diaryNum")
            userDefault.set(diaryDate, forKey:"diaryDate")
            userDefault.set(comments, forKey: "comments")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
