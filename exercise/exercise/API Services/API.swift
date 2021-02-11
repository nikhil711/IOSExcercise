//
//  API.swift
//  exercise
//
//  Created by Nikhil Doppalapudi on 2/10/21.
//

import Foundation

class API {
    
    let date = Date()
    let calendar = Calendar.current
    
    
    func fetchData(completion: @escaping(Result<LocationsModel, Error>) -> Void) {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        let previousDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -30, to: Date())!)
        
        
        let baseURL = URL(string: "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=\(previousDate)&endtime=\(currentDate)")!
        
        
        let req = URLRequest(url: baseURL)
        
        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error {
                print(error)
                completion(.failure(LocationFetchError.failed))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode),
                  let data = data,
                  let locationData = try? JSONDecoder().decode(LocationsModel.self, from: data) else {
                print("Couldn't decode data")
                completion(.failure(LocationFetchError.failed))
                return
            }
            completion(.success(locationData))
        }
        
        task.resume()
    }
}

enum LocationFetchError: Error {
    case failed
}
