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

class ViewController: UIViewController, CanvasLayoutDelegate {

    @IBOutlet weak var buttonka: UIButton!
    @IBOutlet weak var resultsTable: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var twoWayField: UITextField!
    @IBOutlet weak var twoWayLabelResult: UILabel!
    @IBOutlet weak var bondView: UIView!
    @IBOutlet weak var bondCollectionView: UICollectionView!
    
    let mainVM = SWMainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = bondCollectionView?.collectionViewLayout as? CanvasUICollectionViewLayout {
            layout.delegate = self
        }
        
//        mainVM.persons.bindAnimated(to: resultsTable) { dataSource, indexPath, tableView in
//            
//            let cell = (tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? PersonTableViewCell)!
//            let viewModel = dataSource[indexPath.row]
//            
//            viewModel.name?.bind(to: cell.nameLabel.reactive.text).dispose(in: cell.bag)
//            //            viewModel.height?.bind(to: cell.eyeColorView.reactive.backgroundColor).dispose(in: cell.bag)
//            //            viewModel.created?.map { "\($0)" }.bind(to: cell.ageLabel).dispose(in: cell.bag)
//            
//            return cell
//        }
        
        mainVM.viewWidth.bind(to: bondView.reactive.width)
        mainVM.viewOrigin.bind(to: bondView.reactive.origin)
        
        mainVM.persons.bind(to: bondCollectionView) { dataSource, indexPath, collectionView in
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? PersonCollectionViewCell)!
            
            let viewModel = dataSource[indexPath.row]
            viewModel.name?.bind(to: cell.personName.reactive.text).dispose(in: cell.bag)
            viewModel.cellWidth?.bind(to: cell.reactive.width).dispose(in: cell.bag)
            viewModel.origin?.bind(to: cell.reactive.origin).dispose(in: cell.bag)
            cell.frame.origin.x = 20
            
            return cell
        }
        //twoWayField.reactive.text.map({ Int($0!)! }).bind(to: mainVM.twoWayText)
        //mainVM.twoWayText.map({ "\($0)" }).bind(to: twoWayLabelResult)
        
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
            weakSelf.mainVM.viewWidth.value = 100
            weakSelf.mainVM.viewOrigin.value = CGPoint(x: 100, y: 200)
            weakSelf.mainVM.persons[0].cellWidth?.value = 200
            weakSelf.mainVM.persons[0].origin?.value = CGPoint(x: 100, y: 200)
            weakSelf.mainVM.persons[1].origin?.value = CGPoint(x: 10, y: 120)
            
        }.dispose(in: bag)

    }
    
    func collectionView(collectionView:UICollectionView, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let item = mainVM.persons[indexPath.item]
        return CGSize(width: 20, height: (item.height?.value)!)
    }
    
    // 2
    func collectionView(collectionView: UICollectionView, originForItemAtIndexPath indexPath: NSIndexPath) -> CGPoint {
        let item = mainVM.persons[indexPath.item]
        return (item.origin?.value)!
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

extension ReactiveExtensions where Base: UIView {
    var width: Bond<CGFloat?> {
        return bond { view, width in
            view.frame.size.width = width!
        }
    }
    
    var origin: Bond<CGPoint?> {
        return bond { view, origin in
            view.frame.origin = origin!
        }
    }
}




