//
//  ViewController.swift
//  RxSwiftLesson
//
//  Created by Bruno Garcia on 11/11/2019.
//  Copyright © 2019 Bruno Garcia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    /// Scheduler for UI tasks
       var ui: SchedulerType {
           return MainScheduler.asyncInstance
       }
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    var filteredTasks : [Task] = []
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        segmentedControl.rx.selectedSegmentIndex.subscribe(onNext: { index in
            let type = Category(rawValue: index - 1)
            self.filterTasks(by: type)
            
            }).disposed(by: disposeBag)
        
        
    }
    
    private func filterTasks(by category: Category?) {
        if category == nil {
            self.filteredTasks = self.tasks.value
            self.updateTableView()
        } else {
            self.tasks.map{ task in
                return task.filter{ $0.category == category }
            }.subscribe(onNext: { [weak self] tasks in
                self?.filteredTasks = tasks
                self?.updateTableView()
            }).disposed(by: disposeBag)
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.filteredTasks[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addTaskIdentifier" {
            guard let destinationVC = segue.destination as? AddTaskViewController else { return }
            
            destinationVC.taskSubjectObj.subscribe(onNext: { task in
                
                var oldTasks = self.tasks.value
                oldTasks.append(task)
                self.tasks.accept(oldTasks)
                
                let type = Category(rawValue: self.segmentedControl.selectedSegmentIndex - 1)
                self.filterTasks(by: type)
                
            }).disposed(by: disposeBag)
        }
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

