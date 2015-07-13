//
//  FirstViewController.swift
//  La Bourse
//
//  Created by Alexandre NGUYEN on 14/07/15.
//  Copyright (c) 2015 Librairie La Bourse. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    
    let textCellIdentifier = "TextCell"
    var titlesStr = [String]()
    var moneyStr = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let url = NSURL(string: "http://data.librairielabourse.fr/storeSales/today")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
            
            let json = JSON(data: data)
            
            for (key: String, subJson: JSON) in json {
                self.titlesStr.append(subJson["magasin"].stringValue)
                self.moneyStr.append(subJson["chiffre_journee"].stringValue + " €")
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
        
        task.resume()
        
        
        tableView.delegate = self
        tableView.dataSource = self
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
        cell.detailTextLabel?.text = titlesStr[row]
        cell.textLabel?.text = moneyStr[row]
        
        return cell
        
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        println(titlesStr[row])
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("StoreView") as! StoreController
        vc.selectedStore = titlesStr[row]
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}

