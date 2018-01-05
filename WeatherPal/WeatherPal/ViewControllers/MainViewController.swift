//
//  MainViewController.swift
//  WeatherPal
//
//  Created by Brandon Barooah on 10/9/17.
//  Copyright © 2017 WeatherPal. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: BaseViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate, PlacesTableRowSelectedProtocol {
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var cityStateLabel: UILabel!
    
    @IBOutlet weak var mainDegreesLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var highDegreesLabel: UILabel!
    @IBOutlet weak var lowDegreesLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    var lat : Double?   // Lat coordinates of selected place
    var long : Double?  // Long coordintates of selected place
    var cityName : String?
    var cityTableView : UITableView?
    var cityTableSource : CityTableSource?
    var searchCompleter: MKLocalSearchCompleter!    // Used for autocompleting city names
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up search bar
        citySearchBar.delegate = self
        citySearchBar.returnKeyType = .default
        
        // Set up completer
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter.delegate = self
        searchCompleter.filterType = MKSearchCompletionFilterType.locationsOnly
        
        
        // Hide the labels for until we get real data
        weatherIconImageView.isHidden = true
        mainDegreesLabel.isHidden = true
        descriptionLabel.isHidden = true
        highDegreesLabel.isHidden = true
        lowDegreesLabel.isHidden = true
        humidityLabel.isHidden = true
        pressureLabel.isHidden = true
        windSpeedLabel.isHidden = true
        
        // Check if the user has previously searched a place, and default the view to this data
        let (tempLat, tempLong) = UserDefaultsUtilities.getLatLong()
        let city = UserDefaultsUtilities.getSavedCity() // I store the city name as well just to prepopulate that label accurately
        if(tempLat != nil && tempLong != nil && city != nil && !city!.isEmpty){
            DispatchQueue.main.async {
                self.cityName = city
                self.cityStateLabel.text = city
            }
            callWeatherApi(tempLat, tempLong, city!)
        } else {
            // Promt the user to enter a city since it's their first time in the app
            self.cityStateLabel.text = "Welcome to WeatherPal!"
        }
    }
    
    // Method to update the UI elements
    func updateUI(_ weather: Weather){
        
        // Upload icon image asynchronously
        uploadIcon(weather.weather?.icon)
        
        // Do on main thread
        DispatchQueue.main.async {
            // Unhide labels
            self.mainDegreesLabel.isHidden = false
            self.descriptionLabel.isHidden = false
            self.highDegreesLabel.isHidden = false
            self.lowDegreesLabel.isHidden = false
            self.humidityLabel.isHidden = false
            self.pressureLabel.isHidden = false
            self.windSpeedLabel.isHidden = false
            
            // Populate the labels with proper text
            self.cityStateLabel.text = self.cityName
            self.mainDegreesLabel.text = weather.getTempFormatted()
            self.descriptionLabel.text = weather.getDescriptionFormatted()
            self.highDegreesLabel.text = weather.getTempMaxFormatted()
            self.lowDegreesLabel.text = weather.getTempMinFormatted()
            self.humidityLabel.text = weather.getHumidityFormatted()
            self.pressureLabel.text = weather.getPressureFormatted()
            self.windSpeedLabel.text = weather.getWindSpeedFormatted()
            
            // Adjust label colors based on degrees (Using animation as a visual stimulant)
            if(weather.main?.temp != nil){
                UIView.transition(with: self.mainDegreesLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.mainDegreesLabel.textColor = WeatherUtilities.getColorFromDegreesF(weather.main!.temp!)
                }, completion: nil)
                
            }
            if(weather.main?.temp_max != nil){
                UIView.transition(with: self.highDegreesLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.highDegreesLabel.textColor = WeatherUtilities.getColorFromDegreesF(weather.main!.temp_max!)
                }, completion: nil)
            }
            if(weather.main?.temp_min != nil){
                UIView.transition(with: self.lowDegreesLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.lowDegreesLabel.textColor = WeatherUtilities.getColorFromDegreesF(weather.main!.temp_min!)
                }, completion: nil)
            }
        }
        
        
    }
    
    // Upload the proper icon from the openweather site
    func uploadIcon(_ icon: String?){
        if(icon != nil && icon != ""){
            
            var imageUrl = URLConstants.iconImageUrl + icon! + ".png"
            guard let url = URL(string: imageUrl) else {
                print("Error: cannot create URL for icon")
                return
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    self.weatherIconImageView.isHidden = false
                    self.weatherIconImageView.image = UIImage(data: data)
                }
            }.resume()
        }
        
    }
    
    func callWeatherApi(_ latitude: Double?, _ longitude: Double?, _ city : String){
        // Present loading overlay while loading data
        self.PresentLoadingOverlay(title: "Retrieving data...")
        WeatherService.getWeather(lat: latitude, long: longitude, completed: { weatherResponse in
            // Hide loading overlay
            self.HideLoadingOverlay()
            if(weatherResponse.status != ResponseStatuses.success){
                // Error calling api
                if(weatherResponse.status == ResponseStatuses.networkError){
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Network Error", message: "There was an error calling the weather api right now, please try again later.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                // Success
                if weatherResponse.weather != nil && weatherResponse.weather?.main != nil {
                    // Save the lat,long, and city to the user defaults
                    UserDefaultsUtilities.saveLatLong(latitude!, longitude!)
                    UserDefaultsUtilities.saveCity(city)
                    self.updateUI(weatherResponse.weather!)
                } else {
                    // No data
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "No Data", message: "We found no data while attempting to get the weather in the city you entered, please make sure the city is a valid city.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        })
    }
    

}

extension MainViewController {
    
// Start Searchbar functions --------------------------------------------------------------------------------------------

    // Method to handle when the search button is clicked on the keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchBar.resignFirstResponder()
    }
    
    // Method to handle when text is being edited in the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text != nil && !searchBar.text!.isEmpty){
            // Create the tableview if it hasnt already been created with programatically added constraints
            if(cityTableView == nil) {
                cityTableView = UITableView()
                cityTableSource = CityTableSource()
                cityTableSource!.rowSelectedProtocol = self
                cityTableView!.delegate = cityTableSource
                cityTableView!.dataSource = cityTableSource
                
                self.view.addSubview(cityTableView!)
                cityTableView?.translatesAutoresizingMaskIntoConstraints = false
                
                // Add programatic constraints with visual format
                let views = ["tableView": cityTableView, "searchBar":citySearchBar] as [String: Any]
                let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: views)
                let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[searchBar]-[tableView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views)
                
                self.view.addConstraints(horizontalConstraints)
                self.view.addConstraints(verticalConstraints)

            }
            
            // Perform completer query
            searchCompleter.queryFragment = searchBar.text!
            
        } else {
            if(cityTableView != nil){
                cityTableView?.isHidden = true
            }
        }
    }
// End Searchbar functions ----------------------------------------------------------------------------------------------

// Start Search completer functions -------------------------------------------------------------------------------------
// Event that gets called when data is returned
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        var titles = [String]()
        var subtitles = [String]()
        completer.results.forEach{ result in
            titles.append(result.title)
            subtitles.append(result.subtitle)
        }
        cityTableSource?.titlesList = titles
        cityTableSource?.subtitlesList = subtitles
        cityTableView?.isHidden = false
        cityTableView?.reloadData()
    }
    
// End Search completer functions ----------------------------------------------------------------------------------------
// Start PlacesTableRowSelectedProtocol Implementation -------------------------------------------------------------------
    func didSelectRow(title : String, subtitle : String?){
        // Hide table
        self.cityTableView?.isHidden = true
        self.citySearchBar.resignFirstResponder()
        clearTable()
        citySearchBar.text = title
        self.cityName = title
        
        // Make a MKSearchRequest to get lat log of this location
        let searchString = title + " " + (subtitle ?? "")
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchString
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            if let mapItems = response?.mapItems{
                if(mapItems.count > 0){
                    self.lat = mapItems[0].placemark.coordinate.latitude
                    self.long = mapItems[0].placemark.coordinate.longitude
                    self.callWeatherApi(self.lat, self.long, title)
                    return
                }
            }
            print("Error getting coords")
        }
        
        
    }
// End PlacesTableRowSelectedProtocol Implementation -------------------------------------------------------------------
// Start Misc Functions -------------------------------------------------------------------

    func clearTable(){
        // Hide table, clear results
        cityTableView?.isHidden = true
        cityTableSource!.titlesList = []
        cityTableSource!.subtitlesList = []
        cityTableView?.reloadData()
    }
    
}
