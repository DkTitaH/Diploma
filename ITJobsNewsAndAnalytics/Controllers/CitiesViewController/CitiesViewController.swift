//
//  CitiesViewController.swift
//  ITJobsNewsAndAnalytics
//
//  Created by iphonovv on 28.11.2020.
//

import UIKit

struct CityModel {
    var name: String
}

class CitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var textField: UITextField?
    @IBOutlet var tableView: UITableView?
    
    private var models: [CityModel] = [] {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    private var loadedModels : [CityModel]  = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = .init(title: "Дані у містах", image: UIImage(named: "town"), tag: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.register(cellClass: CitiesTableViewCell.self)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.textField?.delegate = self
        
        APIService.shared.getCitites { result in
            switch result {
            case let .success(model):
                let models = model.map { CityModel(name: $0) }
                self.models = models
                self.loadedModels = models
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.reusableCell(
            CitiesTableViewCell.self,
            for: indexPath,
            configure: { cell in
                let model = self.models[indexPath.row]
                cell.fill(model: model)
            }
        )
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.models[indexPath.row]
        
        APIService.shared.getTopOfCity(model: model) { result in
            switch result {
            case let .success(model):
                let controller = PersonListViewController(models: model.workers)
                controller.modalPresentationStyle = .overFullScreen
                self.present(controller, animated: true)
                
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CitiesViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text,
            let textRange = Range(range, in: text) else {
                return true
        }
        let searchText = text.replacingCharacters(in: textRange, with: string)
        
        if searchText == "" {
            self.models = self.loadedModels
        } else {
            self.models = self.loadedModels.filter({
                $0.name.lowercased().contains(searchText.lowercased())
            })
        }
        
        return true
    }
}
