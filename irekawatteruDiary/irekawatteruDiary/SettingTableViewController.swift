//
//  SettingTableViewController.swift
//  irekawatteruDiary
//
//  Created by x16075xx on 2018/08/27.
//  Copyright © 2018年 AIT. All rights reserved.
//

import UIKit
import NCMB

class SettingTableViewController: UITableViewController,UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet var table: UITableView!
    let userdefault = UserDefaults.standard
    let colors = [#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1),#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1),#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 1, green: 0.4470407963, blue: 0.4655170441, alpha: 1),#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1),#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1),#colorLiteral(red: 0.9882749518, green: 0.9146986472, blue: 0, alpha: 1),#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
    var selectedPath = 0
    var colorRGB:[CGFloat] = []
    var commentFlg:Bool = false
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var commentSwitch: UISwitch!
    @IBOutlet weak var colorCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.leftBarButtonItem?.tintColor = UIColor.white
        navigationBar.rightBarButtonItem?.tintColor = UIColor.white
        //入れ替わってたら名前と背景色を変更不可に。
        var flg = true
        flg = userdefault.value(forKey: "irekawatteruFlg") as! Bool
        titleField.isEnabled = !flg
        colorCollection.isUserInteractionEnabled = !flg
        
        //色の初期設定
        let c = userdefault.value(forKey: "backGround") as! [CGFloat]
        let selectedColor: UIColor = UIColor(red: c[0], green: c[1], blue: c[2], alpha: 1)
        for i in 0..<colors.count{
            if(colors[i] == selectedColor){
                selectedPath = i
            }
        }
        
        //名前の設定
        titleField.text = userdefault.value(forKey: "diaryName") as? String
        commentFlg = userdefault.value(forKey: "commentFlg") as! Bool
        
        //スイッチの設定
        commentSwitch.isOn = commentFlg
        
        
        colorCollection.allowsSelection = true
    }
    @IBAction func saveButton(_ sender: Any) {
        let id = userdefault.string(forKey: "myDiaryId")
        //titleの保存
        if(titleField.text != nil){
            saveObject(className: "member", id: id!, key: "diaryName", value: titleField.text!)
        }
        userdefault.set(titleField.text, forKey: "diaryName")
        
        //背景色の保存
        if(colorRGB != []){
            saveObject(className: "member", id: id!, key: "backGround", value: colorRGB)
            userdefault.set(colorRGB, forKey: "backGround")
        }
    }
    
    
    @IBAction func isComment(_ sender: UISwitch) {
        if(sender.isOn){
            commentFlg = true
        }else{
            commentFlg = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let myView: UIView = UIView()
        myView.backgroundColor = UIColor.clear
        myView.frame = CGRect(x:0,y:0,width:self.view.frame.width,height:10)
        return myView
        
    }
    
    //collectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        // Cell はストーリーボードで設定したセルのID
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    //cellの選択
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let c = colors[indexPath.row].cgColor.components
        colorRGB = [(c?[0])!,(c?[1])!,(c?[2])!]
        
        if(indexPath.item != selectedPath){
            //選択したやつに枠線つける
            let cell = colorCollection.cellForItem(at: indexPath)
            cell?.contentView.layer.borderWidth = 4
            cell?.contentView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
            //選択してたやつの枠線消す
            let selectedCell = colorCollection.cellForItem(at: IndexPath(item: selectedPath, section: 0))
            selectedCell?.contentView.layer.borderWidth = 0
            selectedPath = indexPath.item
        }
    }
    
    //sectionの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Itemの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 要素数を入れる、要素以上の数字を入れると表示でエラーとなる
        return 10;
    }
    
    //NCMBdataの保存
    func saveObject(className:String, id:String, key:String, value:Any){
        
        userdefault.set(commentFlg,forKey:"commentFlg")
        
        let obj = NCMBObject(className: className)
        // objectIdプロパティを設定
        obj?.objectId = id
        obj?.setObject(value, forKey: key)
        obj?.saveInBackground({ (error) in
            if error != nil {
                // 保存に失敗した場合の処理
                print("save Faild")
                
                let alert: UIAlertController = UIAlertController(title: "エラー", message: "オンラインでの保存に失敗しました。", preferredStyle:  UIAlertControllerStyle.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                // ④ Alertを表示
                self.present(alert, animated: true, completion: nil)
                
            }else{
                // 保存に成功した場合の処理
                print("save Succeed")
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
