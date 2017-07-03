//
//  MapViewController.swift
//  WhackFrog
//
//  Created by MacOS on 6/30/17.
//  Copyright © 2017 Tamirg. All rights reserved.
//

import UIKit
import MapKit
var data : [Score] = []
class MapViewController: UIViewController,CLLocationManagerDelegate {

    var lang :Double = 0.0
    var latitude :Double = 0.0
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var Mapref: MKMapView!
    @IBAction func btnBackPress(_ sender: Any) {
        performSegue(withIdentifier: "navigate_Map_to_scoreTable"
, sender: self)
    }
    
     let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.Mapref.showsUserLocation = true
        self.Mapref.showsCompass = true
        self.Mapref.isScrollEnabled = true

        getData();
        addmarkers();
        
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
        //Zoom to user location
        let noLocation = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        let viewRegion = MKCoordinateRegionMakeWithDistance(noLocation,10,5)
        Mapref.setRegion(viewRegion, animated: false)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addmarkers()->Void{
    
        for player in data{
        
            lang = player.lng
            latitude = player.lat
            print(" Map: lat" + "\(latitude)"+"lang"+"\(lang)")

            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: lang)
           // annotation = player.name
            Mapref.addAnnotation(annotation)
        }
        
        Mapref.reloadInputViews()
    
    }

    
    func getData()
    {
        do{
            data = try context.fetch(Score.fetchRequest())
        }
        catch{
            print("Fetch Failed")
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}

//class Artwork: NSObject, MKAnnotation {
//    let titl: String
//    let coordinate: CLLocationCoordinate2D
//    
//    init(title: String, coordinate: CLLocationCoordinate2D) {
//        self.title = title
//        self.locationName = locationName
//        self.discipline = discipline
//        self.coordinate = coordinate
//        
//        super.init()
//    }
//    
//}
