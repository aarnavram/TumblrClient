//
//  PhotosViewController.swift
//  Tumblr-Client
//
//  Created by Aarnav Ram on 02/02/17.
//  Copyright © 2017 Aarnav Ram. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    var isMoreDataLoading = false
    var limit = 20;

    var posts: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //tableView.rowHeight = 240
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        refreshControlAction(refreshControl)
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                loadMoreData()
                isMoreDataLoading = true
                
            }
            
        }
    }
    
    func loadMoreData() {
        limit = limit + 3;
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&limit=\(limit)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.isMoreDataLoading = false;
                        self.tableView.reloadData()
                    }
                }
        });
        MBProgressHUD.hide(for: self.view, animated: true)
        task.resume()
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        limit = 20;
        // Configure session so that completion handler is executed on main UI thread
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&limit=\(limit)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.tableView.reloadData()
                    }
                }
                refreshControl.endRefreshing()
        });
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoViewCell
        cell.selectionStyle = .none
        let post = self.posts[indexPath.row]

        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            if let imageURL = URL(string: imageUrlString!) {
                
                let name = post.value(forKeyPath: "blog_name") as? String
                print(name)
                cell.backgroundColor = UIColor.black
                cell.userLabel.text = name
                cell.userLabel.textColor = UIColor.white
                cell.posterImage.setImageWith(imageURL)
                let iconURL = URL(string: "https://api.tumblr.com/v2/blog/\(name!).tumblr.com/avatar")
                cell.iconView.setImageWith(iconURL!)
                cell.iconView.layer.cornerRadius = 20
                cell.iconView.layer.borderColor = UIColor.white.cgColor
                cell.iconView.layer.borderWidth = 3
                cell.layer.masksToBounds = true
                if let summaryText = post.value(forKey: "summary") as? String {
                    cell.summary.textColor = UIColor.white
                    cell.summary.text = summaryText
                }
            }
        }
        

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! PhotoViewCell
        let destinationViewController = segue.destination as! PhotoDetailsViewController
        destinationViewController.image = cell.posterImage.image
        
    }
 

}
