//
//  CityTableSource.swift
//  WeatherPal
//
//  Created by Brandon Barooah on 10/10/17.
//  Copyright © 2017 WeatherPal. All rights reserved.
//

import UIKit

// Protocol in which the view controller using this table source can use for data messaging when a row is selected
protocol PlacesTableRowSelectedProtocol : class {
    func didSelectRow(title : String, subtitle : String?)
}

// I like to combine the table's delegate and datasource into one common class
class CityTableSource: NSObject, UITableViewDelegate, UITableViewDataSource {

    var titlesList : [String]!
    var subtitlesList : [String]!
    
    var reuseID = "PlacesUITableCell"
    
    weak var rowSelectedProtocol : PlacesTableRowSelectedProtocol?
    
    init(titles: [String], subtitles: [String]!){
        self.titlesList = titles
        self.subtitlesList = subtitles
    }
    
    convenience override init(){
        self.init(titles: [], subtitles: [])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesList.count
    }
    
    // Get the table cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseID)
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseID)
        }
        cell?.textLabel?.text = titlesList[indexPath.row]
        cell?.detailTextLabel?.text = subtitlesList[indexPath.row]
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // We will use dynamic heights
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        // Send the information of the cell that was clicked back to the controller that conforms to this protocol method
        rowSelectedProtocol?.didSelectRow(title: (cell!.textLabel!.text!), subtitle: (cell?.detailTextLabel?.text))
    }
    
}
