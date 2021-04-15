import Foundation
import RealmSwift
import Alamofire

class FiveDayForecast: Object, Decodable {
    var list: [FDForecastList]?
}

class FDForecastList: Object, Decodable {
    @objc dynamic var main: FDFListMain
    @objc dynamic var dt_txt: String
}

class FDFListMain: Object, Decodable {
    @objc dynamic var temp: Double
    @objc dynamic var feels_like: Double
}

class ForecastPersistance {
    static let shared = ForecastPersistance()
    private let forecast = try! Realm()
    
    func loadForecast(){
        AF.request("http://api.openweathermap.org/data/2.5/forecast?q=Moscow,RU&units=metric&APPID=505c91a89efce765450586b2b6fe88a9").responseData { response in
            if let data = response.value {
                var fiveDayForecast: [FDForecastList] = []
                DispatchQueue.main.async {
                    do {
                        let forecast = try JSONDecoder().decode(FiveDayForecast.self, from: data)
                        for eachTime in forecast.list! {
                            fiveDayForecast.append(eachTime)
                        }
                    } catch let error { print(error) }
                    do {
                        try self.forecast.write {
                        self.forecast.add(fiveDayForecast)
                        }
                    } catch { print(error) }
                    print(fiveDayForecast.count)
                }
            }
        }
    }

    
    func currentForecast() -> [FDForecastList] {
        var forecastArray: [FDForecastList] = []
        for each in forecast.objects(FDForecastList.self) {
            forecastArray.append(each)
        }
        print(forecastArray.count)
        return forecastArray
    }
}
