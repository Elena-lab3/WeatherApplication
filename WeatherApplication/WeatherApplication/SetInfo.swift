//
//  SetInfo.swift
//  WeatherApplication
//
//  Created by Алёнка on 11.02.22.
//

import Foundation
import UIKit
import CoreLocation

protocol OpenWeatherMapDelegate {
    
    func updateWeatherInfo(info: Api)
    func failure()
}
class OpenWeatherMap {
    
    var delegate: OpenWeatherMapDelegate!
    
    func getInfo(lon: Double, lat: Double){
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=hourly&units=metric&appid=42e46d76e5546e14c209cc87b7cc21ed"

        guard let url = URL(string: urlString) else{return}

        URLSession.shared.dataTask(with: url){ data, response, error in
                if let error = error {
                    print(error)
                }

                guard let data = data else{return}
            do{
                let info = try JSONDecoder().decode(Api.self, from: data)
                DispatchQueue.main.async {
                    () -> Void in
                    self.delegate.updateWeatherInfo(info: info)
                    
                    
                }

            }catch{
                print(error)
            }
        }.resume()
        
    }
    
}
