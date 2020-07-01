//
//  MenuTableViewController.swift
//  ForestClone
//
//  Created by Christian Leovido on 18/06/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    weak var homeDelegate: MenuSliderDelegate?

    let menuOptions: [MenuItem] = [MenuItem(name: "Forest", image: "person"),
                                   MenuItem(name: "Timeline", image: "clock"),
                                   MenuItem(name: "Tags", image: "tag"),
                                   MenuItem(name: "Friend", image: "person"),
                                   MenuItem(name: "Achievements", image: "checkmark.seal"),
                                   MenuItem(name: "Store", image: "bag"),
                                   MenuItem(name: "Real Forest", image: "left.arrow.circlepath"),
                                   MenuItem(name: "News", image: "doc.text"),
                                   MenuItem(name: "Settings", image: "gear")]

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        homeDelegate?.configureView(isSliderPresented: true)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MenuCellTableViewCell.identifier,
            for: indexPath
            ) as? MenuCellTableViewCell else {
                return UITableViewCell()
        }

        cell.menuItemLabel.text = menuOptions[indexPath.row].name
        cell.menuItemImage.image = UIImage(systemName: menuOptions[indexPath.row].image)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let segueName = menuOptions[indexPath.row].name.lowercased() + "Segue"

        homeDelegate?.performSegue(with: segueName)
    }

}
