//
//  SearchViewController.swift
//  ITJobsNewsAndAnalytics
//
//  Created by iphonovv on 29.11.2020.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var textFieldContainer: UIView?
    @IBOutlet var textField: UITextField?
    @IBOutlet var tableView: UITableView!
    
    private var indicator: UIActivityIndicatorView?
    private var searchTimer: Timer? {
        didSet {
            oldValue?.invalidate()
        }
    }
    private var currentSearchTask: URLSessionDataTask? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    private var models: [LanguageSalaryInPercentModel] = [] {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = .init(title: "Пошку по рівню ЗП", image: UIImage(named: "town"), tag: 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField?.delegate = self
        self.tableView?.register(cellClass: SearchTableViewCell.self)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addLoaderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLoaderView() {
        let activityIndicator = UIActivityIndicatorView(frame: .init(x: 0, y: 0, width: 200, height: 200))
        
        let iosVersion = NSString(string: UIDevice.current.systemVersion).doubleValue
        
        if iosVersion >= 13 {
            activityIndicator.color = UIColor(named: "BlackAndWhite")
        } else {
            activityIndicator.style = UIActivityIndicatorView.Style.medium
        }
        self.indicator = activityIndicator
        
        let screenSize = UIScreen.main.bounds
        activityIndicator.center = .init(x: screenSize.width / 2, y: screenSize.height / 2)
        self.view?.addSubview(activityIndicator)
    }
    
    private func loadData(value: Int) {
        self.searchTimer?.invalidate()
        self.searchTimer = nil
        self.indicator?.startAnimating()

        self.searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] (timer) in
            self?.currentSearchTask = APIService.shared.searchBySalary(salary: value, completion: { result in
                self?.indicator?.stopAnimating()
                
                switch result {
                case let .success(models):
                    self?.models = models
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                }
            })
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.reusableCell(
            SearchTableViewCell.self,
            for: indexPath,
            configure: { cell in
                let model = self.models[indexPath.row]
                let cellModel = SearchTableViewCellModel(name: model.name, salary: model.percent)
                cell.fill(model: cellModel)
            }
        )
    }
}

extension SearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters =
            CharacterSet(charactersIn: "0123456789").inverted
        if (string.rangeOfCharacter(from: invalidCharacters) == nil) {
            if let text = textField.text {
                let str = (text as NSString)
                    .replacingCharacters(in: range, with: string)
                if let intText = Int(str) {
                    textField.text = "\(intText)"
                    self.loadData(value: intText)
                } else {
                    textField.text = ""
                    self.models = []
                }
                return false
            }
            return true
        }
        return false
    }
}
