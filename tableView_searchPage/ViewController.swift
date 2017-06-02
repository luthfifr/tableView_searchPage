//
//  ViewController.swift
//  tableView_searchPage
//
//  Created by Luthfi Fathur Rahman on 5/19/17.
//  Copyright © 2017 Luthfi Fathur Rahman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var NamaProduk: String!
    
    @IBOutlet weak var Prod_nama: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Prod_nama.text = NamaProduk!
        Prod_nama.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

