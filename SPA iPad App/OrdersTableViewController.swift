//
//  OrdersTableViewController.swift
//  SPA iPad App
//
//  Created by Coder on 2/23/16.
//  Copyright © 2016 OWA. All rights reserved.
//

import UIKit
import AVFoundation

//Retreive the orders
let manager = orderDataSource()
var orderList = manager.fetchingFirstPage()
var orderIDList = manager.fetchingSecondPage()
let manager2 = cartDataSource()
var cartList = manager2.fetchingFirstPage()
var cartIDList = manager2.fetchingSecondPage()

let systemSoundID: SystemSoundID = 1005


var presentingPopUp = false

class OrdersTableViewController: UITableViewController {
    
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer?.volume = 1.0
        
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        //Timer to check for new order to bring in
        let timer1 = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "checkOrder", userInfo: nil, repeats: true)
        
        //Timer to update order list
        let timer2 = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: "checkNew", userInfo: nil, repeats: true)
        
        //Timer to update cart list
        let timer3 = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "checkCart", userInfo: nil, repeats: true)
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cartList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =
        self.tableView.dequeueReusableCellWithIdentifier(
            "orderCell", forIndexPath: indexPath)
            as! OrdersTableViewCell
        
        let row = indexPath.row
        cell.orderLabel.text = cartList[row][0]
        return cell
    }
    
    func checkOrder(){
        if orderList.count >= 1 && presentingPopUp == false{
            
            //playSound("Ding.wav")
            AudioServicesPlaySystemSound (systemSoundID)
            
            presentingPopUp = true
            
            let alertController = UIAlertController(title: "New Order", message: orderList[0][0], preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Deny", style: .Cancel) { (action) in
                orderList.removeFirst()
                
                //Remove from order on server and from ID list
                let dataStore = backendless.data.of(toApprove.ofClass())
                dataStore.removeID(orderIDList[0][0])
                orderIDList.removeFirst()
                
                presentingPopUp = false
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "Accept", style: .Default) { (action) in
                cartList.append(orderList[0])
                
                //Remove from order on server and from ID list
                let dataStore = backendless.data.of(toApprove.ofClass())
                dataStore.removeID(orderIDList[0][0])
                orderIDList.removeFirst()
                
                //Add to cart on server
                let cartThing = toCharge()
                cartThing.item = orderList[0][0]
                cartThing.ownerId = orderList[0][1]
                backendless.persistenceService.of(toApprove.ofClass()).save(cartThing)
                
                orderList.removeFirst()
                
                presentingPopUp = false
                self.tableView.reloadData()
            }
            
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
            
        }
    }
    
    func checkNew(){
        orderList = manager.fetchingFirstPage()
        orderIDList = manager.fetchingSecondPage()
        cartList = manager2.fetchingFirstPage()
        cartIDList = manager2.fetchingSecondPage()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func playSound(soundName: String)
    {
        let coinSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(soundName, ofType: "wav")!)
        do{
            let audioPlayer = try AVAudioPlayer(contentsOfURL:coinSound)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }catch {
            print("Error getting the audio file")
        }
    }
    
    func checkCart(){
        cartList = manager2.fetchingFirstPage()
        cartIDList = manager2.fetchingSecondPage()
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
       return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete
        {
            cartList.removeAtIndex(indexPath.row)
            
            //Remove from order on server and from ID list
            let dataStore2 = backendless.data.of(toCharge.ofClass())
            dataStore2.removeID(cartIDList[indexPath.row][0])
            cartIDList.removeAtIndex(indexPath.row)
            
            self.tableView.reloadData()
        }
    }

}
