//
//  MasterViewController.swift
//  Movies
//
//  Created by Leonardo Talero on 1/27/16.
//  Copyright © 2016 unir. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import iAd
//import SwiftyJSON



class MasterViewController: UITableViewController ,ADBannerViewDelegate {
    var movies:Array<Movie>?
    var moviesTOP:Array<Movie>?
    
    var moviesWrapper:MovieWrapper? // holds the last wrapper that we've loaded
   
    var genres:Array<Genre>?
    var genresWrapper:GenreWrapper? // holds the last wrapper that we've loaded
    
    var isLoadingMovies = false
    var isLoadingGenres = false
    var populatingMovies = false,errorLoadingMovies=false
    var currentPage = 1
    var currentPageTOP = 1
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet weak var segmented: UISegmentedControl!
    
    var detailViewController: DetailViewController? = nil
    
    var objects = [AnyObject]()
    var MovieCache_ = Dictionary<String, Movie>()
   
    
    
    let moviewrapperCache = NSCache()
    var imageCache = NSCache()
    let genreCache = NSCache()
    let scrollView = UIScrollView()
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    var flag_ = false
    var listadopopular = List_Page();
    var listadoTOP = List_Page();
    var listadoclase = Array<List_Page>();
    let mediumRectAdView = ADBannerView(adType: ADAdType.MediumRectangle) //Create banner
   // var bannerView: ADBannerView!
    let banner = ADBannerView(adType: .Banner)
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //self.canDisplayBannerAds = true
        //mediumRectAdView!.delegate = self;
        
        
        
        
        
        self.listadopopular.listado="Popular"
        self.listadopopular.pages=Array<Int>();
        self.listadoTOP.listado="TOP"
        self.listadoTOP.pages=Array<Int>();
        self.listadoclase.append(self.listadopopular)
        self.listadoclase.append(self.listadoTOP)
        if((self.genreCache.objectForKey("genres")) == nil){
            self.loadGenres();

        }
        self.populateMovies()
        self.setupView();
        
        
        if #available(iOS 9.0, *) {
            if( traitCollection.forceTouchCapability == .Available){
                
               // registerForPreviewingWithDelegate(self, sourceView: view)
                
            }
        } else {
            // Fallback on earlier versions
        }
        
        // Do any additional setup after loading the view, typically from a nib.
       // self.navigationItem.leftBarButtonItem = self.editButtonItem()
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
       // let indexpath=NSIndexPath(forRow: 0, inSection: 0);
       // self.tableview.selectRowAtIndexPath(indexpath, animated: true, scrollPosition: .Top)
        
        
    }
    
    
    //Delegate methods for AdBannerView
    
 
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.view.addSubview(banner)
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        banner.removeFromSuperview()
    }
    func setupView() {
       
        
      
    }


    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        self.canDisplayBannerAds = true
        self.banner.delegate = self
       /* let myPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableview.selectRowAtIndexPath(myPath, animated: false, scrollPosition:UITableViewScrollPosition.None )*/
       
       // self.tableView(tableView, didSelectRowAtIndexPath: myPath);
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        /*let myPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableview.selectRowAtIndexPath(myPath, animated: false, scrollPosition:UITableViewScrollPosition.None )*/
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        
        
        let movie:Movie = Movie();
        
        movie.title_movie = "";
        movie.rate_movie = 8.45;
        movie.detail_movie = "";
        movie.image_movie = "";
        movie.imgg=UIImage(named: "buddy.jpg");
        
        objects.insert(movie, atIndex: 0)
        
        
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! Movie
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objects.isEmpty
        {
            return 0
        }
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Celda", forIndexPath: indexPath) as! TableViewCell
       
        let object = objects[indexPath.row] as! Movie
        
        self.MovieCache_[object.title_movie] = object;
        
        
        cell.title_!.text = object.title_movie;
        cell.detail_!.text = object.rate_movie.description;
        cell.vote.text=object.vote_average.description;
        cell.image_.image=nil
        
        cell.indicator.startAnimating()
        let imageURL = object.image_movie
        
        if(object.imgg != nil)
        {
        cell.image_.image = object.imgg
        self.imageCache.setObject(object.imgg!, forKey: object.id)
            cell.indicator.stopAnimating()
        }else if((self.imageCache.objectForKey(object.id)) != nil){
            cell.image_.image=self.imageCache.objectForKey(object.id) as? UIImage;
              cell.indicator.stopAnimating()
        }else{
        
             Alamofire.request(.GET, imageURL).response() {
                (_, _, data, _) in
                
                let image = UIImage(data: data!)
                cell.image_.image = image
                  cell.indicator.stopAnimating()
                if(image != nil){
                   self.imageCache.setObject(image!, forKey: object.id)
                     object.imgg=image
                }
               
                
               
                
            }
            
        }
        if(self.moviesWrapper != nil){
            self.moviewrapperCache.setObject(self.moviesWrapper!, forKey: "moviesgrapper")
        }

       
        cell.indicator.hidesWhenStopped=true
   
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    
  
    
  
    func loadGenres()
    {
        isLoadingGenres = true
        ApiController.getGenres({ wrapper, error in
            if let error = error
            {
                // TODO: improved error handling
                self.isLoadingGenres = false
                let alert = UIAlertController(title: "Error", message: "Could not load Genres \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.addGenresFromWrapper(wrapper)
            self.isLoadingGenres = false
            /*if(!self.isLoadingMovies){
                self.spinner.stopAnimating();
            }*/
            //self.tableview?.reloadData()
        })
    }
    
   
    func addMoviesFromWrapper(wrapper: MovieWrapper?)
    {
        self.moviesWrapper = wrapper
        if self.movies == nil
        {
            self.movies = self.moviesWrapper?.movies
        }
        else if self.moviesWrapper != nil && self.moviesWrapper!.movies != nil
        {
            self.movies = self.movies! + self.moviesWrapper!.movies!
           
        }
        
        if(self.movies != nil){
            objects.removeAll();
            
            for movie in self.movies!{
                if(self.genres != nil){
                  
                    
                    if(movie.genres_object.isEmpty){
                        for genre_int in  movie.genres{
                            
                            let genrenew=self.genreCache.objectForKey(genre_int) as? Genre;
                            movie.genres_object.append(genrenew!)
                            
                        }
                    }
                    
                   
                   
                }
                objects.append(movie);
            }
        }
        
        
    }
    
    
    func addMoviesFromWrapperTOP(wrapper: MovieWrapper?)
    {
        self.moviesWrapper = wrapper
        if self.moviesTOP == nil
        {
            self.moviesTOP = self.moviesWrapper?.movies
        }
        else if self.moviesWrapper != nil && self.moviesWrapper!.movies != nil
        {
            self.moviesTOP = self.moviesTOP! + self.moviesWrapper!.movies!
            
        }
        
        if(self.moviesTOP != nil){
            objects.removeAll();
            
            for movie in self.moviesTOP!{
                if(self.genres != nil){
                    
                    
                    if(movie.genres_object.isEmpty){
                        for genre_int in  movie.genres{
                            
                            let genrenew=self.genreCache.objectForKey(genre_int) as? Genre;
                            movie.genres_object.append(genrenew!)
                            
                        }
                    }
                    
                    
                    
                }
                objects.append(movie);
            }
        }
        
        
    }

    func addMoviesFromMemory(arreglo: Array<Movie>?)
    {
       /*  self.moviesWrapper = wrapper
        if self.moviesTOP == nil
        {
            self.moviesTOP = self.moviesWrapper?.movies
        }
        else if self.moviesWrapper != nil && self.moviesWrapper!.movies != nil
        {
            self.moviesTOP = self.moviesTOP! + self.moviesWrapper!.movies!
            
        }
        */

        if(arreglo != nil){
            objects.removeAll();
            
            for movie in arreglo!{
                if(self.genres != nil){
                    
                    
                    if(movie.genres_object.isEmpty){
                        for genre_int in  movie.genres{
                            
                            let genrenew=self.genreCache.objectForKey(genre_int) as? Genre;
                            movie.genres_object.append(genrenew!)
                            
                        }
                    }
                    
                    
                    
                }
                objects.append(movie);
            }
        }
        self.tableview?.reloadData()
        
        
    }
    

    
    func addGenresFromWrapper(wrapper: GenreWrapper?)
    {
        
        self.genres=[];
        self.genresWrapper = wrapper
        if self.genresWrapper == nil
        {
            self.genres = self.genresWrapper?.genres
           
        }
        else if self.genresWrapper != nil && self.genresWrapper!.genres != nil
        {
            self.genres = self.genres! + self.genresWrapper!.genres!
            
        }
        
        if(self.genres != nil){
            
            
            for genre in self.genres!{
                   self.genreCache.setObject(genre, forKey: genre.id)
            }
        }else{
            //self.loadGenres();
    
        }
        
        
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.8 {
           
            populateMovies()
            
        }
    }
    
    
    func populateMovies() {
       
        if populatingMovies {
            return
        }
        
        populatingMovies = true
        isLoadingMovies = true
        var page=""
       // let a:Int? = Int(self.currentPage)
        if(!flag_){
            page=self.currentPage.description
        }else{
            page=self.currentPageTOP.description
        }

    
            ApiController.getMoreMovies (self.listadoclase,page:page ,flag_: self.flag_,completionHandler: { wrapper, error in
                if let error = error
                {
                    // TODO: improved error handling
                  
                        self.isLoadingMovies = false
                    
                    if(self.errorLoadingMovies){
                        let alert = UIAlertController(title: "Error", message: "Could not load Movies \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    
                        //self.addMoviesFromWrapper(wrapper)
                        self.errorLoadingMovies=true
                        self.populatingMovies=false;
                        self.isLoadingMovies = false
                   
                }else{
                     self.errorLoadingMovies=false
                    if(!self.flag_){
                        self.addMoviesFromWrapper(wrapper)
                        //self.list_pages_loaded?.List_pages
                        //self.list_pages_loaded["Popular"] = wrapper?.page;
                        
                        self.listadopopular.pages?.append((wrapper?.page)!);
                        self.currentPage++
                    }else{
                        self.addMoviesFromWrapperTOP(wrapper)
                         self.listadoTOP.pages?.append((wrapper?.page)!);
                        self.currentPageTOP++
                        //self.list_pages_loaded["Top_rated"] = wrapper?.page;
                    }
                    //self.addMoviesFromWrapper(wrapper)
                    self.isLoadingMovies = false
                    
                    self.populatingMovies=false;
                    
                    
                    //self.isLoadingMovies = false
                    /*if(!self.isLoadingMovies){
                    self.spinner.stopAnimating();
                    }*/
                    self.tableview?.reloadData()
                }
                
                
                
                
            })
        }
        
  
     

    @IBAction func segmentaction(sender: AnyObject) {
       let k = segmented.selectedSegmentIndex;
        //var listado_seleccionado = List_Page()
        if(k==0){
            flag_=false
            self.currentPage=1
            //listado_seleccionado=self.listadoclase.first!;
            // self.populateMovies()
            //if(listado_seleccionado.pages!.contains(self.currentPage)){
                
            //}else{
            if(self.movies != nil){
                addMoviesFromMemory(self.movies)
            }else{
                self.populateMovies()
            }            //}
        }else{
            flag_=true
            self.currentPageTOP=1
           //  listado_seleccionado=self.listadoclase.last!;
           // if(listado_seleccionado.pages!.contains(self.currentPageTOP)){
                
           // }else{
           //     self.populateMovies()
           // }
            if(self.moviesTOP != nil){
                addMoviesFromMemory(self.moviesTOP)
            }else{
            self.populateMovies()
            }
        }
       
        
    }

    
    
}

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    
}









