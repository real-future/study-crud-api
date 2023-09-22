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
    private let todoDataManager = CoreDataManager.shared
    private var todos = [TodoData]()
    private var tableView: UITableView!
    
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataAndReloadTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        setupTableView()
        setupConstraints()
    }
    
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoTableViewCell")
    }
    
    
    private func setupConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    
    // MARK: - Data Handling
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
            presentDeleteConfirmation(for: indexPath)
        }
    }
    
    private func presentDeleteConfirmation(for indexPath: IndexPath) {
        let alert = UIAlertController(title: "삭제 확인", message: "이 작업을 정말 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.deleteTask(at: indexPath)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        self.present(alert, animated: true)
    }
    
    private func deleteTask(at indexPath: IndexPath) {
        let taskToDelete = todos[indexPath.row]
        todoDataManager.context.delete(taskToDelete)
        saveChangesToCoreData()
        todos.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}


// MARK: - TodoTableViewCellDelegate
extension DonePageViewController: TodoTableViewCellDelegate {
    func contentAreaTapped(in cell: TodoTableViewCell) {
        // DonePage에서는 수정 기능을 비활성화하므로 공란
    }
    
    
    func checkButtonTapped(in cell: TodoTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let todo = todos[indexPath.row]
        todo.isCompleted.toggle()
        saveChangesToCoreData()
        fetchDataAndReloadTableView()
    }
}
