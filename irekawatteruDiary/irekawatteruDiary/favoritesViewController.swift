//
//  favoritesViewController.swift
//  irekawatteruDiary
//
//  Created by x16075xx on 2017/08/20.
//  Copyright © 2017年 AIT. All rights reserved.
//

import UIKit

class favoritesViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    var favorites = UserDefaults.standard.value(forKey: "favorites") as! [String:Int]
    var nums = [Int]()
    var names = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.leftBarButtonItem?.title = "削除"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //cellの編集
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        for (key,val) in favorites {
            names.append(key)
            nums.append(val)
            print(key)
        }
        cell.textLabel!.text = names[indexPath.row]
        return cell
    }
    
    //sectionとrowの個数を指定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    // セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "back", sender: nums[indexPath.row])
    }
    
    //編集
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.isEditing = editing
    }
    
    
    //削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // 削除のとき.
        if editingStyle == UITableViewCellEditingStyle.delete {
            print("削除")
            
            // 指定されたセルのオブジェクトをmyItemsから削除する.
            favorites.removeValue(forKey: names[indexPath.row])
            
            // TableViewを再読み込み.
            table.reloadData()
        }
    }
    
    //画面遷移の時に呼ばれるメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //右上のaddButton
        if segue.identifier == "back" {
            let viewController = segue.destination as! ViewController
            viewController.anotherDiaryNum = sender as! Int
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
