//
//  DetailViewController.swift
//  Movies
//
//  Created by Leonardo Talero on 1/27/16.
//  Copyright © 2016 unir. All rights reserved.
//

import UIKit
import iAd

class DetailViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var title_detail: UILabel!
    
    @IBOutlet weak var image_detail: UIImageView!
    @IBOutlet weak var backdrop_detail: UIImageView!
    
    @IBOutlet weak var date_detail: UILabel!
  
    @IBOutlet weak var rate_detail: UILabel!
    
    @IBOutlet weak var detscription_detail: UILabel!
    
    @IBOutlet weak var genres_detail: UITableView!
    
    var movie:Movie!;
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
        movie = (self.detailItem as? Movie)!
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item. if let detail: Movie  = self.detailItem as! Movie {
        //let detail =Movie() self.detailItem as! Movie
        
        if let detail = self.detailItem as? Movie {
            if let label = self.title_detail {
                label.text = detail.title_movie
            }
            if let label_rate = self.rate_detail {
                label_rate.text = detail.rate_movie.description
            }
            if let label_detscription = self.detscription_detail {
                label_detscription.text = detail.detail_movie
            }
            if let image_detail = self.image_detail {
                image_detail.image=detail.imgg
            }
            if let date_detail = self.date_detail {
                date_detail.text=detail.release_date
            }
            if let backdrop_detail = self.backdrop_detail {
                backdrop_detail.image=detail.image_movie_backdrop_imgg
            }

        }
        
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.canDisplayBannerAds = true
       
        movie = self.detailItem as? Movie
        genres_detail.delegate = self
        genres_detail.dataSource = self
        
        self.navigationItem.leftBarButtonItem=splitViewController?.displayModeButtonItem()
        self.navigationItem.leftItemsSupplementBackButton=true
        //self.navigationItem.title="Popular"
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(genres_detail:UITableView, numberOfRowsInSection section: Int) -> Int {
        if(movie == nil){
            return 0
        }else{
            return (movie?.genres_object.count)!
        }
   
    }
    
    func numberOfSectionsInTableView(genres_detail:UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(genres_detail:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = genres_detail.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
       // var i = (movie?.genres[indexPath.row].description);
        cell.textLabel?.text = movie?.genres_object[indexPath.row].name
        
        
        return cell
    }

    
    

}

