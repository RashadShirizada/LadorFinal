//
//  ProductListViewController.swift
//  
//
//  Created by Developer on 12/28/17.
//

import UIKit
import os.log
class ProductListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var listOfProducts = [LadorProduct]();
        var selectedCategoryId:Int = 0;
    var imageURl:String!;
        let URL = "http://bakudynamics.com/api/v1/lador/items/";
    var myTableView = UITableView();
    var categoryName  = UILabel();
    var cn:String!;
    var backButton :UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//ATTENTION HERE
       self.setTableViewConfiguration()
                self.loadProducts()
        self.uploadImage()
       self.setCategoryNameConfiguration()
        self.setBackButtonConfiguration()
        }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    func setCategoryNameConfiguration(){
        
        self.view.addSubview(categoryName)
        categoryName.frame = CGRect(x:0,y:58,width:self.view.frame.width,height:94)
        categoryName.textAlignment = .center
    }
    func setTableViewConfiguration(){
        self.myTableView = UITableView(frame: CGRect(x:10,y:204,width:self.view.frame.width,height:self.view.frame.height - 204 ))
        self.myTableView.dataSource = self
        self.myTableView.alwaysBounceVertical = true;
        self.myTableView.delegate = self
        self.myTableView.backgroundColor = UIColor.clear
        self.myTableView.separatorStyle = .none
        
        
        self.myTableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(myTableView)
    }
    func setBackButtonConfiguration(){
        var stackView = UIStackView(frame:CGRect(x:0,y:10,width:180,height:150));
        backButton = UIImageView(frame:CGRect(x:40.96,y:39.82,width:22.67,height:41.18));
        backButton.image = UIImage(named: "back")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonClick(tapGestureRecognizer:)))
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(tapGestureRecognizer)
        
      stackView.addSubview(backButton)
        self.view.addSubview(stackView)
        
    }
    
    @objc func backButtonClick(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let vc:  LadorFirstViewController = UIStoryboard(                name: "Main", bundle: nil                ).instantiateViewController(withIdentifier: "LadorFirstViewController") as! LadorFirstViewController
        self.dismiss(animated: false, completion: nil )
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                return 310
            }
  
    
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                // #warning Incomplete implementation, return the number of rows
                return listOfProducts.count
            }
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductTableViewCell
             

               
                    cell.backgroundColor = UIColor.clear
                    cell.tag = indexPath.row
                    cell.updateUI(model: listOfProducts[indexPath.row],row: indexPath.row,cell:cell);
                var imageView = UIImageView(frame:CGRect(x:30,y:0,width:cell.frame.width - 80,height:cell.frame.height - 53.6))
                imageView.image = UIImage(named:"border")
                cell.addSubview(imageView)
                
                return cell
            }
    

    func loadProducts(){
        
                let url = NSURL(string:URL+String(selectedCategoryId))
                var request = URLRequest(url: url as! URL, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
                request.httpMethod = "GET";
        
                let task = URLSession.shared.dataTask(with: request){data,response,error in
        print("response = \(response)")
                    print("error = \(error)")
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

                                DispatchQueue.main.async {
                                    self.myTableView.reloadData()
                                    print("countt = \(self.listOfProducts.count)")
                                }
                            }
        
        
                        }
        
        
        
        
                        catch{
                            os_log("Erron in JSON serialization", log: OSLog.default, type: .debug)
        
                        }
                    }
        
        
        
                }
                task.resume();
        
        
            }
    func uploadImage(){
   print("upload image")
        
        
        var a = "http://bakudynamics.com/images/bg/salatlar.jpg"
     var escapedString = self.imageURl.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
//        print(escapedString)
//
//        print("url = \(url)")
        let session = URLSession(configuration: .default)
     let url = NSURL(string:escapedString )! as URL
        
        let imageDownloadTask = session.dataTask(with: url) { data, response, error in
            print("imagedownloadtaksda")
            if let e = error{
                print("error in downloading image")
            }else{
                if(response as? HTTPURLResponse) != nil{
                    
                    if let imageData = data{
                        guard let productImage = UIImage(data: imageData) as UIImage! else {
                            return
                        }
                        DispatchQueue.main.async {
                            self.backgroundImage.image = productImage;
                        }}}}}
        imageDownloadTask.resume();
        
        

    }
 
    
}


