//
//  MasterViewController.swift
//  RIP
//
//  Created by Brian Hill on 11/22/16.
//  Copyright © 2016 cs197. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()

    var reviewer: [String] = []
    var ratings: [String:Int] = [:]
    var review_text: [String:String] = [:]
    var product_name: String = "0767026128"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        json()
        objects = reviewer
        //objects.append(product_name)
    }
    
    //
    
    func json() {
        let datastore_url: URL = URL(string: "http://localhost:8080/product/0767026128/reviews")!
        
        let task = URLSession.shared.dataTask(with: datastore_url, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error)
            } else {
                do {
                    let object = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    self.readJSONobject(object: object as! [String : AnyObject])
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    func readJSONobject(object: [String: AnyObject]) { //break into smaller dictionaries
        let reviews = object["reviews"] as! [[String:AnyObject]]
        for review in reviews {
            print("\(review) \n")
            reviewer.append(review["member_id"] as! String)
            ratings[review["member_id"] as! String] = review["rating"] as! Int?
            review_text[review["member_id"] as! String] = review["text"] as? String
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! String
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.reviewer = self.reviewer
                controller.ratings = self.ratings
                controller.review_text = self.review_text
                controller.product_name = self.product_name
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row] as! String
        cell.textLabel!.text = object
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

