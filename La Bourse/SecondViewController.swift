//
//  SecondViewController.swift
//  La Bourse
//
//  Created by Alexandre NGUYEN on 14/07/15.
//  Copyright (c) 2015 Librairie La Bourse. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let textCellIdentifier = "TextCell"
    var magasins = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let url = NSURL(string: "http://data.librairielabourse.fr/stores")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            let json = JSON(data: data!)
            
            for (key, subJson): (String, JSON) in json {
                
                self.magasins.append(subJson["localisation"].stringValue)
                
                print(subJson["localisation"])
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
        return magasins.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.textCellIdentifier, forIndexPath: indexPath) 
        
        let row = indexPath.row
        cell.textLabel?.text = magasins[row]
        
        return cell
        
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(magasins[row])
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("StoreView") as! StoreController
        vc.selectedStore = magasins[row]
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}

