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
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //このViewが表示されるたび呼び出されるメソッド
    override func viewWillAppear(_ animated: Bool) {
        if userdefault.value(forKey: "diaryNum") != nil{
            diaryNum = userdefault.value(forKey: "diaryNum") as! Int
            print("diaryNum",diaryNum)
        }else{
            print("diaryNum is nil")
        }
        
        if userdefault.value(forKey: "diaryText") != nil{
            diaryText = userdefault.value(forKey: "diaryText") as! [String]
            print("diaryText",diaryText)
        }else{
            print("diaryText is nil")
        }
        
        for i in 0..<diaryNum {
            //self.diaryText.append(self.getDiaryText(i))
            self.diaryText.append(self.diaryText[i])
        }
        table.reloadData()
    }
    
    //ncmbデータストアdiaryクラスのtagパラメータをキーにしてtextを読み込む
    func getDiaryText(_ tag:Int) -> String {
        var diaryText:String = ""
        let query = NCMBQuery(className: "diary")
        query?.whereKey("tag", equalTo: tag)
        var results:[AnyObject] = []
        do {
            results = try query!.findObjects() as [AnyObject]
        } catch  let error1 as NSError  {
            print("\(error1)")
            return diaryText
        }
        if results.count > 0 {
            let result = results[0] as? NCMBObject
            //print(result)
            diaryText = result?.object(forKey:"text")  as? String ?? ""
        }
        return diaryText
        
    }
    
    //cellの値を指定するデリゲートメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diaryCell",for: indexPath)
        
        cell.layer.cornerRadius = 10.0
        cell.alpha = 0.6
        cell.textLabel?.text = getDiaryText(indexPath.section)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return diaryNum
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    //sectionの個数を指定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "editDiary", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addDiary" {
            let editViewController = segue.destination as! EditViewController
            print(diaryNum+100)
            editViewController.tagNum = diaryNum
        }
        if segue.identifier == "editDiary" {
            let editViewController = segue.destination as! EditViewController
            editViewController.editText.text = getDiaryText(sender as! Int)
        }
    }
    
    
    @IBAction func backToDiaryPage(segue: UIStoryboardSegue){
        
    }

}

