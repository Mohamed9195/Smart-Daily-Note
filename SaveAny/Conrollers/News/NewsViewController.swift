//
//  NewsViewController.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/7/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD



class NewsViewController: UIViewController {

    @IBOutlet weak var newsTable: UITableView!
    
    var count: Int? = 0
    var count2: Int? = 0
    var DataResef: JSON?
    
    @IBOutlet weak var refreshbutton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
 
        refreshbutton.isEnabled = false
        newsTable.rowHeight = UITableView.automaticDimension
    }
  
    @IBAction func loadnews(_ sender: Any) {
        SVProgressHUD.show()
        Alamofire.request("https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=6e83053abd624955a30459274157aa04").responseJSON {
            response in
            
            if response.result.isSuccess {
                
                let Data: JSON = JSON(response.result.value!)
                self.DataResef = Data
                self.count =  Data["articles"].count
                print(Data["articles"].count)
                print(Data["articles"][0]["urlToImage"].string!)
                self.newsTable.reloadData()
                SVProgressHUD.dismiss()
            }
            else {
                
            }
        }
        newsTable.reloadData()
        SVProgressHUD.dismiss()
        refreshbutton.isEnabled = true
    }
    
    
    @IBAction func refreshTable(_ sender: Any) {
        
//        DispatchQueue.global(qos: .userInitiated).sync {
//            Alamofire.request("https://newsapi.org/v2/everything?sources=bbc-news&apiKey=6e83053abd624955a30459274157aa04").responseJSON {
//                response in
//                if response.result.isSuccess {
//                    
//                    let Data: JSON = JSON(response.result.value!)
//                    self.DataResef = Data
//                    self.count2 =  Data["articles"].count
//                    print(Data["articles"].count)
//                    print(Data["articles"][0]["urlToImage"].string!)
//                    //self.newsTable.reloadData()
//                    
//                }
//                else {
//                    
//                }
//            }
//            
//            DispatchQueue.main.async {
//                self.newsTable.reloadData()
//            }
//        }
//        
         SVProgressHUD.show(withStatus: "loading......")
        Alamofire.request("https://newsapi.org/v2/everything?sources=bbc-news&apiKey=6e83053abd624955a30459274157aa04").responseJSON {
            response in
            if response.result.isSuccess {

                let Data: JSON = JSON(response.result.value!)
                self.DataResef = Data
                self.count2 =  Data["articles"].count
                print(Data["articles"].count)
                print(Data["articles"][0]["urlToImage"].string!)
                self.newsTable.reloadData()

            }
            else {

            }
        }
        newsTable.reloadData()
    }
    
    

}
extension NewsViewController : UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "Top News"
//        }else{
//            return "All News"
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if count2 == 0 {
             return count ?? 1
        }else{
            return count2 ?? 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        SVProgressHUD.show()
        
        
        let catPictureURL = URL(string: DataResef!["articles"][indexPath.row]["urlToImage"].string!)!
        let temp = try? Data(contentsOf: catPictureURL)
        cell.imageNews.image = UIImage(data: temp!)
        cell.labelHeader.text = DataResef!["articles"][indexPath.row]["description"].string
        cell.lablecontent.text = DataResef!["articles"][indexPath.row]["content"].string
        if indexPath.row == count! - 1 {
            SVProgressHUD.dismiss()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let url = URL(string: DataResef!["articles"][indexPath.row]["url"].string!),
//            UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: [:])
//        }
        if let url = URL(string: DataResef!["articles"][indexPath.row]["url"].string!) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
