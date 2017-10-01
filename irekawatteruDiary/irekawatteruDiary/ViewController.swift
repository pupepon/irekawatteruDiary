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
    var coment:[Bool] = [false]
    var irekawatteruFlg:Bool = false
    var myButton: UIButton!
    var anotherDiaryNum = -1
    var sortFlg:Bool = false

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBOutlet weak var yearMonthView: UIView!
    @IBOutlet weak var yearMonthLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LunchedMainView!!!")
        navigationBar.leftBarButtonItem?.tintColor = UIColor.white
        table.estimatedRowHeight = 180
        table.rowHeight = UITableViewAutomaticDimension
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
    }
    
    //このViewが表示されるたび呼び出されるメソッド
    override func viewWillAppear(_ animated: Bool) {
        
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
            coment = userdefault.value(forKey: "comments") as! [Bool]
            print("coment",coment)
        }else{
            print("coment is nil")
        }
        
        if userdefault.value(forKey: "backGround") != nil{
            let c = userdefault.value(forKey: "backGround") as! [CGFloat]
            let color: UIColor = UIColor(red: c[0], green: c[1], blue: c[2], alpha: 1)
            let headerColor : UIColor = UIColor(red: c[0]*0.7, green: c[1]*0.7, blue: c[2]*0.7, alpha: 1)
            backView.backgroundColor = color
            yearMonthView.backgroundColor = headerColor
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
        
        if(irekawatteruFlg){
            //左上のボタン
            let favoriteBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(ViewController.onClickFavoriteBarButton(sender:)))
            favoriteBarButton.tintColor = UIColor.white
            navigationItem.leftBarButtonItem = favoriteBarButton
        }else{
            navigationItem.leftBarButtonItem = editButtonItem
            navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            navigationItem.leftBarButtonItem?.title = "設定"
        }
        table.reloadData()
        indicator.stopAnimating()
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
    
            return [NCMBObject]()
        }
        if(results.count == 0){
            print(results)
            errorAlert(text: "データの取得に失敗しました")
        }
        return results as! [NCMBObject]
    }
    
    //入れ替わる
    @IBAction func irekawatteru(_ sender: Any) {
        
        indicator.startAnimating()
        irekawatteruFlg = true
        let objs = getDiaryData("pQ4Dsf7DVU6f1ZtV", className: "general", keyName: "objectId")
        if(objs.count == 0){
            print("error")
            return
        }
        let obj = objs[0]
        let n = obj.object(forKey: "memberNum") as! Int
        var rand = -1
        let me = userdefault.value(forKey: "myDiaryNumber") as! Int
        repeat {
            rand = Int(arc4random_uniform(UInt32(n)))
            print(rand)
        } while rand ==  me || rand == anotherDiaryNum
        anotherDiaryNum = rand
        getAnotherDiary(flg: irekawatteruFlg,memberNum: rand)
        userdefault.set(irekawatteruFlg, forKey: "irekawatteruFlg")
        //indicator.stopAnimating()
    }
    
    @IBAction func backToHome(_ sender: Any) {
        irekawatteruFlg = false
        indicator.startAnimating()
        getAnotherDiary(flg: irekawatteruFlg,memberNum: userdefault.value(forKey: "myDiaryNumber") as! Int)
        userdefault.set(irekawatteruFlg, forKey: "irekawatteruFlg")
        //indicator.stopAnimating()
        
    }
    
    
    @IBAction func sortDiary(_ sender: Any) {
        sortFlg = !sortFlg
        table.reloadData()
    }
    
    
    //TableView////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////
    
    //cellの編集
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "diaryCell") as! CustomTableViewCell
        
        
        if(!(userdefault.value(forKey: "commentFlg") as! Bool == true && coment[diaryNum - indexPath.section-1] == true)){
        if(sortFlg){
            cell.setCell(date: diaryDate[diaryNum - indexPath.section-1], text: diaryText[diaryNum - indexPath.section-1])
            if coment[diaryNum-indexPath.section-1]{
                cell.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1).cgColor
                cell.layer.borderWidth = 3.0
            }else{
                cell.layer.borderWidth = 0
            }
            
        }else{
            cell.setCell(date: diaryDate[indexPath.section], text: diaryText[indexPath.section])
            if coment[indexPath.section]{
                cell.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1).cgColor
                cell.layer.borderWidth = 3.0
            }else{
                cell.layer.borderWidth = 0
            }
        }
        }
        cell.layer.cornerRadius = 3
        
        return cell
    }
    
    //sectionの数
    func numberOfSections(in tableView: UITableView) -> Int {
        var cnt = 0
        if userdefault.value(forKey: "commentFlg") as! Bool == true {
            for i in coment{
                if (i == true){
                    cnt += 1
                }
            }
            print("aaaaaaa" , (diaryNum-cnt))
            return diaryNum-cnt
        }
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
            
            let date:Date
            
            if(sortFlg){
                date = diaryDate[diaryNum - indexPath.section-1]
                diaryText.remove(at: diaryNum - indexPath.section-1)
                diaryDate.remove(at: diaryNum - indexPath.section-1)
                coment.remove(at: diaryNum - indexPath.section-1)
            }else{
                date = diaryDate[indexPath.section]
                diaryText.remove(at:indexPath.section)
                diaryDate.remove(at:indexPath.section)
                coment.remove(at:indexPath.section)
            }
            
            diaryNum -= 1
            
            userdefault.set(diaryNum, forKey: "diaryNum")
            userdefault.set(diaryDate, forKey: "diaryDate")
            userdefault.set(diaryText, forKey: "diaryText")
            userdefault.set(coment, forKey: "comments")
            
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
    
    /*
     * 各indexPathのcellが表示される直前に呼ばれます．
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let path: [IndexPath]? = table.indexPathsForVisibleRows
        let num = path?.count
        if(num != nil){
            let date:Date
            if(sortFlg){
                date = diaryDate[diaryNum - (path?[0].section)!-1]
            }else{
                date = diaryDate[(path?[0].section)!]
            }
            
            let cal = Calendar.current//carender
            let dataComps = cal.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            
            yearMonthLabel.text = String(dataComps.year!) + "年" + String(dataComps.month!) as String + "月"
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
        var keyObject:NCMBObject = NCMBObject()
        var text:[String] = []
        var date:[Date] = []
        var num :Int = 0
        var comments:[Bool] = []
        var title:String = ""
        var results:[AnyObject] = []
        var id:[String] = []
        
        //indicator.startAnimating()
        
        //指定したmemberを取ってくる
        if(flg){
            let memberQuery = NCMBQuery(className: "member")
            memberQuery?.whereKey("number", equalTo: memberNum)
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
                errorAlert(text: "データの取得に失敗しました.通信環境を確認してリトライしてください。")
                return
            }
            
            if results.count >= 0 {
                for i in 0 ..< results.count{
                    let obj = results[i] as! NCMBObject
                    text.append(obj.object(forKey: "text") as! String)
                    date.append(obj.object(forKey: "date") as! Date)
                    id.append(obj.objectId)
                    comments.append(obj.object(forKey: "comments") as! Bool)
                }
                num = results.count
                let key:String = keyObject.objectId
                userdefault.set(title, forKey: "diaryName")
                userdefault.set(comments, forKey: "comments")
                userdefault.set(c, forKey: "backGround")
                userdefault.set(key, forKey: "irekawatteruId")
                userdefault.set(date, forKey: "diaryDate")
                userdefault.set(num, forKey: "diaryNum")
                userdefault.set(text, forKey: "diaryText")
                userdefault.set(id, forKey: "irekawatteruDiaryId")
            }
            viewWillAppear(true)
            
            
        }/*自分を更新*/
        else{
            let memberQuery = NCMBQuery(className: "member")
            let key = userdefault.value(forKey: "myDiaryId") as! String
            memberQuery?.whereKey("objectId", equalTo: key)
            do {
                results = try memberQuery!.findObjects() as [AnyObject]
            } catch  let error1 as NSError  {
                errorAlert(text: "データの取得に失敗しました")
                return
            }
            if results.count > 0 {
                keyObject = results[0] as! NCMBObject
                print("result",results)
            }else{
                errorAlert(text: "データの取得に失敗しました")
                return
            }
            
            let c = keyObject.object(forKey: "backGround") as! [CGFloat]
            title = keyObject.object(forKey: "diaryName") as! String
            
            
            let query = NCMBQuery(className: "diary")
            query?.whereKey("myDiary", equalTo: keyObject)
            
            query?.findObjectsInBackground({(objects, error) in
                if (error != nil){
                    self.errorAlert(text: "データの取得に失敗しました。")
                }else{
                    // 検索成功時の処理
                    results = objects! as! [NCMBObject]
                    if results.count >= 0 {
                        for i in 0 ..< results.count{
                            let obj = results[i] as! NCMBObject
                            text.append(obj.object(forKey: "text") as! String)
                            date.append(obj.object(forKey: "date") as! Date)
                            comments.append(obj.object(forKey: "comments") as! Bool)
                        }
                        print(text)
                        print(comments)
                        print("cnt",results.count)
                        num = results.count
                        
                        self.userdefault.set(title, forKey: "diaryName")
                        self.userdefault.set(c, forKey: "backGround")
                        self.userdefault.set(date, forKey: "diaryDate")
                        self.userdefault.set(num, forKey: "diaryNum")
                        self.userdefault.set(text, forKey: "diaryText")
                        self.userdefault.set(comments, forKey: "comments")
                        self.viewWillAppear(true)
                    }
                }
            })
        }
        
    }
    
    func errorAlert(text : String){
        // アラートを作成
        let alert = UIAlertController(
            title: text,
            message: "",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func onClickFavoriteBarButton(sender: UIButton){
        // アラートを作成
        let alert = UIAlertController(
            title: "お気に入りに追加しますか？",
            message: "",
            preferredStyle: .alert)
        
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "はい", style: .default){
            action in
            var favoritesDictionaly = [String:Int]()
            if self.userdefault.value(forKey: "favorites") != nil{
                favoritesDictionaly = self.userdefault.value(forKey: "favorites") as! [String : Int]
                favoritesDictionaly[self.navigationBar.title!] = self.anotherDiaryNum
            }else{
                favoritesDictionaly[self.navigationBar.title!] = self.anotherDiaryNum
            }
            print("addfavorite",favoritesDictionaly)
            self.userdefault.set(favoritesDictionaly, forKey: "favorites")
        })
        alert.addAction(UIAlertAction(title: "いいえ", style: .default))
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onlyBack(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func backAndChange(segue: UIStoryboardSegue){
        irekawatteruFlg = true
        getAnotherDiary(flg: irekawatteruFlg,memberNum: anotherDiaryNum)
        userdefault.set(irekawatteruFlg, forKey: "irekawatteruFlg")
        viewWillAppear(true)
    }
}
