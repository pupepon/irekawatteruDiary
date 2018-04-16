//
//  SettingViewController.swift
//  irekawatteruDiary
//
//  Created by x16075xx on 2017/06/07.
//  Copyright © 2017年 AIT. All rights reserved.
//

import UIKit
import NCMB

class SettingViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate{
    @IBOutlet var backView: UIView!
    let userdefault = UserDefaults.standard
    @IBOutlet weak var diaryNameTextfield: UITextField!
    let colors = [#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1),#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1),#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)]
    var selectedPath = 0
    var colorRGB:[CGFloat] = []
    var commentFlg:Bool = false
    @IBOutlet weak var colorCollection: UICollectionView!
    
    @IBOutlet weak var commentSwitch: UISwitch!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        print("LunchedSettingView!!!")
        
        
        //入れ替わってたら名前と背景色を変更不可に。
        var flg = true
        flg = userdefault.value(forKey: "irekawatteruFlg") as! Bool
        diaryNameTextfield.isEnabled = !flg
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
        diaryNameTextfield.text = userdefault.value(forKey: "diaryName") as? String
        commentFlg = userdefault.value(forKey: "commentFlg") as! Bool
        
        //スイッチの設定
        commentSwitch.isOn = commentFlg
        
        
        colorCollection.allowsSelection = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveSatting(_ sender: Any) {
        let id = userdefault.string(forKey: "myDiaryId")
        //titleの保存
        if(diaryNameTextfield.text != nil){
            saveObject(className: "member", id: id!, key: "diaryName", value: diaryNameTextfield.text!)
        }
        userdefault.set(diaryNameTextfield.text, forKey: "diaryName")
        
        //背景色の保存
        if(colorRGB != []){
            saveObject(className: "member", id: id!, key: "backGround", value: colorRGB)
            userdefault.set(colorRGB, forKey: "backGround")
        }
        
    }
    
    @IBAction func comentFlgSwitch(_ sender: UISwitch) {
        if(sender.isOn){
            commentFlg = true
        }else{
            commentFlg = false
        }
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
            cell?.contentView.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1).cgColor
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
        return 6;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            }else{
                // 保存に成功した場合の処理
                print("save Succeed")
            }
        })
    }
}
