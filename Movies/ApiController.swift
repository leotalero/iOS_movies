//

//  ApiController.swift

//  Movies

//

//  Created by Leonardo Talero on 1/28/16.

//  Copyright © 2016 unir. All rights reserved.

//



import Foundation

import UIKit

import Alamofire

import SwiftyJSON





let apikey:String = "3defbee8a7ff35deff02366f0f76a940";



class ApiController {
    
    
    
    
    
    private class func endpointForSearchStringGenres() -> String {
        
        
        
        
        
        //let lang = NSLocale.currentLocale().localeIdentifier
        
        let langId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        
        let countryId = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as! String
        
        let language = "\(langId)-\(countryId)" // en-US on my machine
        
        
        
        //let page=Int.init(path)!+1;
        
        // let encoded = "\(page)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        return "http://api.themoviedb.org/3/genre/movie/list?api_key=\(apikey)&language=\(language)"
        
    }
    
    
    
    
    
    
    
    private class  func endpointForSearchStringMovies(page:String) -> String {
        
        
        
        //let page=Int.init(path)!+1;
        
        let langId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        
        let countryId = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as! String
        
        let language = "\(langId)-\(countryId)" // en-US on my machine
        
        let encoded = "\(page)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        return "http://api.themoviedb.org/3/movie/popular?api_key=\(apikey)&language=\(language)&format=json&page=\(encoded!)"
        
    }
    
    
    
    
    private class  func endpointForSearchStringMoviesTop(page:String) -> String {
        
        
        
        //let page=Int.init(path)!+1;
        
        let langId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        
        let countryId = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as! String
        
        let language = "\(langId)-\(countryId)" // en-US on my machine
        
        let encoded = "\(page)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        return "http://api.themoviedb.org/3/movie/top_rated?api_key=\(apikey)&language=\(language)&format=json&page=\(encoded!)"
        
    }
    

    
    
    private class func endpointForImageString(path_image:String) -> String {
        
        // URL encode it, e.g., "Yoda's Species" -> "Yoda%27s%20Species"
        
        // and add star wars to the search string so that we don't get random pictures of the Hutt valley or Droid phones
        
        // let lang = NSLocale.currentLocale().localeIdentifier
        
        let langId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        
        let countryId = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as! String
        
        let language = "\(langId)-\(countryId)" // en-US on my machine
        
        let encoded = "\(path_image)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        // create the search string
        
        // append &t=grokswift so DuckDuckGo knows who's using their services
        
        return "http://image.tmdb.org/t/p/w500\(encoded!)?api_key=\(apikey)&language=\(language)&format=json"
        
    }
    
    
    
    
    
    class  func getMovies(page: String,completionHandler: (MovieWrapper?, NSError?) -> Void) {
        
        let searchURLString = endpointForSearchStringMovies(page)
        
        Alamofire.request(.GET, searchURLString)
            
            .responseAPIURL { response in
                
                if let error = response.result.error
                    
                {
                    
                    completionHandler(nil, error)
                    
                    return
                    
                }
                
                
                
                completionHandler(response.result.value, nil);
                
                
                
                let imageURLResult = response.result.value
                
                guard let imageURL = imageURLResult?.movies where imageURL.isEmpty == false else {
                    
                    completionHandler(response.result.value, nil)
                    
                    return
                    
                }
                
                
                
                
                
        }
        
    }
    
    
    
    
    
    class  func getGenres(completionHandler: (GenreWrapper?, NSError?) -> Void) {
        
        let searchURLString = endpointForSearchStringGenres()
        
        Alamofire.request(.GET, searchURLString)
            
            .responseAPIURLGenres{ response in
                
                if let error = response.result.error
                    
                {
                    
                    completionHandler(nil, error)
                    
                    return
                    
                }
                
                
                
                completionHandler(response.result.value, nil);
                
                
                
                /* let genreURLResult = response.result.value
                
                guard let igenreURL = genreURLResult?.genres where imageURL.isEmpty == false else {
                
                completionHandler(response.result.value, nil)
                
                return
                
                }*/
                
                
                
                
                
        }
        
    }
    
    
    
    class  func getMoreMovies(listado:Array<List_Page>,page: String,flag_:Bool,completionHandler: (MovieWrapper?, NSError?) -> Void) {
        var searchURLString = ""
        var listado_pages=List_Page();
        if(!flag_){
          searchURLString = endpointForSearchStringMovies(page)
            listado_pages=listado.first!
        }else{
            searchURLString = endpointForSearchStringMoviesTop(page)
              listado_pages=listado.last!
        }
        
       // let a:Int? = Int(page)
       // if(listado_pages.pages!.contains(a!)){
            
       // }else{
            Alamofire.request(.GET, searchURLString)
                
                .responseAPIURL { response in
                    
                    if let error = response.result.error
                        
                    {
                        
                        completionHandler(nil, error)
                        
                        return
                        
                    }
                    
                    
                    
                    
                    
                    completionHandler(response.result.value, nil);
                    
                    
                    
                    /* let movieURLResult = response.result.value
                    
                    guard let movieURL = movieURLResult?.movies where movieURL.isEmpty == false else {
                    
                    completionHandler(response.result.value, nil)
                    
                    return
                    
                    
                    
                    
                    
                    
                    
                    } */
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
            
            

        }
    }
    
    
    
    
    
    
    
    
    
    
    
}







var photos = NSMutableOrderedSet()

let movies_array = [Movie]();

extension Alamofire.Request {
    
    func responseAPIURL(completionHandler: Response<MovieWrapper, NSError> -> Void) -> Self {
        
        let responseSerializer = ResponseSerializer<MovieWrapper, NSError> { request, response, data, error in
            
            guard let responseData = data else {
                
                let failureReason = "Image URL could not be serialized because input data was nil."
                
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                
                return .Failure(error)
                
            }
            
            
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            
            let result = JSONResponseSerializer.serializeResponse(request, response, responseData, error)
            
            
            
            switch result {
                
            case .Success(let value):
                
                
                
                let photoInfos = (value.valueForKey("results") as! [NSDictionary]).map{
                    
                    PhotoInfo(id: $0["id"] as! Int, url: ApiController.endpointForImageString($0["poster_path"] as! String))};
                
                
                
                photos.addObjectsFromArray(photoInfos);
                
                
                
                let json = SwiftyJSON.JSON(value)
                
                let wrapper = MovieWrapper();
                
                guard json.error == nil else {
                    
                    print(json.error!)
                    
                    return .Failure(json.error!)
                    
                }
                
                var moviesArray :[Movie] = []
                
                wrapper.page = json["page"].intValue;
                
                wrapper.total_pages = json["total_pages"].intValue;
                
                wrapper.total_results = json["total_results"].intValue;
                
                wrapper.photos.addObjectsFromArray(photoInfos)
                
                
                
                
                
                for movie in json["results"].arrayValue {
                    
                    let object_movie=Movie();
                    
                    let poster_path = ApiController.endpointForImageString(movie["poster_path"].stringValue);
                    
                    object_movie.image_movie=poster_path;
                    
                    
                    
                    
                    
                    
                    
                    let backdrop_path = ApiController.endpointForImageString(movie["backdrop_path"].stringValue);
                    
                    object_movie.image_movie_backdrop=backdrop_path
                    
                    
                    
                    object_movie.detail_movie = movie["overview"].stringValue
                    
                    
                    
                    object_movie.id = movie["id"].intValue
                    
                    object_movie.title_movie = movie["title"].stringValue
                    
                    
                    
                    object_movie.rate_movie = movie["popularity"].floatValue
                    
                    object_movie.vote_average = movie["vote_average"].floatValue
                    object_movie.release_date = movie["release_date"].stringValue
                    
                    
                    
                   
                    
                    if(object_movie.imgg==nil){
                        
                        Alamofire.request(.GET, object_movie.image_movie).response() {
                            
                            (_, _, data, error) in
                            
                            
                            
                            let image = UIImage(data: data!)
                            
                            object_movie.imgg=image
                            
                            
                            
                        }
                        
                    }
                    
                    if(object_movie.image_movie_backdrop_imgg == nil){
                        
                        Alamofire.request(.GET, object_movie.image_movie_backdrop).response() {
                            
                            (_, _, data, error) in
                            
                            
                            
                            let image = UIImage(data: data!)
                            
                            object_movie.image_movie_backdrop_imgg=image
                            
                            
                            
                        }
                        
                    }
                    
                    for id in movie["genre_ids"].array! {
                        
                        object_movie.genres.append(id.intValue)
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    moviesArray.append(object_movie);
                    
                    
                    
                }
                
                wrapper.movies = moviesArray;
                
                
                
                
                
                return .Success(wrapper)
                
            case .Failure(let error):
                
                return .Failure(error)
                
            }
            
        }
        
        
        
        return response(responseSerializer: responseSerializer,
            
            completionHandler: completionHandler)
        
    }
    
    
    
    
    
    func responseAPIURLGenres(completionHandler: Response<GenreWrapper, NSError> -> Void) -> Self {
        
        let responseSerializer = ResponseSerializer<GenreWrapper, NSError> { request, response, data, error in
            
            guard let responseData = data else {
                
                let failureReason = "Image URL could not be serialized because input data was nil."
                
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                
                return .Failure(error)
                
            }
            
            
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            
            let result = JSONResponseSerializer.serializeResponse(request, response, responseData, error)
            
            
            
            switch result {
                
            case .Success(let value):
                
                
                
                
                
                let json = SwiftyJSON.JSON(value)
                
                let wrapper = GenreWrapper();
                
                guard json.error == nil else {
                    
                    print(json.error!)
                    
                    return .Failure(json.error!)
                    
                }
                
                var genresArray :[Genre] = []
                
                
                
                
                
                
                
                for genre in json["genres"].arrayValue {
                    
                    let object_genre=Genre();
                    
                    
                    
                    object_genre.id=genre["id"].intValue;
                    
                    object_genre.name = genre["name"].stringValue
                    
                    
                    
                    
                    
                    genresArray.append(object_genre);
                    
                    
                    
                }
                
                wrapper.genres = genresArray;
                
                
                
                
                
                
                
                
                
                return .Success(wrapper)
                
            case .Failure(let error):
                
                return .Failure(error)
                
            }
            
        }
        
        
        
        return response(responseSerializer: responseSerializer,
            
            completionHandler: completionHandler)
        
    }
    
    
    
    
    
}

