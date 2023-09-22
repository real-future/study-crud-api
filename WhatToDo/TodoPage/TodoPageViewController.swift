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
    private let todoDataManager = CoreDataManager.shared
    private var todos = [TodoData]()
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoTableViewCell")
        return tableView
    }()
    
    
    private let floatingButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .skyBlue
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 뷰가 나타날 때 데이터를 불러오고 테이블 뷰를 리로드
        fetchDataAndReloadTableView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        setNavigationBar()
        setupConstraints()
    }
    
    
    private func setNavigationBar() {
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    
    private func setupConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(floatingButton)
        floatingButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
    
    
    // MARK: - Button Actions
    @objc func addButtonTapped() {
        presentAlert()
    }
    
    
    // MARK: - Data Handling
    private func fetchDataAndReloadTableView() {
        // 데이터 불러오기
        todoDataManager.fetchData()
        // isCompleted가 false인 할 일만 필터링
        todos = todoDataManager.todoList.filter { !$0.isCompleted }
        // 테이블 뷰 리로드
        tableView.reloadData()
    }
    
    
    private func saveChangesToCoreData() {
        do {
            try todoDataManager.context.save()
        } catch {
            print("Error saving Core Data changes: \(error)")
        }
    }
    
    
    
    
    func addNewTask(title: String) {
        guard let newTodo = createTodoEntity(title: title) else { return }
        saveTodoEntity(todo: newTodo)
        fetchDataAndReloadTableView()
    }
    
    
    private func createTodoEntity(title: String) -> TodoData? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "TodoData", in: context) else { return nil }
        guard let newTodo = NSManagedObject(entity: entityDescription, insertInto: context) as? TodoData else { return nil }
        
        newTodo.title = title
        newTodo.createDate = Date()
        newTodo.id = UUID()
        newTodo.isCompleted = false
        return newTodo
    }
    
    
    private func saveTodoEntity(todo: TodoData) {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.saveContext()
    }
    
    
    @objc func presentAlert() {
        let addAlert = UIAlertController(title: "Add a Task", message: "28자 이내로 입력해주세요", preferredStyle: .alert)
        
        addAlert.addTextField {(textField: UITextField) in
            textField.placeholder = "28자 이내로 입력해주세요"
            textField.delegate = self
        }
        
        // 취소 버튼
        let cancel = UIAlertAction(title: "취소", style: .default)
        
        // 저장 버튼
        let save = UIAlertAction(title: "저장", style: .default) { _ in
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
    
    
    func showToast(message: String, duration: TimeInterval = 5.0) {
        let toastLabel = UILabel(frame: CGRect(x: 16, y: self.view.frame.size.height - 100, width: self.view.frame.size.width - 32, height: 35))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.font = UIFont.systemFont(ofSize: 12)
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: duration, delay: 0.8, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}


// MARK: - TodoTableViewCellDelegate
extension TodoPageViewController: TodoTableViewCellDelegate {
    func contentAreaTapped(in cell: TodoTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let todo = todos[indexPath.row]
            let updateAlert = UIAlertController(title: "Update Task", message: "내용을 수정해주세요", preferredStyle: .alert)
            
            updateAlert.addTextField { (textField: UITextField) in
                textField.text = todo.title
                textField.delegate = self
            }
            
            // 취소 버튼
            let cancel = UIAlertAction(title: "취소", style: .default)
            
            // 업데이트 버튼
            let update = UIAlertAction(title: "수정", style: .default) { _ in
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
            
            // Core Data에 변경 사항 저장
            do {
                try todoDataManager.context.save()
            } catch {
                print("Error saving Core Data changes: \(error)")
            }
            
            // 변경된 isCompleted 상태를 반영하여 테이블 뷰 업데이트
            fetchDataAndReloadTableView()
            
            // isCompleted가 true일 경우 토스트 메시지 띄우기
            if todo.isCompleted {
                showToast(message: "🎉 완료된 할 일은 donePage에서 확인하실 수 있습니다. 🎉")
            }
        }
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



// MARK: - UITableViewDataSource
extension TodoPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        print("Cell editing style: \(cell.editingStyle)")
        
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
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        print("commit editingStyle called")
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "삭제 확인", message: "이 작업을 정말 삭제하시겠습니까?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (_) in
                // Core Data에서 삭제
                let taskToDelete = self.todos[indexPath.row]
                self.todoDataManager.context.delete(taskToDelete)
                
                // Core Data에 변경 사항 저장
                do {
                    try self.todoDataManager.context.save()
                } catch {
                    print("Error saving Core Data changes: \(error)")
                }
                
                // 로컬 데이터 배열에서 삭제하고 테이블 뷰 업데이트
                self.todos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}


// MARK: - UITextFieldDelegate
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
}
