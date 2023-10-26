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
    func characterBy(index: Int) -> Character?
}

enum CharacterViewState {
    case updateData
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
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .updateData:
                    self?.tableView.reloadData()
                }
            }
        }
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

}
