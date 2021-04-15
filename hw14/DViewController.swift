import UIKit

class DViewController: UIViewController {

    @IBOutlet var forecastTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        ForecastPersistance.shared.loadForecast()
        forecastTableView.reloadData()
    }
    

}

extension DViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ForecastPersistance.shared.currentForecast().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FiveDayForecastCell", for: indexPath) as! DTableViewCell
        let forecast = ForecastPersistance.shared.currentForecast()
        cell.dateAndTimeLabel.text = forecast[indexPath.row].dt_txt
        cell.currentTempLabel.text = "\(String(describing: forecast[indexPath.row].main.temp))˙C"
        cell.feelsLikeTempLabel.text = "Feels like \(String(describing: forecast[indexPath.row].main.feels_like))˙C"
        return cell
    }
}
