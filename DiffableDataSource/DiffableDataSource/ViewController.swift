//
//  ViewController.swift
//  DiffableDataSource
//
//  Created by Ankit Tiwari on 18/07/20.
//  Copyright © 2020 Ankit Tiwari. All rights reserved.
//

import UIKit
enum Section:CaseIterable {
    case one
    case two
}


class MyDataSource : UITableViewDiffableDataSource <Section, Movies> {
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
              guard let moview = itemIdentifier(for: indexPath) else {return}
               var currentSnaoShot = snapshot()
            switch editingStyle {
              
                case .delete:
                    currentSnaoShot.deleteItems([moview])
                   
                case.insert:
                    currentSnaoShot.insertItems([Movies(name: "Spider Man")], afterItem: moview)
                default:
                    break
            }
            
            apply(currentSnaoShot)
        }
}

class ViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
   
    lazy var dataSource : MyDataSource = {
        return MyDataSource(tableView: tblView) { (tblView, index, movie) -> UITableViewCell? in
             let cell = tblView.dequeueReusableCell(withIdentifier: "DiffaTVCell", for: index) as! DiffaTVCell
                       cell.textLabel?.text = movie.name

                       return cell
             }
        }()

//        return UITableViewDiffableDataSource<Section, Movies>(tableView:tblView) { (tblView, index, movie) -> UITableViewCell? in
//
//            } as! MyDataSource
//    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblView.delegate = self
        tblView.dataSource = dataSource
        tblView.setEditing(true, animated: true)
               updateDataSource()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewDidLayoutSubviews() {
//        if !self.window {
//            return
//        }
        
        super.viewDidLayoutSubviews()
    }
 
    
    func updateDataSource() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Movies>()
        snapShot.appendSections(Section.allCases)
        snapShot.appendItems([Movies(name: "Batman"), Movies(name: "Aquaman"),Movies(name: "Wonder Women"), Movies(name: "Super man")], toSection: .one)
        snapShot.appendItems([Movies(name: "Avenger"), Movies(name: "End Game"), Movies(name: "Age of Utron"), Movies(name: "Civil War")], toSection: .two)
        dataSource.apply(snapShot, animatingDifferences: true, completion: nil)
        
    }
}


extension ViewController:UITableViewDelegate {
    
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // tblView.setEditing(true, animated: true)
       
    }
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
      return true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
    }
    
  
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return tableView.isEditing ? .delete : .delete
    }
    
   
    
}

class DemoList : UITableViewDiffableDataSource <Section, Movies> {
  
}

struct Movies : Hashable {
    static func == (lhs: Movies, rhs: Movies) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    var name: String
    var identifier = UUID()
    
    func hash(into hasher: inout Hasher) {
           return hasher.combine(identifier)
    }
}
