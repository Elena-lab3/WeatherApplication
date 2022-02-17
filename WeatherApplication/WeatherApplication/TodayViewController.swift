//
//  TodayViewController.swift
//  WeatherApplication
//
//  Created by Алёнка on 9.02.22.
//

import UIKit
import CoreLocation

class TodayViewController: UIViewController, OpenWeatherMapDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var pressionLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    
    let locatoinManager: CLLocationManager = CLLocationManager()
    
    var openWeather = OpenWeatherMap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.openWeather.delegate = self
        
        locatoinManager.delegate = self
        
        locatoinManager.desiredAccuracy = kCLLocationAccuracyBest
        locatoinManager.requestWhenInUseAuthorization()
        
        locatoinManager.startUpdatingLocation()
    }
    
    //MARK: WeatherInfo
    func updateWeatherInfo(info: Api) {
        let url=URL(string:"https://openweathermap.org/img/w/\(info.current.weather!.first!.icon).png")
        if let data = try? Data(contentsOf: url!)
        {
            self.imageView.image = UIImage(data: data)
        }
        self.tempLabel.text = "\(info.current.temp)°C | \(info.current.weather!.first!.description!)"
        self.cityLabel.text = "\(info.timezone)"
        self.windLabel.text = "\(info.current.wind_speed) m/s"
        self.humidityLabel.text = "\(info.current.humidity) %"
        self.precipitationLabel.text = "\(info.current.feels_like)°C"
        self.pressionLabel.text = "\(info.current.pressure) hPa"
        self.directionLabel.text = "\(info.current.wind_gust) °"
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

