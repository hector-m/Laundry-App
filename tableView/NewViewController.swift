//
//  NewViewController.swift
//  tableView
//
//  Created by Hector Morales on 2/15/17.
//  Copyright © 2017 Hector Morales. All rights reserved.
//

import UIKit
import Alamofire

class NewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    var roomID = String()
    @IBOutlet weak var machinelabel: UILabel!
    var mainRoomTitle = String()
    typealias JSONStandard = [String : AnyObject]
    var Washers = [String]()
    var Dryers = [String]()
    var searchURL = String()
    var Machines = [[String]]()
    var refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        searchURL = "https://api.students.brown.edu/laundry/rooms/"+roomID+"/machines?get_status=true&client_id=8c6cde9c-9053-4e91-886a-bfe3efb3d340"
        callAlamo(url: searchURL)
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        titleLabel.text = mainRoomTitle
        Machines.append(Washers)
        Machines.append(Dryers)
        
        self.collectionView!.alwaysBounceVertical = true
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(NewViewController.refreshStream), for: .valueChanged)
        refreshControl = refresher
        collectionView!.addSubview(refreshControl)
    }
    

    func callAlamo(url : String) {
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            self.parseData(JSONData: response.data!)
        })
    }
    
    func parseData(JSONData : Data) {
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let results = readableJSON["results"] as? [JSONStandard] {
                for i in 0..<results.count {
                    let result = results[i]
                    let name = result["type"] as! String
                    let availabilty = result["avail"] as! Bool
                    let time = result["time_remaining"]
                    if name == "washNdry" {
                        if availabilty == false {
                            Washers.append("\(time!) mins left")
                            Dryers.append("\(time!) mins left")
                        }
                        if availabilty == true {
                            Washers.append("Available")
                            Dryers.append("Available")
                        }
                    } else if name == "washFL" {
                        if availabilty == false {
                            Washers.append("\(time!) mins left")
                        }
                        if availabilty == true {
                            Washers.append("Available")
                        }
                    } else if name == "dblDry" {
                        if availabilty == false {
                            Dryers.append("\(time!) mins left")
                            Dryers.append("\(time!) mins left")
                        }
                        if availabilty == true {
                            Dryers.append("Available")
                            Dryers.append("Available")
                        }
                    } else if name == "dry" {
                        if availabilty == false {
                            Dryers.append("\(time!) mins left")
                        }
                        if availabilty == true {
                            Dryers.append("Available")
                        }
                    }
                }
            }
        Machines[1].append(contentsOf: Dryers)
        Machines[0].append(contentsOf: Washers)
        collectionView.reloadData()
        }
        catch{
            print(error)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Machines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let machine = Machines[section]
        return machine.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
        let machine = Machines[indexPath.section]
        cell.machineLabel.text = machine[indexPath.item]
        if machine[indexPath.item] == "Available" {
            cell.machineImage.image = #imageLiteral(resourceName: "GreenWasher")
        } else {
            cell.machineImage.image = #imageLiteral(resourceName: "RedWasher")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath as IndexPath) as! CollectionHeaderView
            if indexPath == [0,0]{
                headerView.title.text = "Washers"
            } else if indexPath == [1,0]{
                headerView.title.text = "Dryers"
            }
            return headerView
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath as IndexPath)
            return footerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func refreshStream() {
        self.collectionView?.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func prepareForUnwind (segue: UIStoryboardSegue) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
