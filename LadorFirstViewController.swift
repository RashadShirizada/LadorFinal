//
//  ViewController.swift
//  CM
//
//  Created by Developer on 12/24/17.
//  Copyright © 2017 Development. All rights reserved.
//

import UIKit
import os.log
class LadorFirstViewController:UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    var nav = UINavigationBar();

    let url = "http://bakudynamics.com/api/v1/lador/categories"
    var listOfCategories = [LadorCategory]()
    var matrixOfCategories = [[LadorCategory]()]
    var index :Int = 0;
    var selectedRow:Int = 0;
    var checkGroupModels = false;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isUserInteractionEnabled = false;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
self.tableView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.loadCategories()
        
        
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LadorFirstViewController.menuTapped(gesture:)))
        // add it to the image view;
        menuLabel.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        menuLabel.isUserInteractionEnabled = true

         }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
  
    @objc func menuTapped(gesture: UIGestureRecognizer) {
        print("tapped")
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UILabel) != nil {
            self.dismiss(animated: false, completion: nil )

        }
    }

    func  loadCategories(){
        
        
        let url = URL(string: self.url);
        
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {data, response , error in
            
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
                        DispatchQueue.main.async {
                            self.tableView.isUserInteractionEnabled = true;
                        }
                        
                        let jsonResultArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                            as! [String:AnyObject]
                        guard let responseCode = jsonResultArray["success_code"] as? Int else {
                            os_log("No response code", log: OSLog.default, type: .debug)
                            return
                        }
                        
                        let resultArray = jsonResultArray["data"] as! [[String:AnyObject]]
                        
                        var model :LadorCategory?
                        for json in resultArray {
                            
                            let id = json["id"] as! Int;
                            let name = json["name"] as! String
                            let desc = json["description"] as! String
                            
                            let image = json["image"] as! String
                            let bg = json["bg"]  as! String
                            let created_at = json["created_at"] as! String
                            let updated_at = json["updated_at"] as! String
                            model = LadorCategory(id: id,name: name,descript: desc,image: image,bg:bg,created_at: created_at,updated_at: updated_at);
                            self.listOfCategories.append(model!);
                        }
                        self.groupModels(list: self.listOfCategories)
                    }
                    
                }
                    
                    
                    
                    
                catch{
                    os_log("Erron in JSON serialization", log: OSLog.default, type: .debug)
                    
                }
            }
            
            
        }
        task.resume();
    }
    
    
    func groupModels(list:[LadorCategory]){
        print("GROUPMODELS")
        self.matrixOfCategories.removeAll();
        var l = [LadorCategory]();
        var i = 0;
        while i != list.count{
            
            for _  in 0...1{
                l.append(list[i])
                i = i + 1;
            }
            
            self.matrixOfCategories.append(l)
            l.removeAll()
            
        }
        DispatchQueue.main.async {
            self.checkGroupModels = true;
            self.tableView.reloadData()
        }
        
    }
    
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matrixOfCategories.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LadorCategoryTableViewCell
        index = indexPath.row;
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.layer.backgroundColor = UIColor.clear.cgColor
        guard let tableViewCell = cell as? LadorCategoryTableViewCell else { return }
                tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.height - 95) / 4;
    }

}


//
extension LadorFirstViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 2;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LadorCategoryCollectionViewCell
        var xOrigin :CGFloat;
        xOrigin = 0;
        if(indexPath.row != 0){
            xOrigin +=  self.view.frame.width / CGFloat(collectionView.numberOfItems(inSection: indexPath.section)) * CGFloat(indexPath.row)
            
        }
        cell.frame = CGRect(x:xOrigin, y:0, width:collectionView.frame.width / 2,height: (self.view.frame.height-95)/4)
        if(self.checkGroupModels){

                cell.update(model: matrixOfCategories[index][indexPath.row],cell:cell);

            }
       
      return cell
    }
   
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc:
            ProductListViewController = UIStoryboard(
                name: "Main", bundle: nil
                ).instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
        // .instantiatViewControllerWithIdentifier() returns AnyObject!
        // this must be downcast to utilize it
        vc.selectedCategoryId = matrixOfCategories[collectionView.tag][indexPath.row].id;
        vc.categoryName.text = matrixOfCategories[collectionView.tag][indexPath.row].name
        vc.imageURl = matrixOfCategories[collectionView.tag][indexPath.row].bg;
        vc.categoryName.font = UIFont(name: "Aracne" , size: 90)
        vc.categoryName.textColor = UIColor.white

                self.present(vc, animated: false, completion: nil)
        
    }



}




