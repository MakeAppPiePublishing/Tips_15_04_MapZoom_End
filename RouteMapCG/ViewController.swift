//
//  ViewController.swift
//  RouteMapCG
//
//  Created by Steven Lipton on 5/10/21.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let baseCoord = CLLocationCoordinate2D(latitude: 34.398296, longitude: -119.517993)//34.398296, -119.517993
    let baseSpan = 1500 //meters
    let coordinates:[(Double,Double)] = [(34.393425, -119.525095),(34.396997, -119.520745),(34.398263, -119.519180),(34.397938, -119.518784),(34.398571, -119.517984),(34.396913, -119.516010)]
    
    
    @IBAction func showWalkingPath(_ sender: UIButton) {
        addWalkingPath()
        if let  firstOverlay = mapView.overlays.first{
            let annotation = MKPointAnnotation()
            annotation.coordinate = firstOverlay.coordinate
            mapView.addAnnotation(annotation)
            let mapRect = firstOverlay.boundingMapRect
            mapView.setVisibleMapRect(mapRect, animated: true)
            let maxPoint = MKMapPoint(x:mapRect.maxX,y:mapRect.maxY)
            let distance = maxPoint.distance(to:mapRect.origin)
            mapView.setRegion(MKCoordinateRegion(center: firstOverlay.coordinate, latitudinalMeters: distance, longitudinalMeters: distance),animated: true)
        }
        
    }
    
    func addWalkingPath(){
        var pathPoints:[CLLocationCoordinate2D] = []
        mapView.removeOverlays(mapView.overlays)
        for coord in coordinates{
            pathPoints += [CLLocationCoordinate2D(latitude: coord.0, longitude: coord.1)]
        }
        let polyline = MKPolyline(coordinates: pathPoints, count: pathPoints.count)
        polyline.title = "walkingPath"
        mapView.addOverlays([polyline])
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay:MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline{
            let lineRenderer = MKPolylineRenderer(polyline: polyline)
            lineRenderer.lineWidth = 5
            lineRenderer.strokeColor = .blue
            lineRenderer.alpha = 1.0
            return lineRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view.
        mapView.region = MKCoordinateRegion(center: baseCoord, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.mapType = .satellite
        let centerAnnotation = MKPointAnnotation()
        centerAnnotation.coordinate = baseCoord
        mapView.addAnnotation(centerAnnotation)
       
        
    }


}

