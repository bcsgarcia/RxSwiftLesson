//
//  AddTaskViewController.swift
//  RxSwiftLesson
//
//  Created by Bruno Garcia on 11/11/2019.
//  Copyright © 2019 Bruno Garcia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddTaskViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var taskTxt: UITextField!
    @IBOutlet weak var btn: UIButton!
    
    let disposeBag = DisposeBag()
    
    /// Scheduler for UI tasks
    var ui: SchedulerType {
        return MainScheduler.asyncInstance
    }
    
    private let taskSubject = PublishSubject<Task>()
    
    var taskSubjectObj: Observable<Task>{
        return taskSubject.asObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservables()
        
    }

}

extension AddTaskViewController {
    private func setupObservables() {
        
        btn.rx.tap.observeOn(ui).subscribe({ [weak self] _ in
            guard let strongSelf = self else { return }
            
            guard let type = Category(rawValue: strongSelf.segmentedControl.selectedSegmentIndex), let title = strongSelf.taskTxt.text else { return }
            
            if title != "" {
                let newTask = Task(name: title, category: type)
                strongSelf.taskSubject.onNext(newTask)
                strongSelf.dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "", message: "Please, type a title for your task", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                strongSelf.present(alert, animated: true)
            }
        }).disposed(by: disposeBag)
        
        taskTxt.rx.text.orEmpty.asObservable().subscribe(onNext: { [weak self] value in
            guard let strongSelf = self else { return }
            strongSelf.btn.isEnabled = value != ""
            strongSelf.btn.backgroundColor = value != "" ? .green : .darkGray
        }).disposed(by: disposeBag)
        
        btn.setTitleColor(.white, for: .disabled)
        btn.setTitleColor(.black, for: .normal)
    }
    
    
}
