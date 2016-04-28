//
//  ViewController.swift
//  SwiftWeather
//
//  Created by nmchgx on 16/4/22.
//  Copyright © 2016年 nmchgx. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {

    let locationManger:CLLocationManager = CLLocationManager()
    
    @IBOutlet var location: UILabel!
    @IBOutlet weak var temperture: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        
        if(ios8()) {
            locationManger.requestAlwaysAuthorization()
        }
        locationManger.startUpdatingLocation()
    }
    
    func ios8() -> Bool {
        let version:String = UIDevice.currentDevice().systemVersion
        return version[version.startIndex] >= "8"
    }

    func updateWeatherInfo(latitude:CLLocationDegrees, longitude:CLLocationDegrees) {
        let session = AFHTTPSessionManager()
        let url = "http://api.openweathermap.org/data/2.5/weather"
        let parameters = ["lat":latitude, "lon":longitude, "appid":"4f4be8fe7031dddd5dec789e01c1b3ac"]
        session.responseSerializer = AFJSONResponseSerializer()
        
        session.GET(url, parameters: parameters, progress: { (progress:NSProgress) -> Void in
            
            }, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) -> Void in
                print(responseObject!.description)
                if let sourceData = responseObject as? NSDictionary {
                    
                    self.updateUI(sourceData)
                }
            }) { (task: NSURLSessionDataTask?, error : NSError) -> Void in
                print(error)
        }
        
    }
    
    func updateUI(sourceData: NSDictionary) {
        print(sourceData)
        if let mainDic = sourceData["main"] as? NSDictionary {
            if let temp = mainDic["temp"] as? Double {
                temperture.text = String(temp)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocation = locations[locations.count - 1] as CLLocation
        
        if(location.horizontalAccuracy > 0) {
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            updateWeatherInfo(location.coordinate.latitude, longitude: location.coordinate.longitude)
            locationManger.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

