//
//  PersonListByLanguageViewController.swift
//  ITJobsNewsAndAnalytics
//
//  Created by iphonovv on 02.12.2020.
//

import UIKit

class PersonListByLanguageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var maxButton: UIButton!
    @IBOutlet var midButton: UIButton!
    @IBOutlet var minButton: UIButton!
    
    @IBOutlet var tableView: UITableView?
    
    private var language: AnalyticLanguageType
    
    private var models: [PersonModel] = [] {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    private var loadedModel: PersonsByLanguageModel?
    
    init(language: AnalyticLanguageType) {
        self.language = language
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareTable()
        
        APIService.shared.getPersonsByLanguage(model: self.language, completion: { result in
            switch result {
            case let .success(model):
                self.loadedModel = model
                
                self.models = model.max
                self.setActiveButton(button: self.maxButton)
            case let .failure(error):
                debugPrint(error.localizedDescription)
            }
        })
    }
    
    private func prepareTable() {
        self.tableView?.register(cellClass: PersonListTableViewCell.self)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
    }
    
    private func prepareButtons() {
        [self.minButton, self.midButton, self.maxButton]
            .forEach({
                $0?.layer.masksToBounds = true
                $0?.layer.borderColor = UIColor.black.cgColor
                $0?.layer.borderWidth = 0
            })
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func maxAction(_ sender: UIButton) {
        self.setActiveButton(button: sender)
        
        self.models = self.loadedModel?.max ?? []
    }
    
    @IBAction func midAction(_ sender: UIButton) {
        self.setActiveButton(button: sender)
        
        self.models = self.loadedModel?.middle ?? []
    }
    
    @IBAction func minAction(_ sender: UIButton) {
        self.setActiveButton(button: sender)
        
        self.models = self.loadedModel?.min ?? []
        
    }
    
    private func setActiveButton(button: UIButton) {
        [self.minButton, self.midButton, self.maxButton]
            .forEach({ $0?.layer.borderWidth = 0 })
        
        button.layer.borderWidth = 1
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
