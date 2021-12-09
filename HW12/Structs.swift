


import Foundation
import RealmSwift

// Coord struct
struct Coords: Codable {
    let city: City
}
// weather struct's
struct City: Codable {
    let coord: Coord
}

struct Coord: Codable {
    let lat, lon: Double
}

// Main struct
struct Weather: Codable {
    let current: Current
    let daily: [Daily]
}

struct Current: Codable {
    let dt: Double
    let temp: Double
    let weather: [WeatherElement]
}

struct Daily: Codable {
    let dt: Double
    let temp: Temp
    let weather: [WeatherElement]
}

struct Temp: Codable {
    let day: Double
}

struct WeatherElement: Codable{
    let main: Main
}

enum Main:String , Codable{
    case clear = "Clear"
    case rain = "Rain"
    case snow = "Snow"
    case clouds = "Clouds"
}

///

class RealmCurWeather: Object {
    // realm class for current weather in city
    @objc dynamic var city: String = ""
    @objc dynamic var curTemp: String = ""
    @objc dynamic var curWeather: String = ""
}


class RealmDaily: Object{
    // realm class for daily weather
    @objc dynamic var dt: String = ""
    @objc dynamic var temp: String = ""
    @objc dynamic var weather: String = ""
}

class RealmClass{
    // realm class for work with him
    let realm = try! Realm()
    var dailyResults: Results<RealmDaily>?

}
