//
//  CustomTableViewCell.swift
//  irekawatteruDiary
//
//  Created by x16075xx on 2017/05/20.
//  Copyright © 2017年 AIT. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weekDay: UILabel!
    @IBOutlet weak var diaryText: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
    let userdefault = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(date:Date,text:String){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss" //表示形式を設定
        let dateString:String
        let timeString:String
        let cal = Calendar.current//carender
        var dataComps = cal.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        //dateString = "\(dataComps.month!)月\(dataComps.day!)日 \(dataComps.hour!):\(dataComps.minute!)"
        dateString = "\(dataComps.day!)"
        timeString = "\(dataComps.hour!) : \(dataComps.minute!)"
        diaryText.numberOfLines = 0
        diaryText.lineBreakMode = NSLineBreakMode.byWordWrapping
        let c:[CGFloat]
        let flg = userdefault.value(forKey: "irekawatteruFlg") as! Bool
        c = userdefault.value(forKey: "backGround") as! [CGFloat]
        let color: UIColor = UIColor(red: c[0], green: c[1], blue: c[2], alpha: 1)
        dateLabel.textColor = color
        weekDay.textColor = color
        timeStamp.textColor = color
        
        diaryText.text = text
        dateLabel.text = dateString
        timeStamp.text = timeString
        
        let weekdayIndex: Int = cal.component(.weekday, from: date)-1
        weekDay.text = Calendar.current.shortStandaloneWeekdaySymbols[weekdayIndex]
    }
}
