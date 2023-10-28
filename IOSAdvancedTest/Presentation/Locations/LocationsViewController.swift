//
//  LocationsViewController.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 27/10/23.
//

import Foundation
import UIKit
import MapKit
protocol LocationsViewControllerDelegate{
    var viewState: ((LocationsViewControllerStates) -> Void)? { get set }
    func onViewAppear()
}

enum LocationsViewControllerStates{
    case loading(_ isLoading: Bool)
    case update(characters: Characters?, locations: CharacterLocations?)
}

class LocationsViewController: UIViewController{
    @IBOutlet weak var mapView: MKMapView!
    var viewModel: LocationsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setObservers()
        viewModel?.onViewAppear()

    }
    
    private func initView(){
        mapView.delegate = self
    }
    
    private func setObservers(){
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading(_):
                    print("loading")
                case .update(characters: let characters, locations: let locations):
                    self?.updateView(characters: characters, characterLocation: locations)
                }
            }
            
        }
    }
    
    private func updateView(characters:Characters? ,characterLocation: CharacterLocations?){
        guard characterLocation != nil, characterLocation?.count ?? 0 >= 1 else {
            return
        }
        //Search the character for the location
        characterLocation?.forEach{ location in
            let character = characters?.filter({ character in
                character.id == location.character?.id
            })
            mapView.addAnnotation(CharacterAnnotation(coordinate: .init(latitude: Double(location.latitude ?? "") ?? 0.0, longitude: Double(location.longitude ?? "") ?? 0.0) , title: character?[0].name ,info: character?[0].name ))
        }
    }
}

extension LocationsViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MultipleCustomAnnotation"
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        
        annotationView.canShowCallout = true
        if annotation is MKUserLocation {
            return nil
        } else if annotation is CharacterAnnotation {
            let pinImage = UIImage(named: "pinImage")
            let size = CGSize(width: 30, height: 30)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            annotationView.image = resizedImage
            return annotationView
        } else {
            return nil
        }
    }
}
