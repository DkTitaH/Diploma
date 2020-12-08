//
//  AnalitycViewController.swift
//  ITJobsNewsAndAnalytics
//
//  Created by iphonovv on 28.11.2020.
//

import UIKit

enum GraphicState {
    case start
    case middle
    case cancel
}

class AnalyticViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var containerForGraphic: UIView?
    @IBOutlet var graphicContent: UIView?
    @IBOutlet var tableView: UITableView?
    
    @IBOutlet var minDot: UIImageView!
    @IBOutlet var midDot: UIImageView!
    @IBOutlet var maxDot: UIImageView!
    
    @IBOutlet var minValue: UILabel!
    @IBOutlet var midValue: UILabel!
    @IBOutlet var maxValue: UILabel!
    
    private var graphicState: GraphicState = .start
    private var currentSalaryModel: SalaryByLanguage?
    
    private var lastSelectedIndex: IndexPath?
    
    private var models: [AnalyticLanguageType] = [] {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = .init(title: "Аналітика ЗП", image: UIImage(named: "analytic"), tag: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIService.shared.getPerson(id: 7349, completion: { res in
            switch res {
            case let .success(model):
                print(model)
            case let .failure(error):
                print(error.localizedDescription)
            }
        })
        
        self.prepareGraphicContainer()
        self.prepareTable()
        
        APIService.shared.getLanguages { result in
            switch result {
            case let .success(model):
                self.models = model.map { AnalyticLanguageType(name: $0) }
            case let .failure(error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func showPersonListController(language: AnalyticLanguageType) {
        let controller = PersonListByLanguageViewController(language: language)
        controller.modalPresentationStyle = .overFullScreen
        
        self.present(controller, animated: true)
    }
    
    private func prepareTable() {
        let table = self.tableView
        table?.register(cellClass: AnalyticLanguageTypeTableViewCell.self)
        table?.delegate = self
        table?.dataSource = self
    }
    
    private func prepareGraphicContainer() {
        let layer = self.containerForGraphic?.layer
        layer?.cornerRadius = 16
        layer?.backgroundColor = .init(red: 255, green: 255, blue: 255, alpha: 0.5)
        layer?.borderWidth = 1
        layer?.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 0.2)
        layer?.shadowOpacity = 1
        layer?.shadowOffset = .init(width: 0, height: 5)
        layer?.shadowColor = .init(red: 0, green: 0, blue: 0, alpha: 0.2)
    }
    
    var layer: CAShapeLayer?
    
    private func drawGraphic() {
        self.layer?.isHidden = true
        self.layer?.removeFromSuperlayer()
        self.layer = nil
        
        let centerMin = self.minDot.center
        let centerMiddle = self.midDot.center
        let centerMax = self.maxDot.center

        
        let path = UIBezierPath()
        path.move(to: centerMin)
        path.addLine(to: centerMiddle)
        path.addLine(to: centerMax)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillMode = .forwards
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 1

        self.layer = shapeLayer
        
        self.graphicContent?.layer.addSublayer(shapeLayer)
        self.addGraphicAnimation(value: 0.5, from: 0)
    }
    
    private func addGraphicAnimation(value: CGFloat, from: CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.5
        animation.fromValue = from
        animation.toValue = value
        self.layer?.strokeEnd = value
        
        animation.delegate = self
        
        self.layer?.add(animation, forKey: "animateprogress")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.reusableCell(
            AnalyticLanguageTypeTableViewCell.self,
            for: indexPath,
            configure: { cell in
                let model = self.models[indexPath.row]
                cell.fill(model: model)
            }
        )
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.models[indexPath.row]
        self.lastSelectedIndex = indexPath
        
        self.layer?.removeFromSuperlayer()
        [
            self.minValue,
            self.midValue,
            self.maxValue
        ].forEach {
            $0?.text = nil
        }
        
        APIService.shared.getSalary(model: model) { result in
            switch result {
            case let .success(model):
                self.currentSalaryModel = model
                self.minValue.text = model.min.description + "$"
                self.graphicState = .start
                self.drawGraphic()
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}

extension AnalyticViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            switch self.graphicState {
            case .start:
                self.graphicState = .middle
                self.midValue.text = (self.currentSalaryModel?.middle.description ?? "") + "$"
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.addGraphicAnimation(value: 1, from: 0.5)
                }
            case .middle:
                self.maxValue.text = (self.currentSalaryModel?.max.description ?? "") + "$"
                self.graphicState = .cancel
                
                if let index = self.lastSelectedIndex?.row  {
                    let language = self.models[index]
                    self.showPersonListController(language: language)
                }
            case .cancel:
                break
            }
        }
    }
}
