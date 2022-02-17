//
//  ForecastViewController.swift
//  WeatherApplication
//
//  Created by Алёнка on 9.02.22.
//

import UIKit
import CoreLocation
import CloudKit

class ForecastViewController: UIViewController, OpenWeatherMapDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let locatoinManager: CLLocationManager = CLLocationManager()
    let idCell = "myCell"
    var openWeather = OpenWeatherMap()
    var myApi: Api?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.openWeather.delegate = self
        
        locatoinManager.delegate = self
        
        locatoinManager.desiredAccuracy = kCLLocationAccuracyBest
        locatoinManager.requestWhenInUseAuthorization()
        
        locatoinManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    
    func updateWeatherInfo(info: Api) {
        self.titleLabel.text = "\(info.timezone)"
        myApi = info
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func failure() {
        let networkController = UIAlertController(title: "Error", message: "No connection!", preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        networkController.addAction(okButton)
        
        self.present(networkController, animated: true, completion: nil)
    }
    
    //MARK: -CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location!)
        
        let currentLocation = locations.last!
        
        if(currentLocation.horizontalAccuracy > 0){
            locatoinManager.stopUpdatingLocation()
            
            let coords = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            print(coords.longitude)
            self.openWeather.getInfo(lon: coords.longitude, lat: coords.latitude)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        print("Pizda")
    }
}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as! TableViewCell
        switch indexPath.row{
        case 0:
            cell.tempLabel.text = "\(myApi!.daily[indexPath.section].temp.morn)°C"
            cell.timeLabel.text = "10.00"
        case 1:
            cell.tempLabel.text = "\(myApi!.daily[indexPath.section].temp.day)°C"
            cell.timeLabel.text = "14.00"
        case 2:
            cell.tempLabel.text = "\(myApi!.daily[indexPath.section].temp.eve)°C"
            cell.timeLabel.text = "18.00"
        case 3:
            cell.tempLabel.text = "\(myApi!.daily[indexPath.section].temp.night)°C"
            cell.timeLabel.text = "22.00"
            break
        default:
            cell.tempLabel.text = "jfjfjfjfj °C"
            cell.timeLabel.text = "10.00 p"
        }
        cell.descriptionLabel.text = "\(myApi!.daily[indexPath.section].weather!.first!.description!)"
        
        
        let url=URL(string:"https://openweathermap.org/img/w/\(myApi!.daily[indexPath.section].weather!.first!.icon).png")
        if let data = try? Data(contentsOf: url!)
        {
            cell.myimageView.image = UIImage(data: data)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Today"
        }
        else {
            let date = Date(timeIntervalSince1970: myApi!.daily[section].dt)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "EEEE" //Specify your format that you want
            let strDate = dateFormatter.string(from: date)
            return strDate
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
