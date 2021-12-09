//
//  ViewController.swift
//  HW12
//
//  Created by Sergii Kotyk on 31/3/21.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var CityTextField: UITextField!
    @IBOutlet weak var MainImage: UIImageView!
    @IBOutlet weak var Table: UITableView!
    @IBOutlet weak var CurrentTempLab: UILabel!
    @IBOutlet weak var CityLabel: UILabel!
    
    private let realmClass = RealmClass()
    var weather: Weather? = nil
    var coords: Coords? = nil
    lazy var realmCurWeather = realmClass.realm.objects(RealmCurWeather.self)
    let loader = Loader()
    
    @IBAction func ShowButton(_ sender: Any) {
        CityLabel.text = CityTextField.text
        
        let url = "http://api.openweathermap.org/data/2.5/forecast?q=\( CityLabel.text ?? "")&appid=1b7727628a00a94bb2abbbc3061b71f6"
        
        // find a coords for city
        
        loader.request2(urlString: url){coords in
            self.coords = coords
            let curCoord = coords.city.coord
            let curCoordLon = curCoord.lon
            let curCoordLat = curCoord.lat
            
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(curCoordLat)&lon=\( curCoordLon)&exclude=dayly&appid=1b7727628a00a94bb2abbbc3061b71f6"
            
            // main weather request using coords
            
            self.loader.request1(urlString: urlString) { [self] (result) in
            switch result{

            case .success(let weather):
                
            //show current weather
                
                self.weather = weather
                let curInfo = weather.current.temp
                
                self.CurrentTempLab.text = "\(String(Int(curInfo - 275.15)))°"
                
                let curWeather = weather.current.weather
                switch curWeather[0].main {
                case .snow:
                    self.MainImage.image = UIImage(named: "snow")
                case .rain:
                    self.MainImage.image = UIImage(named: "rain")
                case .clear:
                    self.MainImage.image = UIImage(named: "sun")
                default:
                    self.MainImage.image = UIImage(named: "cloud")
                }
                
               // save current weather
                
                let realmCurWeather = RealmCurWeather()
                try! self.realmClass.realm.write{
                    self.realmClass.realm.deleteAll()
                }
                try! self.realmClass.realm.write{
                    realmCurWeather.city = self.CityLabel.text!
                    realmCurWeather.curTemp = self.CurrentTempLab.text!
                    realmCurWeather.curWeather = curWeather[0].main.rawValue
                    self.realmClass.realm.add(realmCurWeather)
                }
                self.Table.reloadData()
            case .failure(let error):
                print("error", error)
                }
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show saved current weather
        
        self.realmClass.dailyResults = realmClass.realm.objects(RealmDaily.self)
        let info = self.realmCurWeather.first
        CityLabel.text = info?.city ?? "Chose a city"
        CurrentTempLab.text = info?.curTemp

        switch info?.curWeather  {
        case "Snow":
            self.MainImage.image = UIImage(named: "snow")
        case "Rain":
            self.MainImage.image = UIImage(named: "rain")
        case "Clear":
            self.MainImage.image = UIImage(named: "sun")
        case "Clouds":
            self.MainImage.image = UIImage(named: "cloud")
        default: return
        }
    }
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather?.daily.count ?? realmClass.dailyResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // show fresh daily weather or saved daily weather
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MainTableViewCell
        if ((weather?.daily.isEmpty) == nil){
            let data = self.realmClass.dailyResults![indexPath.row] // saved weather
            cell.defaultInitCell(item: data)
        }else{
            let info = (weather?.daily[indexPath.row])! // fresh one
            cell.initCell(item: info)
            }
        return cell
    }
}
