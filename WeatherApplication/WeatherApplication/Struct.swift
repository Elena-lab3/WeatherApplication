//
//  Struct.swift
//  WeatherApplication
//
//  Created by Алёнка on 10.02.22.
//

import Foundation

struct Api: Decodable{
    let lat: Double
    let lon: Double
    let timezone: String
    let timezone_offset: Int
    let current: Current
    let minutely: [Minutely]
    let daily: [Daily]
}

struct Current: Decodable{
    let dt: Double
    let sunrise: Double
    let sunset: Double
    let temp: Double
    let feels_like: Double
    let pressure: Double
    let humidity: Double
    let dew_point: Double
    let uvi: Double
    let clouds: Double
    let visibility: Double
    let wind_speed: Double
    let wind_deg: Int
    let wind_gust: Double
    let rain: Rain?
    let snow: Rain?
    let weather: [Weather]?
}

struct Minutely: Decodable{
    let dt: Int
    let precipitation: Int
}

struct Rain: Decodable{
    let h: Double
}

struct Daily: Decodable{
    let dt: Double
    let sunrise: Double
    let sunset: Double
    let moonrise: Double
    let moonset: Double
    let moon_phase: Double
    let temp: Temp
    let feels_like: Feels_like
    let pressure: Double
    let humidity: Double
    let dew_point: Double
    let wind_speed: Double
    let wind_deg: Double
    let wind_gust: Double
    let weather: [Weather]?
    let clouds: Double
    let pop: Double?
    let snow: Double?
    let uvi: Double?
    let rain: Double?
}

struct Weather: Decodable{
    let id: Int
    let main: String
    let description: String?
    let icon: String
}

struct Temp: Decodable{
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct Feels_like: Decodable{
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}
