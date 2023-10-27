//
//  CharactersViewController.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 23/10/23.
//

import Foundation
import UIKit

protocol CharactersViewControllerDelegate {
    var viewState: ((CharacterViewState) -> Void)? {get set}
    var charactersCount: Int {get}
    func onViewAppear()
    func onLogOutButtonPressed()
    func characterBy(index: Int) -> Character?
    var loginViewModel: LoginViewControllerDelegate { get }
    func characterDetailViewModel(index: Int) ->  CharacterDetailDelegate?
    
}

enum CharacterViewState {
    case updateData
    case navigateToLogin
}

class CharactersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logOutButton: UIButton!
    var viewModel: CharactersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObservers()
        viewModel?.onViewAppear()
    }
    
    private func initViews() {
        tableView.delegate = self
        tableView.dataSource = self
        logOutButton.setImage(UIImage(systemName: "power"), for: .normal)
        logOutButton.tintColor = UIColor.red
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier) {
        case SegueIdentifiersValues.CHARACTERStoLOGIN:
            guard segue.identifier == SegueIdentifiersValues.CHARACTERStoLOGIN,
                  let loginViewController = segue.destination as? LoginViewController else {
                return
            }
            loginViewController.viewModel = viewModel?.loginViewModel
        case SegueIdentifiersValues.CHARACTERStoDETAIL:
            guard segue.identifier == SegueIdentifiersValues.CHARACTERStoDETAIL,
                    let index = sender as? Int,
                  let characterDetailViewController = segue.destination as? CharacterDetailViewController,
                  let detailViewModel = viewModel?.characterDetailViewModel(index: index)  else {
                return
            }
            characterDetailViewController.viewModel = detailViewModel
        case .none:
            return
        case .some(_):
            return
        }
    }
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .updateData:
                    self?.tableView.reloadData()
                case .navigateToLogin:
                    self?.performSegue(withIdentifier: SegueIdentifiersValues.CHARACTERStoLOGIN, sender: nil)
                }
            }
        }
    }
    
    @IBAction func onPressLogOut(_ sender: Any) {
        viewModel?.onLogOutButtonPressed()
    }
}




// MARK: Extension with delegates and datasource
extension CharactersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.charactersCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        CharacterCellView.estimatedHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCellView.identifier, for: indexPath) as? CharacterCellView else {
            return UITableViewCell()
        }
        
        if let character = viewModel?.characterBy(index: indexPath.row) {
            cell.updateView(name: character.name, photo: character.photo?.absoluteString, description: character.description)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: SegueIdentifiersValues.CHARACTERStoDETAIL, sender: indexPath.row)
 
    }
    
}
