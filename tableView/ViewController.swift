//
//  ViewController.swift
//  tableView
//
//  Created by Hector Morales on 2/11/17.
//  Copyright © 2017 Hector Morales. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var Logo: UIImageView!
    
    var searchController: UISearchController!
    var roomVisited = String()
    var roomID = String()
    var names = [String]()
    var searchURL = "https://api.students.brown.edu/laundry/rooms?client_id=8c6cde9c-9053-4e91-886a-bfe3efb3d340"
    typealias JSONStandard = [String : AnyObject]
    var searchActive : Bool = false
    var filtered:[String] = []
    
    var responseMessages = ["111 BROWN ST RM106": "1429213", "125-127 WATERMAN STREET RM003": "1429265","315 THAYER ST": "1429240", "ANDREWS E RM154": "14292350", "ANDREWS W RM160": "1429250", "ARCHIBALD-BRONSON RMA103": "1429212", "BARBOUR APTS RM070": "1429231", "BUXTON HOUSE RM008": "1429215",  "CASWELL MIDDLE RM000": "1429216",  "CASWELL NORTH RM010B": "1429253", "CHAMPLIN RM110A": "1429217", "CHAPIN HOUSE RM023": "1429218", "DIMAN HOUSE RM028": "142927", "DIMAN HOUSE RM106": "1429249", "EVERETT-POLAND RME243": "1429251", "EVERETT-POLAND-RME166": "1429267", "GOODARD HOUSE RM018": "142928", "GOODARD HOUSE RM130": "142922", "GRAD CENTER A RM120": "1429221", "GRAD CENTER B RM113": "1429222", "GRAD CENTER C RM120": "1429220", "GRAD CENTER D RM130": "1429223", "HARKNESS HOUSE RM023": "142929","HARKNESS HOUSE RM106": "1429245","HEDGEMAN D RM009A": "1429224","HOPE COLLEGE RM015": "1429225", "JAMISON-MEAD RMJ055": "1429246", "KING HOUSE RM007": "1429226", "LITTLEFIELD HALL RM011": "1429227",  "MACHADO HOUSE RM209": "1429237", "MARCY HOUSE RM028": "1429210", "METCALF HALL": "1429229", "MILLER HALL": "1429230", "MINDEN HALL RM102": "1429257",  "MORRISS RM211A": "1429254", "MORRISS RM311A": "1429255", "MORRISS RM411A": "1429256", "NPEMBROKE 2 RM000": "1429232", "NPEMBROKE 3 RM000": "1429233", "NPEMBROKE 3 RM020": "1429252","NPEMBROKE 4 RM117": "1429234", "OLNEY HOUSE RM024": "1429211", "PERKINS RM020": "1429235",  "PLANTATIONS HOUSE RM108": "1429236", "SEARS HOUSE RM023": "1429238", "SEARS HOUSE RM106": "1429263", "SLATER HALL RM008": "1429239","VGQA RM001": "1429247", "VGQA RM007": "1429288", "WAYLAND HOUSE RM023": "1429241", "WEST HOUSE RM100B": "1429214",  "WOOLLEY RM101A": "1429219", "WOOLLEY RM201A": "1429258", "WOOLLEY RM301A": "1429259", "WOOLLEY RM401A": "1429260","YO10 RM142": "1429242", "YO2 RM142": "1429243","YO4 RM142": "1429244"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.alpha = 0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        searchActive = false
        tableView.backgroundColor = UIColor.clear
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        callAlamo(url: searchURL)
    }


    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchActive = true;
//        tableView.reloadData()
//    }
    
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchActive = false;
//    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        tableView.alpha = 1
        searchActive = false
        tableView.reloadData()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if filtered.count == 0 {
            searchActive = false
        } else {
            searchActive = true
        }
        filtered = names.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        tableView.reloadData()
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
                    let name = result["name"] as! String
                    names.append(name)
                    tableView.reloadData()
                }
            }
        }
        catch{
            print(error)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        }
        else {
            return names.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if searchActive {
            cell.textLabel?.text = filtered[indexPath.row]
        } else {
            cell.textLabel?.text = names[indexPath.row]
        }
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name:"Opan Sans", size:15)
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in tableView.visibleCells as [UITableViewCell] {
            let point = tableView.convert(cell.center, to: tableView.superview)
            cell.textLabel?.alpha = (700 - point.y)/100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        roomVisited = (cell?.textLabel?.text!)!
        roomID = responseMessages[roomVisited]!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexpath = self.tableView.indexPathForSelectedRow?.row
        let vc = segue.destination as! NewViewController
        if searchActive {
            vc.mainRoomTitle = filtered[indexpath!]
        } else {
            vc.mainRoomTitle = names[indexpath!]
        }
        vc.roomID = responseMessages[vc.mainRoomTitle]!
    }
}

