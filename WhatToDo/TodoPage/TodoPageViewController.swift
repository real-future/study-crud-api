//
//  TodoPageViewController.swift
//  WhatToDo
//
//  Created by FUTURE on 2023/09/15.
//

import UIKit
import SnapKit
import CoreData

class TodoPageViewController: UIViewController {
    
    // MARK: - Properties
    private var tableView: UITableView!
    
    
    //CoreDataManager 인스턴스
    let todoDataManager = CoreDataManager.shared
    
    var todos = [TodoData]()
    
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 뷰가 나타날 때 데이터를 불러오고 테이블 뷰를 리로드
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
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        
        // 셀 등록
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoTableViewCell")
    }
    
    
    // MARK: - Navigation Bar Button Action
    @objc func addButtonTapped() {
        let addAlert = UIAlertController(title: "Add a Task", message: "Please enter within 28 characters", preferredStyle: .alert)
        
        addAlert.addTextField {(textField: UITextField) in
            textField.placeholder = "28 characters or less"
            textField.delegate = self
        }
        
        // 취소 버튼
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        
        // 저장 버튼
        let save = UIAlertAction(title: "Save", style: .default) { _ in
            if let title = addAlert.textFields?.first?.text {
                self.addNewTask(title: title)
            }
        }
        
        // 액션 추가
        addAlert.addAction(cancel)
        addAlert.addAction(save)
        
        // 알림 창 표시
        self.present(addAlert, animated: true)
    }
    
    // 새로운 태스크를 추가하는 메서드
    func addNewTask(title: String) {
        // Core Data context 가져오기
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // TodoData Entity
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "TodoData", in: context) else { return }
        guard let object = NSManagedObject(entity: entityDescription, insertInto: context) as? TodoData else { return }
        
        // 텍스트 필드에 입력된 값을 저장
        object.title = title
        object.createDate = Date()
        object.id = UUID()
        object.isCompleted = false
        
        // Core Data에 저장
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.saveContext()
        
        // 새로운 데이터를 가져오고 테이블 뷰를 리로드
        todoDataManager.fetchData()
        todos = todoDataManager.todoList
        
        tableView.reloadData()
    }
    
    
    
    
    // MARK: - Data
    
    private func fetchDataAndReloadTableView() {
        // 데이터 불러오기
        todoDataManager.fetchData()
        // 테이블 뷰 리로드
        todos = todoDataManager.todoList
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


// MARK: - TodoTableViewCellDelegate
extension TodoPageViewController: TodoTableViewCellDelegate {
    func contentAreaTapped(in cell: TodoTableViewCell) {
            if let indexPath = tableView.indexPath(for: cell) {
                let todo = todos[indexPath.row]
                let updateAlert = UIAlertController(title: "Update Task", message: "Please modify the content", preferredStyle: .alert)
                
                updateAlert.addTextField { (textField: UITextField) in
                    textField.text = todo.title
                    textField.delegate = self
                }
                
                // 취소 버튼
                let cancel = UIAlertAction(title: "Cancel", style: .default)
                
                // 업데이트 버튼
                let update = UIAlertAction(title: "Update", style: .default) { _ in
                    if let updatedContent = updateAlert.textFields?.first?.text {
                        // Core Data에 변경 사항을 저장
                        todo.title = updatedContent
                        todo.modifyDate = Date() // 수정된 날짜 설정
                        self.saveChangesToCoreData()
                        
                        // 셀 업데이트
                        cell.configure(isCompleted: todo.isCompleted, title: updatedContent)
                        cell.updateDateLabel(createDate: todo.createDate!, modifyDate: todo.modifyDate)
                    }
                }
                
                // 액션 추가
                updateAlert.addAction(cancel)
                updateAlert.addAction(update)
                
                // 알림 창 표시
                self.present(updateAlert, animated: true)
            }
        }
    
    func checkButtonTapped(in cell: TodoTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let todo = todos[indexPath.row]
            todo.isCompleted.toggle()
            cell.configure(isCompleted: todo.isCompleted, title: todo.title ?? "")
            // Core Data에 변경 사항 저장
            saveChangesToCoreData()
        }
    }
}
    


// MARK: - UITableViewDataSource
extension TodoPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        let todo = todos[indexPath.row]
        cell.configure(isCompleted: todo.isCompleted, title: todo.title ?? "")

        
        // 델리게이트 설정
        cell.delegate = self
        
        cell.titleLabel.text = todo.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        if let date = todo.createDate {
            cell.dateLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateLabel.text = ""
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TodoPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}

extension TodoPageViewController: UITextFieldDelegate {
    // 텍스트 필드의 텍스트가 변경될 때 호출
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // 업데이트된 텍스트의 길이를 확인
        if updatedText.count > 28 {
            shakeTextField(textField)
            return false
        }
        return true
    }
    
    
    // 텍스트 필드 애니메이션-흔들기
    func shakeTextField(_ textField: UITextField) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        textField.layer.add(animation, forKey: "shake")
        
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
    }
    
}




