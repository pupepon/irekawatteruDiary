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
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var editText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        editText.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }

    @IBAction func saveDiary(_ sender: Any) {
        print("lag check")
        if(tagNum == -1){
            
        }
        let obj = NCMBObject(className: "diary")
        obj?.setObject(editText.text, forKey: "text")
        obj?.setObject(NSDate(), forKey: "date")
        obj?.setObject(tagNum, forKey: "tag")
        
        
        // データストアへの保存を実施
        obj?.saveInBackground({ (error) in
            if error != nil {
                // 保存に失敗した場合の処理
                print("save Faild")
            }else{
                // 保存に成功した場合の処理
                self.userDefaults.set(self.tagNum+1, forKey:"diaryNum")
                print("save Succeed")
            }
        })
        editText.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
