//
//  ViewController.swift
//  sberTest
//
//  Created by Ибрагим on 18/04/2019.
//  Copyright © 2019 Ибрагим Мамадаев. All rights reserved.
//

import UIKit
import Foundation
import YandexMapKit
import YandexMapKitSearch

class ViewController: UIViewController, YMKMapCameraListener
{
    @IBOutlet weak var map: YMKMapView!
    
    let group = DispatchGroup()
    var posts = [Post]()
    var searchManager: YMKSearchManager?
    var searchSession: YMKSearchSession?

    
    
    func parsePosts(from json: Any) {
        guard let postsArray = json as? NSArray else {
            print("Parse error")
            return
        }
        for i in postsArray {
            guard let postDict = i as? NSDictionary,
                let post = Post(dict: postDict) else { continue }
            posts.append(post)
        }
    }
    
    
    
    func getPosts() {
        let urlString = "http://localhost:3000/atmList.json"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                self.parsePosts(from: json)
            } catch {
                print(error.localizedDescription)
            }
            self.group.leave()
            }.resume()
    }
    
    
    
    override func viewDidLoad() {
        group.enter()
        getPosts()
        group.wait()

        super.viewDidLoad()

        searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
        map.mapWindow.map.addCameraListener(with: self)

        map.mapWindow.map.move(with: YMKCameraPosition(
            target: YMKPoint(latitude: 55.782978, longitude: 37.640660),
            zoom: 10,
            azimuth: 0,
            tilt: 0))
        let mapObjects = map.mapWindow.map.mapObjects
        mapObjects.clear()

        for i in 0 ..< posts.count {
            print("Terminal num.", i + 1)
            print("     id:   \(posts[i].id)")
            print("     let : \(posts[i].lat)")
            print("     long: \(posts[i].long)")
            let TARGET_LOCATION = YMKPoint(latitude: (posts[i].lat as NSString).doubleValue, longitude: (posts[i].long as NSString).doubleValue)
            let placemark = mapObjects.addPlacemark(with: TARGET_LOCATION)
            placemark.setIconWith(UIImage(named: "SearchResult")!)
        }
    }
    
    
    
    func onCameraPositionChanged(with map: YMKMap,
                                 cameraPosition: YMKCameraPosition,
                                 cameraUpdateSource: YMKCameraUpdateSource,
                                 finished: Bool) {
    }
    
}
