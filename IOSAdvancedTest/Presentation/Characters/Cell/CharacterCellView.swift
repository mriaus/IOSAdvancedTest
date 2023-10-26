//
//  CharacterCellView.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 26/10/23.
//

import UIKit
import Kingfisher

class CharacterCellView: UITableViewCell{
 
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterDescription: UILabel!
    
    static let identifier: String = "CharacterCellView"
    static let estimatedHeight: CGFloat = 256
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        characterImage.layer.cornerRadius = characterImage.frame.size.width / 2
        characterImage.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterName.text = nil
        characterImage.image = nil
        characterDescription.text = nil
    }
    
    func updateView(name: String? = nil, photo: String? = nil, description: String? = nil) {
        
        self.characterName.text = name
        self.characterDescription.text = description
        self.characterImage.kf.setImage(with: URL(string: photo ?? ""))
    }
}
