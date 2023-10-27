//
//  CharacterDetailViewController.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 26/10/23.
//

import Foundation
import UIKit
import MapKit

protocol CharacterDetailDelegate {
    var viewState: ((CharacterDetailViewState) -> Void)? {get set}
    func onViewAppear()
    func logOutPressed()
    func goBackPressed()
    var loginViewModel: LoginViewControllerDelegate {get}
}
enum CharacterDetailViewState {
    case loading(_ isLoading: Bool)
    case update(character: Character?, locations: CharacterLocations?)
    case navigateToLogin
    case goBack
}

class CharacterDetailViewController: UIViewController {
    
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailMapView: MKMapView!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterDescription: UITextView!
    
    var viewModel: CharacterDetailDelegate?
    
    override func viewDidLoad() {
        initViews()
        setObservers()
        viewModel?.onViewAppear()
        
    }
    
    private func initViews(){
        detailMapView.delegate = self
        logOutButton.setImage(UIImage(systemName: "power"), for: .normal)
        logOutButton.tintColor = UIColor.red
        
        goBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        
        goBackButton.tintColor = UIColor.orange
        
    }
    
    private func setObservers(){
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                    break
                case .update(let character, let characterLocation):
                    self?.updateView(character: character, characterLocation: characterLocation)
                case .navigateToLogin:
                    self?.performSegue(withIdentifier: SegueIdentifiersValues.DETAILtoLOGIN, sender: nil)
                case .goBack:
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            
        }
    }
    
    private func updateView(character: Character?, characterLocation: CharacterLocations?){
        characterImage.kf.setImage(with: character?.photo)
        makeImageRounded(image: characterImage)
        titleLabel.text = character?.name
        characterDescription.text = character?.description
        
        guard characterLocation != nil, characterLocation?.count ?? 0 >= 1 else {
            return
        }
        
        characterLocation?.forEach{
            detailMapView.addAnnotation(CharacterAnnotation(coordinate: .init(latitude: Double($0.latitude ?? "") ?? 0.0, longitude: Double($0.longitude ?? "") ?? 0.0) , title: character?.name, info: character?.id ))
        }
        
        detailMapView.setCenter(CLLocationCoordinate2D(
            latitude: Double(characterLocation?[0].latitude ?? "") ?? 0.0,
            longitude: Double(characterLocation?[0].longitude ?? "") ?? 0.0),
                                animated: true)
    }
    
    private func makeImageRounded(image: UIImageView){
        image.layer.borderWidth = 1
        image.layer
            .borderColor = UIColor.white.cgColor.copy(alpha: 0.6)
        image.layer.cornerRadius = image.frame.height / 2
        image.layer.masksToBounds = false
        image.clipsToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == SegueIdentifiersValues.DETAILtoLOGIN,
              let loginViewController = segue.destination as? LoginViewController else {
            return
        }
        loginViewController.viewModel = viewModel?.loginViewModel
    }
    
    @IBAction func onLogOutPressed(_ sender: Any) {
        viewModel?.logOutPressed()
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        viewModel?.goBackPressed()
    }
}

extension CharacterDetailViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "CharacterCustomAnnotation"
        
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
