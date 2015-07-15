//
//  FirstViewController.swift
//  La Bourse
//
//  Created by Alexandre NGUYEN on 14/07/15.
//  Copyright (c) 2015 Librairie La Bourse. All rights reserved.
//

import UIKit
import Refresher

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    
    let textCellIdentifier = "TextCell"
    var titlesStr = [String]()
    var moneyStr = [String]()
    
    override func viewDidLoad() {
        
        tableView.addPullToRefreshWithAction {
            NSOperationQueue().addOperationWithBlock {
                sleep(2)
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.reloadTable()
                    self.tableView.stopPullToRefresh()
                }
            }
        }
        
        reloadTable();
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func UIColorFromRGB(colorCode: String, alpha: Float = 1.0) -> UIColor {
        var scanner = NSScanner(string:colorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
    
    func reloadTable() {
        
        let url = NSURL(string: "http://data.librairielabourse.fr/storeSales/today")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
            
            self.titlesStr = [String]()
            self.moneyStr = [String]()
            
            let json = JSON(data: data)
            
            for (key: String, subJson: JSON) in json {
                
                if key == "today" {
                    
                    self.titlesStr.append("←")
                    self.moneyStr.append("Aujourd'hui")
                    
                    self.buildTableStep(subJson)
                    
                }
            }
            
            for (key: String, subJson: JSON) in json {
                
                if key == "lastWeek" {
                    
                    self.titlesStr.append("←")
                    self.moneyStr.append("La semaine dernière")
                    
                    self.buildTableStep(subJson)
                    
                }
            }
            
            for (key: String, subJson: JSON) in json {
                
                if key == "lastMonth" {
                    
                    self.titlesStr.append("←")
                    self.moneyStr.append("Le mois dernier")
                    
                    self.buildTableStep(subJson)
                    
                }
            }
            
            for (key: String, subJson: JSON) in json {
                
                if key == "lastYear" {
                    
                    self.titlesStr.append("←")
                    self.moneyStr.append("L'an dernier")
                    
                    self.buildTableStep(subJson)
                    
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
        
        task.resume()
        
    }
    
    func buildTableStep(subJson: JSON) {
        
        for (key: String, subSubJson: JSON) in subJson {

        	self.titlesStr.append(subSubJson["magasin"].stringValue)
        	self.moneyStr.append(subSubJson["chiffre_journee"].stringValue + " €")
     
        }
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesStr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row

        if moneyStr[row] == "Aujourd'hui" {
            cell.backgroundColor = self.UIColorFromRGB("E74C3C")
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
        }

        else if moneyStr[row] == "La semaine dernière" {
            cell.backgroundColor = self.UIColorFromRGB("3498DB")
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
        }

        else if moneyStr[row] == "Le mois dernier" {
            cell.backgroundColor = self.UIColorFromRGB("3498DB")
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
        }
            
        else if moneyStr[row] == "L'an dernier" {
            cell.backgroundColor = self.UIColorFromRGB("3498DB")
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
        }
            
        else {
            cell.backgroundColor = UIColor.whiteColor()
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.detailTextLabel?.textColor = UIColor.blackColor()
        }
        
        cell.detailTextLabel?.text = titlesStr[row]
        cell.textLabel?.text = moneyStr[row]
        
        return cell
        
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        println(titlesStr[row])
        
        if moneyStr[row] != "Aujourd'hui" &&
        moneyStr[row] != "L'an dernier" &&
        moneyStr[row] != "Le mois dernier" &&
        moneyStr[row] != "La semaine dernière" {
            
        	let storyboard = UIStoryboard(name: "Main", bundle: nil)
        	let vc = storyboard.instantiateViewControllerWithIdentifier("StoreView") as! StoreController
        	vc.selectedStore = titlesStr[row]
        	self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
}

