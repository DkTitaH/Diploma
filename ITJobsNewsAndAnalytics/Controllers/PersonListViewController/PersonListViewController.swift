//
//  PersonListViewController.swift
//  ITJobsNewsAndAnalytics
//
//  Created by iphonovv on 01.12.2020.
//

import UIKit

class PersonListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    private var models: [PersonModel] = [] {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    init(models: [PersonModel]) {
        self.models = models
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.register(cellClass: PersonListTableViewCell.self)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.reusableCell(
            PersonListTableViewCell.self,
            for: indexPath,
            configure: { cell in
                let model = self.models[indexPath.row]
                let cellModel = PersonListTableViewCellModel(language: model.language, salary: model.salary, position: model.position)
                cell.fill(model: cellModel)
            }
        )
    }
}
