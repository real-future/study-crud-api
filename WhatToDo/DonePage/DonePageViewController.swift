//
//  DonePageViewController.swift
//  WhatToDo
//
//  Created by FUTURE on 2023/09/19.
//

import UIKit
import SnapKit
import CoreData

class DonePageViewController: UIViewController {
    
    // MARK: - Properties
    private var tableView: UITableView!
    
    // CoreDataManager 인스턴스
    let todoDataManager = CoreDataManager.shared
    
    var todos = [TodoData]()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchDataAndReloadTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        setNavigationBar()
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setNavigationBar() {
        // Navigation bar setup (if needed)
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoTableViewCell")
    }
    
    // MARK: - Data
    private func fetchDataAndReloadTableView() {
        todoDataManager.fetchData()
        todos = todoDataManager.todoList.filter { $0.isCompleted }
        tableView.reloadData()
    }
    
    private func saveChangesToCoreData() {
        do {
            try todoDataManager.context.save()
        } catch {
            print("Error saving Core Data changes: \(error)")
        }
    }
}



// MARK: - UITableViewDataSource
extension DonePageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        let todo = todos[indexPath.row]
        
        cell.configure(isCompleted: todo.isCompleted, title: todo.title ?? "")
        
        cell.delegate = self
        
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DonePageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "삭제 확인", message: "이 작업을 정말 삭제하시겠습니까?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (_) in
                // Core Data에서 삭제
                let taskToDelete = self.todos[indexPath.row]
                self.todoDataManager.context.delete(taskToDelete)
                
                // Core Data에 변경 사항 저장
                self.saveChangesToCoreData()
                
                // 로컬 데이터 배열에서 삭제하고 테이블 뷰 업데이트
                self.todos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }

}

// MARK: - TodoTableViewCellDelegate
extension DonePageViewController: TodoTableViewCellDelegate {
    func checkButtonTapped(in cell: TodoTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let todo = todos[indexPath.row]
            todo.isCompleted.toggle()
            
            // Core Data에 변경 사항 저장
            do {
                try todoDataManager.context.save()
            } catch {
                print("Error saving Core Data changes: \(error)")
            }
            
            // 변경된 isCompleted 상태를 반영하여 테이블 뷰 업데이트
            fetchDataAndReloadTableView()
        }
    }
    
    func contentAreaTapped(in cell: TodoTableViewCell) {
        // DonePage에서는 수정 기능을 비활성화하므로 이 메서드는 비워둡니다.
    }
}
