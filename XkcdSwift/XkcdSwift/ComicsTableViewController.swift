//
//  ComicsTableViewController.swift
//  XkcdSwift
//
//  Created by Jon Friskics on 9/27/14.
//  Copyright (c) 2014 Code School. All rights reserved.
//

import UIKit

class ComicsTableViewController: UITableViewController {

    // MARK: ------ Input Properties

    // MARK: ------ Property declarations

    var dataSource:NSArray?

    // MARK: ------ Lazy Property Initializers

    lazy var session:NSURLSession? = {
        return NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }()
    
    lazy var headerView:UIView! = {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.whiteColor()
        return headerView
    }()
    
    lazy var headerImageView:UIImageView! = {
        let headerImageView = UIImageView()
        return headerImageView
    }()
    
    // MARK: ------ Initializers

    override init(style: UITableViewStyle) {
        super.init(style: style)
        setupDataSource()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibName, bundle: nibBundleOrNil)
    }

    // MARK: ------ Setup methods

    func setupDataSource() -> Void {
        let currentComicURLRequest = NSURLRequest(URL: NSURL(string: "http://xkcd.com/info.0.json"))
        
        let task:NSURLSessionDataTask? = session?.dataTaskWithRequest(currentComicURLRequest, completionHandler: {(data: NSData!, response: NSURLResponse!, error: NSError!) in
            
            var jsonParsingError:NSError?
            let jsonResponse = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonParsingError) as NSDictionary?
            
            if let jsonResp = jsonResponse {
                let rowCount = jsonResp["num"] as Int
                
                var mutableArray = NSMutableArray()
                
                for(var i=0; i < rowCount; i++) {
                    let comic = ["comicNumber": i]
                    mutableArray.addObject(comic)
                }
                
                var reverseSortDescriptor = NSSortDescriptor(key: "comicNumber", ascending: false)
                mutableArray.sortUsingDescriptors([reverseSortDescriptor])
                
                self.dataSource = mutableArray as NSArray
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            } else {
                println("Error reading json \(jsonParsingError!.localizedDescription)")
            }
        })
        
        task?.resume()
    }

    // MARK: ------ View Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "comicCell")
        
        headerImageView.image = UIImage(named: "terrible_small_logo")
        
        headerView.addSubview(headerImageView)
        
        tableView.tableHeaderView = headerView
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.frame = view.frame
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        headerView.frame = CGRect(x: 0, y: 0, width: 320, height: 100)

        headerImageView.sizeToFit()
        headerImageView.frame = CGRect(x: CGRectGetMidX(headerView.frame) - headerImageView.frame.size.width / 2, y: CGRectGetMidY(headerView.frame) - headerImageView.frame.size.height / 2, width: headerImageView.frame.size.width, height: headerImageView.frame.size.height)
    }
    
    // MARK: ------ Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ds = dataSource {
            return ds.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("comicCell", forIndexPath: indexPath) as UITableViewCell
        
        if let dict = dataSource?[indexPath.row] as? NSDictionary {
            cell.textLabel?.text = String(dict["comicNumber"] as Int)
        }
        
        return cell
    }
    
    // MARK: ------ Table view delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var comicVC = ComicViewController(passedInComic: dataSource?[indexPath.row] as NSDictionary)

        navigationController?.pushViewController(comicVC, animated: true)
    }
    
}
