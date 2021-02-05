//
//  WeatherViewController.swift
//  OpenWeatherApp
//
//  Created by Arkadijs Makarenko on 04/02/2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    
    
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    let weatherData = WeatherDataModel()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
// MARK: - CLLocation Manager

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            print("Longitute:  \(location.coordinate.longitude), latitude: \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params: [String : String] = ["lat": latitude, "lon": longitude, "appid" : weatherData.apiId]
            
            getWeatherData(url: weatherData.apiUrl, params: params)
        }
        
    }
 
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error occured: ", error)
        
    }
    
    func getWeatherData(url: String, params: [String : String]) {
        
        AF.request(url, method: .get, parameters: params).responseJSON { (response) in
            if response.value !=  nil {
                let weatherJSON: JSON = JSON(response.value!)
                print("weatherJSON: ", weatherJSON)
                
                self.updateWeatherData(json: weatherJSON)
            } else {
                print("Error occured: , \(String(describing: response.error))")
                self.cityLabel.text = "Weather unavailable !"
            }
        }
    }
    
    func updateWeatherData(json: JSON) {
        
        if let tempResult = json["main"]["temp"].double {
            weatherData.temp = Int(tempResult - 273.15)
            
            weatherData.city = json["name"].stringValue
            weatherData.condition = json["weather"][0]["id"].intValue
            
            weatherData.weatherIconName = weatherData.updateWeatherIcon(condition: weatherData.condition)
            self.updateUI()
            
        } else {
            self.cityLabel.text = "Weather unavailable !"
        }
        
    }
    
    
    // MARK: - Update UI
    
    func updateUI() {
        cityLabel.text = weatherData.city
        tempLabel.text = "\(weatherData.temp) degrees"
        weatherIcon.image = UIImage(named: weatherData.weatherIconName)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "city" {
            let vc = segue.destination as! ChangeCityViewController
            vc.delegate = self
        }
    }
    
    func userEnterCityName(city: String) {
        print(city)
        let params: [String : String] = ["q" : city, "appid" : weatherData.apiId]
        getWeatherData(url: weatherData.apiUrl, params: params)
    }
    
    
}

