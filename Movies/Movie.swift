//
//  Movie.swift
//  Movies
//
//  Created by Leonardo Talero on 1/27/16.
//  Copyright © 2016 unir. All rights reserved.
//

import UIKit

class Movie:NSObject {
    
    var id: Int=0
    var url: String=""
    
    var title_movie: String = ""
    var image_movie: String = ""
    var image_movie_backdrop: String = ""
    var image_movie_backdrop_imgg: UIImage!
    var rate_movie:Float=0.0
    var detail_movie:String=""
    var imgg: UIImage!
    var genres: [Int] = [];
    var genres_object:[Genre]=[];
    var release_date:String=""
    
}



