//
//  ViewController.swift
//  reactiveKitBond
//
//  Created by Mogyoródi Balázs on 2017. 04. 28..
//  Copyright © 2017. Mogyoródi Balázs. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond
import Alamofire
import PromiseKit

class ViewController: UIViewController {

    @IBOutlet weak var buttonka: UIButton!
    @IBOutlet weak var resultsTable: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var twoWayField: UITextField!
    @IBOutlet weak var twoWayLabelResult: UILabel!
    
    let mainVM = SWMainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainVM.persons.bindAnimated(to: resultsTable) { dataSource, indexPath, tableView in
            
            let cell = (tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? PersonTableViewCell)!
            let viewModel = dataSource[indexPath.row]
            
            viewModel.name?.bind(to: cell.nameLabel.reactive.text).dispose(in: cell.bag)
            //            viewModel.height?.bind(to: cell.eyeColorView.reactive.backgroundColor).dispose(in: cell.bag)
            //            viewModel.created?.map { "\($0)" }.bind(to: cell.ageLabel).dispose(in: cell.bag)
            
            return cell
        }
        
        twoWayField.reactive.text.bidirectionalMap(to: { Int($0!)! }, from: { "\($0)" }).bidirectionalBind(to: mainVM.twoWayText)
        
        //twoWayField.reactive.text.map({ Int($0!)! }).bind(to: mainVM.twoWayText)
        mainVM.twoWayText.map({ "\($0)" }).bind(to: twoWayLabelResult)
        
        Alamofire.request("http://swapi.co/api/people/", method: .get)
            .responseJsonDictionary()
            .then { json -> Void in
                
                for case let result in json["results"] as! [Any] {
                    let person = try Person(json: result as! [String : Any])
                    self.mainVM.persons.append(person)
                }
            }.catch{ error in
                print(error)
        }
        
        buttonka.reactive.tap.observeNext { [weak self] _ in
            guard let weakSelf = self else { return }
            
            weakSelf.mainVM.twoWayText.value = 1234
        }.dispose(in: bag)

    }
}

public struct AnimatedTableViewBond<DataSource: DataSourceProtocol>: TableViewBond {
    
    let createCell: (DataSource, IndexPath, UITableView) -> UITableViewCell
    
    public func apply(event: DataSourceEvent<DataSource>, to tableView: UITableView) {
        switch event.kind {
        case .reload:
            tableView.reloadData()
        case .insertItems(let indexPaths):
            tableView.insertRows(at: indexPaths, with: .right)
        case .deleteItems(let indexPaths):
            tableView.deleteRows(at: indexPaths, with: .left)
        case .reloadItems(let indexPaths):
            tableView.reloadRows(at: indexPaths, with: .left)
        case .moveItem(let indexPath, let newIndexPath):
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .insertSections(let indexSet):
            tableView.insertSections(indexSet, with: .left)
        case .deleteSections(let indexSet):
            tableView.deleteSections(indexSet, with: .left)
        case .reloadSections(let indexSet):
            tableView.reloadSections(indexSet, with: .left)
        case .moveSection(let index, let newIndex):
            tableView.moveSection(index, toSection: newIndex)
        case .beginUpdates:
            tableView.beginUpdates()
        case .endUpdates:
            tableView.endUpdates()
        }
    }
    
    public func cellForRow(at indexPath: IndexPath, tableView: UITableView, dataSource: DataSource) -> UITableViewCell {
        return createCell(dataSource, indexPath, tableView)
    }
    
    public func titleForHeader(in section: Int, dataSource: DataSource) -> String? {
        return nil
    }
    
    public func titleForFooter(in section: Int, dataSource: DataSource) -> String? {
        return nil
    }
}

public extension SignalProtocol where Element: DataSourceEventProtocol, Error == NoError {
    
    public typealias DataSource = Element.DataSource
    
    @discardableResult
    public func bindAnimated(to tableView: UITableView, createCell: @escaping (DataSource, IndexPath, UITableView) -> UITableViewCell) -> Disposable {
        return bind(to: tableView, using: AnimatedTableViewBond<DataSource>(createCell: createCell))
    }
}



