//
//  ViewController.swift
//  exercise
//
//  Created by Nikhil Doppalapudi on 2/10/21.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    let api = API()
    var locationsData: LocationsModel! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchData()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(LocationCell.self, forCellReuseIdentifier: "LocationCell")
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let locations = locationsData else {
            return 0
        }
        return locations.features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as? LocationCell, let locations = locationsData else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = locations.features[indexPath.row].properties.place
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let locations = locationsData else {
            return
        }
        let feature = locations.features[indexPath.row]
        let urlString = feature.properties.url
        guard let url = URL(string: urlString) else{
                return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
}


extension ViewController {
    func fetchData() {
        api.fetchData { [weak self] result in
            switch result {
            case let .success(data):
                self?.locationsData = data
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}
