//
//  AchievementsTableViewController.swift
//  ForestClone
//
//  Created by Christian Leovido on 18/06/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import UIKit

class AchievementsTableViewController: UITableViewController {

    var data: [Achievement] {
        load("achievements.json")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 70
        tableView.backgroundColor = ColorScheme.mainGreen

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .done,
            target: nil,
            action: nil
        )
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "AchievementCell",
            for: indexPath
            ) as? AchievementTableViewCell else {
                return UITableViewCell()
        }

        cell.configureCell(with: data[indexPath.row])

        return cell
    }

    private func load<T:Decodable>(_ filename:String, as type:T.Type = T.self) -> T {

        let data:Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main Bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't find \(filename) from main Bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }

}
