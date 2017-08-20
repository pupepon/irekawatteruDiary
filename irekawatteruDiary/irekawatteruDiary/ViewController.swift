//
//  ViewController.swift
//  irekawatteruDiary
//
//  Created by x16075xx on 2017/04/25.
//  Copyright © 2017年 AIT. All rights reserved.
//

import UIKit
import NCMB

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    let userdefault = UserDefaults.standard
    var diaryNum:Int = 0
    var diaryText:[String] = []
    var diaryDate:[Date] = []
    var diaryId:[String] = []
    var commentFlg:[Bool] = [false]
    var irekawatteruFlg:Bool = false

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBOutlet weak var changeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LunchedMainView!!!")
        navigationItem.leftBarButtonItem = editButtonItem
        navigationBar.leftBarButtonItem?.tintColor = UIColor.white
        table.estimatedRowHeight = 100
        table.rowHeight = UITableViewAutomaticDimension
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
    }
    
    //このViewが表示されるたび呼び出されるメソッド
    override func viewWillAppear(_ animated: Bool) {
        
        //userDefaultから値持ってくる
        irekawatteruFlg = userdefault.value(forKey: "irekawatteruFlg") as! Bool
        if(!irekawatteruFlg){
            if userdefault.value(forKey: "diaryNum") != nil{
                diaryNum = userdefault.value(forKey: "diaryNum") as! Int
                print("diaryNum",diaryNum)
            }else{
                print("diaryNum is nil")
            }
            
            if userdefault.value(forKey: "diaryDate") != nil{
                diaryDate = userdefault.value(forKey: "diaryDate") as! [Date]
                print("diaryDate",diaryDate)
            }else{
                print("diaryDate is nil")
            }
            
            if userdefault.value(forKey: "diaryText") != nil{
                diaryText = userdefault.value(forKey: "diaryText") as! [String]
                print("diaryText",diaryText)
            }else{
                print("diaryText is nil")
            }
            
            if userdefault.value(forKey: "comments") != nil{
                commentFlg = userdefault.value(forKey: "comments") as! [Bool]
                print("commentFlg",commentFlg)
            }else{
                print("commentFlg is nil")
            }
            
            if userdefault.value(forKey: "backGround") != nil{
                let c = userdefault.value(forKey: "backGround") as! [CGFloat]
                let color: UIColor = UIColor(red: c[0], green: c[1], blue: c[2], alpha: 1)
                backView.backgroundColor = color
                print("bgColor",color)
            }else{
                print("bgColor is nil")
            }
            
            if userdefault.value(forKey: "diaryName") != nil{
                navigationBar.title = userdefault.value(forKey: "diaryName") as? String
            }else{
                print("diaryName is nil")
                navigationBar.title = "MyDiary"
            }
            
        }else{
            if userdefault.value(forKey: "irekawatteruNum") != nil{
                diaryNum = userdefault.value(forKey: "irekawatteruNum") as! Int
                print("diaryNum",diaryNum)
            }else{
                print("diaryNum is nil")
            }
            
            if userdefault.value(forKey: "irekawatteruText") != nil{
                diaryText = userdefault.value(forKey: "irekawatteruText") as! [String]
                print("diaryText",diaryText)
            }else{
                print("diaryText is nil")
            }
            
            if userdefault.value(forKey: "irekawatteruDate") != nil{
                diaryDate = userdefault.value(forKey: "irekawatteruDate") as! [Date]
                print("diaryDate",diaryDate)
            }else{
                print("diaryDate is nil")
            }
            
            if userdefault.value(forKey: "comments") != nil{
                commentFlg = userdefault.value(forKey: "comments") as! [Bool]
                print("commentflg",commentFlg)
            }else{
                print("commentFlg is nil")
            }
            
            if userdefault.value(forKey: "irekawatteruBackGround") != nil{
                let c = userdefault.value(forKey: "irekawatteruBackGround") as! [CGFloat]
                let color: UIColor = UIColor(red: c[0], green: c[1], blue: c[2], alpha: 1)
                backView.backgroundColor = color
                print("bgColor",color)
            }else{
                print("bgColor is nil")
            }
            
            if userdefault.value(forKey: "irekawatteruDiaryName") != nil{
                navigationBar.title = userdefault.value(forKey: "irekawatteruDiaryName") as? String
            }else{
                print("diaryName is nil")
                navigationBar.title = "MyDiary"
            }

        }
        if(irekawatteruFlg){
            changeButton.setTitle("戻る", for: UIControlState.normal)
        }else{
            changeButton.setTitle("入れ替わる", for: UIControlState.normal)
        }
        table.reloadData()
    }
    
    //ncmbデータストア classNameクラスのdataをキーにしてobjectを読み込む
    public func getDiaryData(_ data:Any , className:String ,keyName:String) -> [NCMBObject] {
        let query = NCMBQuery(className: className)
        query?.whereKey(keyName, equalTo: data)
        var results:[AnyObject] = []
        do {
            results = try query!.findObjects() as [AnyObject]
        } catch  let error1 as NSError  {
            print("error \(error1)")
            return results as! [NCMBObject]
        }
        return results as! [NCMBObject]
    }
    
    //入れ替わる
    @IBAction func irekawatteru(_ sender: Any) {
        irekawatteruFlg = !irekawatteruFlg
        let obj = getDiaryData("pQ4Dsf7DVU6f1ZtV", className: "general", keyName: "objectId")[0]
        let n = obj.object(forKey: "memberNum") as! Int
        var rand = -1
        let me = userdefault.value(forKey: "myDiaryNumber") as! Int
        repeat {
            rand = Int(arc4random_uniform(UInt32(n)))
            print(rand)
        } while rand ==  me
        getAnotherDiary(flg: irekawatteruFlg,memberNum: rand)
        userdefault.set(irekawatteruFlg, forKey: "irekawatteruFlg")
        viewWillAppear(true)
    }
    
    //TableView////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////
    
    //cellの編集
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "diaryCell") as! CustomTableViewCell
        
        cell.setCell(date: diaryDate[diaryNum - indexPath.section-1], text: diaryText[diaryNum - indexPath.section-1])
        cell.layer.cornerRadius = 3
        
        if commentFlg[diaryNum-indexPath.section-1]{
            cell.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1).cgColor
            cell.layer.borderWidth = 3.0
        }else{
            cell.layer.borderWidth = 0
        }
        return cell
    }
    
    //sectionの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return diaryNum
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let frame:CGRect = CGRect(x: 100, y: 100, width: 100, height: 1000)
        let header:UIView = UIView(frame: frame)
        header.backgroundColor = UIColor.clear
        return header
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(!irekawatteruFlg){
            return true
        }else{
            return false
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        // TableViewを編集可能にする
        if(!irekawatteruFlg){
            table.setEditing(editing, animated: false)
        }else{
            table.setEditing(editing, animated: true)
        }
    }
    
    func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: IndexPath) -> Bool
    {
        if(irekawatteruFlg){
            return true
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // 削除のとき.
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let text = diaryText[diaryNum - indexPath.section-1]
            let date = diaryDate[diaryNum - indexPath.section-1]
            diaryText.remove(at: diaryNum - indexPath.section-1)
            diaryDate.remove(at: diaryNum - indexPath.section-1)
            commentFlg.remove(at: diaryNum - indexPath.section-1)
            diaryNum -= 1
            
            userdefault.set(diaryNum, forKey: "diaryNum")
            userdefault.set(diaryDate, forKey: "diaryDate")
            userdefault.set(diaryText, forKey: "diaryText")
            userdefault.set(commentFlg, forKey: "comments")
            
            table.reloadData()
            
            //アニメーションするけど落ちる
//            table.deleteSections(IndexSet(indexPath), with: UITableViewRowAnimation.automatic)
//            table.reloadSections(IndexSet(indexPath), with: UITableViewRowAnimation.automatic)
            
            let parent:NCMBObject
            let id:String
            if(!irekawatteruFlg){
                id = userdefault.value(forKey: "myDiaryId") as! String
                parent = getDiaryData(id, className: "member", keyName: "objectId")[0]
            }else{
                id = userdefault.value(forKey: "irekawatteruId") as! String
                parent = getDiaryData(id, className: "member", keyName: "objectId")[0]
            }
            
            let key = getDiaryData(parent, className: "diary", keyName: "myDiary")
            print("deleteDate",date)
            
            //cloudデータ削除
            if key.count > 0 {
                for i in 0 ..< key.count{
                    let d:Date = key[i].object(forKey: "date") as! Date
                    print("diff",abs(d.timeIntervalSince(date)))
                    if(abs(d.timeIntervalSince(date)) < 0.01){
                        key[i].deleteInBackground({ (error) in
                            if error != nil {
                                // 削除に失敗した場合の処理
                                print("deleteFailed")
                            }else{
                                // 削除に成功した場合の処理
                                print("deleteSucceed")
                            }
                        })
                    }
                }
            }
            
            var num = parent.object(forKey: "diaryNum") as! Int
            num -= 1
            parent.setObject(num, forKey: "diaryNum")
            parent.save(nil)
        }
    }
    
    //sectionの個数を指定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(!irekawatteruFlg){
            self.performSegue(withIdentifier: "editDiary", sender: diaryNum-indexPath.section-1)
        }
    }
    //TavleView////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////
    
    //画面遷移の時に呼ばれるメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //右上のaddButton
        if segue.identifier == "addDiary" {
            let editViewController = segue.destination as! EditViewController
            editViewController.tagNum = -1
        }
        
        //セルをタップした
        if segue.identifier == "editDiary" && !irekawatteruFlg {
            let editViewController = segue.destination as! EditViewController
            let sectionNum = sender as! Int
            editViewController.tagNum = sectionNum
            editViewController.senderText = diaryText[sectionNum]
        }
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
    }
    
    
    //他のdiaryをuserDefaultに保存する
    func getAnotherDiary(flg: Bool,memberNum: Int){
        // 一致するtextを検索するNCMBQueryを作成
        let memberQuery = NCMBQuery(className: "member")
        memberQuery?.whereKey("number", equalTo: memberNum)
        var keyObject:NCMBObject = NCMBObject()
        var text:[String] = []
        var date:[Date] = []
        var num :Int
        var comments:[Bool] = []
        var title:String = ""
        var results:[AnyObject] = []
        var id:[String] = []
        
        //指定したmemberを取ってくる
        if(flg){
            do {
                results = try memberQuery!.findObjects() as [AnyObject]
            } catch  let error1 as NSError  {
                print("error!\(error1)")
            }
            if results.count > 0 {
                keyObject = results[0] as! NCMBObject
                print("result",results)
            }
            
            let c = keyObject.object(forKey: "backGround") as! [CGFloat]
            title = keyObject.object(forKey: "diaryName") as! String
            
            let diaryQuery = NCMBQuery(className: "diary")
            diaryQuery?.whereKey("myDiary", equalTo: keyObject)
            results = []
            do {
                results = try diaryQuery!.findObjects() as [AnyObject]
            } catch  let error1 as NSError  {
                print("\(error1)")
                
            }
            
            if results.count > 0 {
                for i in 0 ..< results.count{
                    let obj = results[i] as! NCMBObject
                    text.append(obj.object(forKey: "text") as! String)
                    date.append(obj.object(forKey: "date") as! Date)
                    id.append(obj.objectId)
                    comments.append(obj.object(forKey: "comments") as! Bool)
                }
                num = results.count
                let key:String = keyObject.objectId
                userdefault.set(title, forKey: "irekawatteruDiaryName")
                userdefault.set(comments, forKey: "comments")
                userdefault.set(c, forKey: "irekawatteruBackGround")
                userdefault.set(key, forKey: "irekawatteruId")
                userdefault.set(date, forKey: "irekawatteruDate")
                userdefault.set(num, forKey: "irekawatteruNum")
                userdefault.set(text, forKey: "irekawatteruText")
                userdefault.set(id, forKey: "irekawatteruDiaryId")
            }
        }/*自分を更新*/
        else{

            let key = userdefault.value(forKey: "myDiaryId") as! String
            // クラスのNCMBObjectを作成
            let obj = NCMBObject(className: "member")
            // objectIdプロパティを設定
            obj?.objectId = key
            
            let query = NCMBQuery(className: "diary")
            query?.whereKey("myDiary", equalTo: obj)
            // 設定されたobjectIdを元にデータストアからデータを取得
            do {
                results = try query!.findObjects() as [AnyObject]
            } catch  let error1 as NSError  {
                print("\(error1)")
            }
            if results.count > 0 {
                for i in 0 ..< results.count{
                    let obj = results[i] as! NCMBObject
                    text.append(obj.object(forKey: "text") as! String)
                    date.append(obj.object(forKey: "date") as! Date)
                    comments.append(obj.object(forKey: "comments") as! Bool)
                }
                num = results.count
                userdefault.set(date, forKey: "diaryDate")
                userdefault.set(num, forKey: "diaryNum")
                userdefault.set(text, forKey: "diaryText")
                userdefault.set(comments, forKey: "comments")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToDiaryPage(segue: UIStoryboardSegue){
        
    }
}
