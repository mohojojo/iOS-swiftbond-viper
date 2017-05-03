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

class ViewController: UIViewController {

    @IBOutlet weak var buttonka: UIButton!
    @IBOutlet weak var resultsTable: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    let carVM = CarViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carVM.tempName.bidirectionalBind(to: textField.reactive.text)
        
        
        buttonka.reactive.tap.observeNext { [weak self] _ in
            guard let weakSelf = self else { return }
            
            weakSelf.carVM.results.append(CarModel(JSONString: "{ \"type\":\"Audi\", \"year\": 1984, \"color\": \"red\" }")!)
            
        }.dispose(in: bag)

        carVM.results.bindAnimated(to: resultsTable) { dataSource, indexPath, tableView in
            
            let cell = (tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? TextTableViewCell)!
            let viewModel = dataSource[indexPath.row]
            
            viewModel.type?.bind(to: cell.cellText).dispose(in: cell.bag)
            viewModel.color?.bind(to: cell.cellText.reactive.textColor).dispose(in: cell.bag)
            viewModel.year?.map { "\($0)" }.bind(to: cell.yearInput).dispose(in: cell.bag)
        
            return cell
        }
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



