//
//  ProductsTableViewController.swift
//  Lador
//
//  Created by Developer on 12/27/17.
//  Copyright © 2017 Development. All rights reserved.
//

import UIKit
import os.log
class ProductsTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {


    
    
    var listOfProducts = [LadorProduct]();
    var selectedCategoryId:Int = 0;
    let URL = "http://bakudynamics.com/api/v1/lador/items/";
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.myTableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "Cell")
//        self.navigationController?.navigationBar.isHidden = false
//        myTableView.delegate = self;
//        myTableView.dataSource = self;
        print(myTableView)
        self.loadProducts()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    func loadProducts(){
        
        let url = NSURL(string:URL+String(selectedCategoryId))
        var request = URLRequest(url: url as! URL, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
        request.httpMethod = "GET";
        
        let task = URLSession.shared.dataTask(with: request){data,response,error in
            
            if(error != nil){
                print(error?.localizedDescription)
            }
            else{
                do{
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                        os_log("Status code is not 200!", log: OSLog.default, type: .debug)
                        return
                    }
                    else{
                        
                        let jsonResultArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                            as! [String:AnyObject]
                        guard let responseCode = jsonResultArray["success_code"] as? Int else {
                            os_log("No response code", log: OSLog.default, type: .debug)
                            return
                        }
                        
                        let resultArray = jsonResultArray["data"] as! [[String:AnyObject]]
                       
                        var model :LadorProduct;
                        for json in resultArray{
                            
                            let id = json["id"] as! Int
                            let name = json["name"] as! String
                            let desc = json["description"] as! String
                            let image = json["image"] as! String
                            
                            let price = json["price"] as! String
                            let category_id = json["category_id"] as! String
                            let created_at = json["created_at"] as! String
                            let updated_at = json["updated_at"] as! String
                            
                            model = LadorProduct(id: id,name: name,desc: desc,category_id: Int(category_id)!,image: image,price: Double(price)!,created_at: created_at,updated_at: updated_at)!;
                            self.listOfProducts.append(model);
                            
                        }
                        self.setDataToView();
                    }
                    
                    
                }
                    
                    
                    
                    
                catch{
                    os_log("Erron in JSON serialization", log: OSLog.default, type: .debug)
                    
                }
            }
            
            
            
        }
        task.resume();
        
        
    }
    
    func setDataToView(){
        DispatchQueue.main.async {
//        self.myTableView.reloadData()
            print("countt = \(self.listOfProducts.count)")
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128.2
    }
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfProducts.count
    }

   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if let myCell = cell as? ProductTableViewCell{
            myCell.updateUI(model: listOfProducts[indexPath.row],row: indexPath.row,cell:myCell);
        }
        
        return cell
    }
   
   
    
}
