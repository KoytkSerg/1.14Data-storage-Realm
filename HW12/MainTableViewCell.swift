//
//  MainTableViewCell.swift
//  HW12
//
//  Created by Sergii Kotyk on 31/3/21.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var dateCellLab: UILabel!
    @IBOutlet weak var dailyTempCell: UILabel!
    
    @IBOutlet weak var TablePic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private let realmClass = RealmClass()
    
    func initCell(item: Daily){ // fresh daily weather
        let info = item
        let date = NSDate(timeIntervalSince1970: info.dt)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        let DKtemp = info.temp.day
        let DailyWeath = info.weather[0]
        
        switch DailyWeath.main {
        case . snow:
            TablePic.image = UIImage(named: "snow")
        case .rain:
           TablePic.image = UIImage(named: "rain")
        case .clear:
            TablePic.image = UIImage(named: "sun")
        default:
            TablePic.image = UIImage(named: "cloud")
        }
        dateCellLab.text = dateString
        dailyTempCell.text = "\(String(Int(DKtemp - 273.15)))°"
        
        // save in realm
        
        let dailyRealm = RealmDaily()
        try! self.realmClass.realm.write{
            dailyRealm.dt = dateString
            dailyRealm.temp = dailyTempCell.text!
            dailyRealm.weather = DailyWeath.main.rawValue
            
            self.realmClass.realm.add(dailyRealm)
        }
    }
    
    func defaultInitCell(item: RealmDaily){ //saved daily weather
        let info = item
        dateCellLab.text = info.dt
        dailyTempCell.text = info.temp
        
        switch info.weather  {
        case "Snow":
            TablePic.image = UIImage(named: "snow")
        case "Rain":
            TablePic.image = UIImage(named: "rain")
        case "Clear":
            TablePic.image = UIImage(named: "sun")
        default:
            TablePic.image = UIImage(named: "cloud")
        }
    }

}
