//
//  LadorCategoryCollectionViewCell.swift
//  Lador
//
//  Created by Developer on 12/29/17.
//  Copyright © 2017 Development. All rights reserved.
//

import UIKit

class LadorCategoryCollectionViewCell: UICollectionViewCell {
    
    func update(model:LadorCategory,cell:LadorCategoryCollectionViewCell){
       
        //label
  
        //image
       
        var image = UIImageView(frame:CGRect(x:self.frame.width/2 - 40 ,y:self.contentView.frame.height/2 - 40 ,width:80,height:80))

        var label = UILabel(frame:CGRect(x:image.frame.origin.x - 40   ,y:image.frame.origin.y + 80  ,width:170,height:50))
        label.text = model.name
        label.textAlignment = .center
        label.font = UIFont(name: "Aracne" , size: 40)
        label.textColor = UIColor.white

        
        


        var escapedString = model.image.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        print(escapedString!)

        let imageDownloadTask = URLSession.shared.dataTask(with: URL(string:escapedString!)!) { data, response, error in
            if let e = error{
                print("error in downloading image")
            }else{
                if(response as? HTTPURLResponse) != nil{

                    if let imageData = data{
                        guard let productImage = UIImage(data: imageData) as UIImage! else {
                            return
                        }
                        DispatchQueue.main.async {
                            image.image = productImage

                        }}}}}
        imageDownloadTask.resume();

    

    
    
    
    cell.contentView.addSubview(label)
    cell.contentView.addSubview(image)
    cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
    }}
