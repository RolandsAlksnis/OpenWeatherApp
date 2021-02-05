//
//  ChangeCityViewController.swift
//  OpenWeatherApp
//
//  Created by Arkadijs Makarenko on 04/02/2021.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnterCityName(city: String)
}

class ChangeCityViewController: UIViewController {

    var delegate: ChangeCityDelegate?
    @IBOutlet weak var cityTextField: DesignableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func getWeatherTapped(_ sender: Any) {
        
        guard let cityName = cityTextField.text else {
            return
        }
        
        delegate?.userEnterCityName(city: cityName)
        self.dismiss(animated: true, completion: nil)
        
    }
    

}
