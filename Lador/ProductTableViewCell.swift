//
//  ProductTableViewCell.swift
//  Lador
//
//  Created by Developer on 12/27/17.
//  Copyright © 2017 Development. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    let name  = UILabel();
    let itemImage = UIImageView();
    let desc =  UILabel()
    let price = UILabel();
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(model:LadorProduct,row:Int,cell:ProductTableViewCell){
      
        
       
        if(row%2 == 0){
            name.frame = CGRect(x: 359, y: 10, width: 300, height: 63)
            itemImage.frame = CGRect(x:65,y:10,width:270,height:234);
            desc.frame = CGRect(x: 359, y: 60, width: 350, height: 90)
            price.frame = CGRect(x: 359, y: 180, width: 180, height: 63);
            
            name.textAlignment = .left
            desc.textAlignment = .left
            price.textAlignment = .left
            

        }
        else{
            name.frame = CGRect(x: cell.frame.width - 359 - 300.0, y: 10, width: 300, height: 63)
            itemImage.frame = CGRect(x:cell.frame.width - 65.0 - 270.0,y:10,width:270,height:234);
            desc.frame = CGRect(x: cell.frame.width - 359 - 350, y: 60, width: 350, height: 90)
            price.frame = CGRect(x: self.frame.width - 359 - 180.0, y: 180, width: 180, height: 63);
            
            name.textAlignment = .right
            desc.textAlignment = .right
            price.textAlignment = .right;
            


        }
        
        
        desc.numberOfLines = 3;
        
        //setcorners
        itemImage.layer.cornerRadius = 10
        itemImage.clipsToBounds = true

        //setfonts
            name.font = UIFont(name: "Aracne" , size: 60)
            desc.font = UIFont(name: "Averta-LightItalic" , size: 20)
            price.font = UIFont(name: "Aracne" , size: 60)
        
        
        
        
        //set colors
        name.textColor = UIColor.white
        price.textColor = UIColor.init(red: 255, green: 242, blue: 0, alpha: 1)
        desc.textColor = UIColor.gray
        
        let PictureURL = URL(string: model.image)!
        let PictureName = "product_image_" + PictureURL.deletingPathExtension().lastPathComponent + String(describing:model.id)
      
        let imageFromCache =  CacheManager.get(identifier: PictureName)
       
        if imageFromCache != nil {
            itemImage.image = imageFromCache;
        }
        else {
        let imageDownloadTask = URLSession.shared.dataTask(with: NSURL(string:model.image)! as URL) { data, response, error in
            if error != nil{
                print("error in downloading image")
            }else{
                if(response as? HTTPURLResponse) != nil{
                    if let imageData = data{
                        guard let i = UIImage(data: imageData) as UIImage! else {
                            return
                        }
                        CacheManager.set(image: i, identifier: PictureName)

                        DispatchQueue.main.async {
                            self.itemImage.image = i;
                        }}}}}
        
        imageDownloadTask.resume();
        }
        
       
        //set values
        name.text = model.name;
        price.text = String(describing:model.price).appending(" AZN");
        desc.text = model.desc;
        
        
        
       // adding to stack
        let stackView = UIStackView();
        stackView.addSubview(name)
        stackView.addSubview(itemImage)
        stackView.addSubview(desc)
        stackView.addSubview(price)
        //add to contentview
        
        cell.contentView.addSubview(stackView)
        }

}
