//
//  DailyViewController.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/6/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class DailyViewController: UIViewController , CLLocationManagerDelegate , UIPickerViewDataSource , UIPickerViewDelegate{
  
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempLable: UILabel!
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var FromPicker: UIPickerView!
    @IBOutlet weak var ToPicker: UIPickerView!
    @IBOutlet weak var ResultConvert: UILabel!
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "1db4e1a4eb15bd9835b8fad195c79bc5"
    
    let currencyURL = "http://free.currencyconverterapi.com/api/v5/convert?q="
    var currencyArrayFrom_To: [String] = ["EGP" , "AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
    var FromText = ""
    var ToText = ""

    
    
    //TODO: Declare instance variables here
    let locationManger = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //TODO:Set up the location manager here.
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
    
        
       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ConvertCurrency(_ sender: Any) {
        
         finalURL = currencyURL + FromText + "_" + ToText + "&compact=y"
        Alamofire.request(finalURL).responseJSON {
            response in
            if response.result.isSuccess {
                
                let Data: JSON = JSON(response.result.value!)
                let temp: String = self.FromText + "_" + self.ToText
                print( Data[temp]["val"])
                if let tempData = Data[temp]["val"].double {
                    self.ResultConvert.text = String(tempData)
                }
                
                
                
            }
            else {
                
            }
        }
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return currencyArrayFrom_To.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArrayFrom_To[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == FromPicker {
            FromText = currencyArrayFrom_To[row]
        }else{
            ToText = currencyArrayFrom_To[row]
        }
    }
    //MARK: - Networking from alamofire send to server by API
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url: String ,parameters: [String : String]){
        
        Alamofire.request(url , method: .get , parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
              
                let weatherJSON: JSON = JSON(response.result.value!)
              
                self.updateWeatherData(json: weatherJSON)
            }
            else {
               
                print("Error \(String(describing: response.result.error))")
                self.cityName.text = "Connection Issues"
                self.tempLable.text = "?!"
            }
        }
    }
    
    //MARK: - JSON Parsing resive from server by API
    /***************************************************************/
    
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json : JSON){
        
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            updateUIWithWeatherDate()
        }
        else
        {
            
            cityName.text = "weather Unavilable"
            self.tempLable.text = "?!"
        }
    }
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func  updateUIWithWeatherDate() {
     
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        cityName.text = weatherDataModel.city
        tempLable.text = String(weatherDataModel.temperature) + "°c"
    }
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManger.stopUpdatingLocation()
            locationManger.delegate = nil
            
        
            print("longitude = \(location.coordinate.longitude) , latitude = \(location.coordinate.latitude)")
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params: [String : String] = ["lat": latitude , "lon": longitude , "appid": APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
            
        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityName.text = "Location Unvilable"
        tempLable.text = "?!"
        
    }
    
    
    
    

   

}
