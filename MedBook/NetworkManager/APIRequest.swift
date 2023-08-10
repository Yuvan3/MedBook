//
//  APIRequest.swift
//  MedBook
//
//  Created by Yuvan Shankar on 09/08/23.
//

import Foundation

struct APIRequest {
    
    var resourceURL: URL
    let urlString = "https://api.first.org/data/v1/countries"
   
    init() {
        resourceURL = URL(string: urlString)!
    }
    
    //create method to get decode the json
    func requestAPIInfo(completion: @escaping(Result<CountryInfo, Error>) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { (data, response, error) in
            
            guard error == nil else {
                print (error?.localizedDescription ?? "")
                print("Stuck in data task")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let jsonData = try decoder.decode(CountryInfo.self, from: data!)
                completion(.success(jsonData))
            }
            catch {
                print ("an error in catch")
                print (error)
            }
        }
        dataTask.resume()
    }
}
