//
//  AchievementTableViewCell.swift
//  ForestClone
//
//  Created by Christian Leovido on 18/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import UIKit

class AchievementTableViewCell: UITableViewCell {

    @IBOutlet weak var achievementImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var achievement: Achievement!

    override func awakeFromNib() {
        super.awakeFromNib()
        layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8)
    }

    func configureCell(with achievement: Achievement) {

        self.achievement = achievement

        achievementImage.image = UIImage(named: achievement.image) ?? UIImage(systemName: "person.fill")
        titleLabel.text = achievement.name
        descriptionLabel.text = achievement.description

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
