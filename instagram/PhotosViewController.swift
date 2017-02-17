//
//  PhotosViewController.swift
//  
//
//  Created by Linh Le on 2/16/17.
//
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var photos = [NSDictionary]()
    var selectedPhoto = 0
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let refreshController = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
        refreshController.addTarget(self, action: #selector(refreshControllerAction(refreshController:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshController, at: 0)
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
        if photos.count != 0 {
            
            let images = (photos[indexPath.row])["images"] as! NSDictionary
            let low_resolution = (images["low_resolution"] as! NSDictionary)["url"] as! String
            ///((photos[indexPath.row]["images"] as! Dictionary)["thumbnail"] as! Dictionary)["url"] as! String
            
            cell.userPhoto.setImageWith(URL(string: low_resolution)!)
        }
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPhoto = indexPath.row
    }
    
    
    func loadData() {
        let userId = "435569061"
        let accessToken = "435569061.c66ada7.5aac54e38a6a46169f9264f4242cdd99"
        let url = URL(string: "https://api.instagram.com/v1/users/\(userId)/media/recent/?access_token=\(accessToken)")
        
        if let url = url {
            let request = URLRequest(
                url: url,
                cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
                timeoutInterval: 10)
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: nil,
                delegateQueue: OperationQueue.main)
            let task = session.dataTask(
                with: request,
                completionHandler: { (dataOrNil, response, error) in
                    if let data = dataOrNil {
                        if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            if let photoData = responseDictionary["data"] as? [NSDictionary] {
                                self.photos = photoData
                                self.tableView.reloadData()
                                self.refreshController.endRefreshing()
                            }
                        }
                    }
            })
            task.resume()
        }
    }
    
    func refreshControllerAction(refreshController: UIRefreshControl) {
        loadData()
    }

    // MARK: - Navigation

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new vie controller.
        let de = segue.destination as! PhotosDetailViewController
        let images = (photos[selectedPhoto] )["images"] as! NSDictionary
        let standard_resolution = (images["standard_resolution"] as! NSDictionary)["url"] as! String
        de.url = standard_resolution

    }
 

}
