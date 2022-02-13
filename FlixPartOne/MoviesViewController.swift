//
//  MoviesViewController.swift
//  FlixPartOne
//
//  Created by Kevin on 2/2/22.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movies = [[String:Any]]()//creation of an array of dictionaries
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //both of these needs to be declared here in order to call the tableView functions
        tableView.delegate = self
        tableView.dataSource = self
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                    self.movies = dataDictionary["results"] as! [[String : Any]] // the 'as! [[String : Any]] is casting the result to a array of dictionary, since that is what our 'movies' var is.
                 
                    self.tableView.reloadData() //we have to tell the tableView to load the data after otherwise won't show 
                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data

             }
        }
        task.resume()
    }
    
    //return the number of rows
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return movies.count //get the size of our movies array that stores dictionary
    }
    
    //for this particular row, give me the cell
    // if the number of rows is 50, then this function will get called 50x's
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell //cast it as MovieCell
        
        
        
        let movie = movies[indexPath.row] //gets the dictionary at this index
        let title = movie["title"] as! String //get movie title, the as! String is cast to a String, we know it's a string too
        let synopsis = movie["overview"] as! String

        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        print(movie)
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // Find the selected movie
        // the 'sender' is actually the cell
        // that was tapped on so
        let cell = sender as! UITableViewCell
        //find the index path for this particular cell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        //Pass the selected movie to the MovieDetailsViewController
        // segue - "knows" where it's going apparently?
        let detailsViewController = segue.destination as! MovieDetailsViewController
        //have the MovieDetailsViewController variable movie
        //equal to the movie variable here
        detailsViewController.movie = movie
        
        //final clean up touch, this will deselect the selected cell
        //when user navigates back to this screen
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
