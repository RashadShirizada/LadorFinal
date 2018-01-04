//
//  ViewController.swift
//  CM
//
//  Created by Developer on 12/24/17.
//  Copyright © 2017 Development. All rights reserved.
//

import UIKit
import os.log
class ViewController:UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let url = "http://bakudynamics.com/api/v1/lador/categories"
    var listOfCategories = [LadorCategory]()
    var matrixOfCategories = [[LadorCategory]()]
    var index :Int = 0;
    var selectedRow:Int = 0;
    var checkGroupModels = false;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self;
        tableView.dataSource = self;
        self.tableView.register(LadorCategoryTableViewCell.self, forCellReuseIdentifier: "LadorCategoryTableViewCell")
        
        self.loadCategories()
    }
    
    
    
    func  loadCategories(){
        
        print("loadcategoires")
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
                            let created_at = json["created_at"] as! String
                            let updated_at = json["updated_at"] as! String
                            model = LadorCategory(id: id,name: name,descript: desc,image: image,created_at: created_at,updated_at: updated_at);
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
//    func uploadImage(url:URL,cell:CategoryCollectionViewCell){
//        print("url");
//        let imageDownloadTask = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let e = error{
//                print("error in downloading image")
//            }else{
//
//                if(response as? HTTPURLResponse) != nil{
//
//                    if let imageData = data{
//                        guard let productImage = UIImage(data: imageData) as UIImage! else {
//                            os_log("Couldn't get image: Image is nil", log: OSLog.default, type: .debug)
//                            return
//                        }
//                        DispatchQueue.main.async {
//
////                            cell.menuItemImage.image = productImage;
//
//                        }
//                    }
//
//                }
//
//            }
//
//        }
//        imageDownloadTask.resume();
//
//    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matrixOfCategories.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LadorCategoryTableViewCell", for: indexPath)
        index = indexPath.row;
        cell.backgroundColor = UIColor.red
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SDADASDASDASDASDASDSADs \(indexPath.row)")
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard let myCell = cell as? CategoryTableViewCell else{return}
//        print("collection setde   mycell = \(myCell)")

    }
    
}


//
//extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 2;
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
//
////        if(self.checkGroupModels){
////            cell.menuItemName.text = matrixOfCategories[index][indexPath.row].name;
////            if(matrixOfCategories[index][indexPath.row].id != 1){
////
////                self.uploadImage(url: URL(string:matrixOfCategories[index][indexPath.row].image)!, cell: cell)
////            }}
//        return CategoryCollectionViewCell()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(collectionView.tag)
//        let vc = ProductListViewController() //your view controller
//        vc.selectedCategoryId = matrixOfCategories[collectionView.tag][indexPath.row].id;
//        vc.categoryName.text = matrixOfCategories[collectionView.tag][indexPath.row].name
//        vc.categoryName.font = UIFont(name: "Aracne" , size: 90)
//        vc.categoryName.textColor = UIColor.white
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//
//
//}



