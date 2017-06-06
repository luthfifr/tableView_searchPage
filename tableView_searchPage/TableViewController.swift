//
//  TableViewController.swift
//  tableView_searchPage
//
//  Created by Luthfi Fathur Rahman on 5/21/17.
//  Copyright © 2017 Luthfi Fathur Rahman. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class TableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {

    var TableData:Array<String> = Array <String>()
    var TempTableData:Array<String> = Array <String>()
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    
    @IBOutlet weak var emptyView: UIView!
    
    //struct yang dipakai dari Gloss
    struct daftarProduk: Decodable{
        let prodID: Int?
        let prodName: String?
        let prodCat: String?
        init?(json: JSON){
            self.prodID="id" <~~ json
            self.prodName="name" <~~ json
            self.prodCat="category" <~~ json
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyView.isHidden = true
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            controller.searchBar.delegate = self
            
            return controller
        })()
        
        //Biar ada yang diliat user waktu search product
        Alamofire.request("http://www.luthfifr.com/tutorialdata/ios/productlist/cariproduk.php?cari=produk", method:.get).validate(contentType: ["application/json"]).responseJSON{ response in
            switch response.result{
            case .success(let data):
                guard let value = data as? JSON,
                    let eventsArrayJSON = value["HasilPencarian"] as? [JSON]
                    else { fatalError() }
                let DaftarProduk = [daftarProduk].from(jsonArray: eventsArrayJSON)
                for j in 0 ..< DaftarProduk!.count{
                    self.TempTableData.append((DaftarProduk?[j].prodName!)!)
                }
                break
            case .failure(let error):
                print("Error: \(error)")
                break
            }
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.isActive) {
            return self.filteredTableData.count
        }
        else {
            return TableData.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 127.0/255.0, alpha: 1.0)
        }
        else {
            cell.backgroundColor = UIColor(red: 244.0/255.0, green: 242.0/255.0, blue: 3.0/255.0, alpha: 1.0)
        }
        cell.accessoryType = .disclosureIndicator
        
        if(self.resultSearchController.isActive){
            cell.textLabel?.text = ""
            if (filteredTableData.count != 0) { //(TableData.count == filteredTableData.count) &&
                cell.textLabel?.text = filteredTableData[indexPath.row]
            } else { //if (TableData.count != 0)
                cell.textLabel?.text = TempTableData[indexPath.row]
            }
        } else {
            cell.textLabel?.text = ""
            cell.textLabel?.text = TableData[indexPath.row]
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        if(((currentCell.textLabel!.text) != "") && ((currentCell.textLabel!.text) != nil)){
            performSegue(withIdentifier: "SegueProd", sender: self)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let prodVc = segue.destination as! ViewController
        if segue.identifier == "SegueProd"{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // get the cell associated with the indexPath selected.
                let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
                prodVc.NamaProduk = (currentCell.textLabel!.text)! as String
            }
        }
    }
    
    //untuk ngambil data dari server
    func get_data_from_url(url:String){
        self.TableData.removeAll(keepingCapacity: false)
        Alamofire.request(url, method:.get).validate(contentType: ["application/json"]).responseJSON{ response in
            switch response.result{
            case .success(let data):
                guard let value = data as? JSON,
                    let eventsArrayJSON = value["HasilPencarian"] as? [JSON]
                    else { fatalError() }
                let DaftarProduk = [daftarProduk].from(jsonArray:eventsArrayJSON)
                for j in 0 ..< DaftarProduk!.count{
                    self.TableData.append((DaftarProduk?[j].prodName!)!)
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
                break
            case .failure(let error):
                print("Error: \(error)")
                break
            }
        }
    }
    
    //untuk nampilin search result di tabel waktu user masih ngetik nama produk, sebeleum user menekan search button
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS %@", searchController.searchBar.text!)
        let array = (TempTableData as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [String]
        
        if filteredTableData.isEmpty {
            setEmptyViewVisible(visible: true)
        } else {
            setEmptyViewVisible(visible: false)
        }
        
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let SBText = removeSpecialCharsFromString(text: searchBar.text!)
        self.get_data_from_url(url: "http://www.luthfifr.com/tutorialdata/ios/productlist/cariproduk.php?cari=\(SBText)")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //print("Button cancel in Search Bar is pressed")
        if((searchBar.text) != nil){
            searchBar.text = ""
        }
        setEmptyViewVisible(visible: true)
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.resultSearchController.isActive = false
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
    
    func setEmptyViewVisible(visible: Bool) {
        emptyView.isHidden = !visible
        if visible {
            self.tableView.bringSubview(toFront: emptyView)
        } else {
            self.tableView.sendSubview(toBack: emptyView)
        }
    }
}
