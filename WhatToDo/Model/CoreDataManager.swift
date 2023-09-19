//
//  File.swift
//  WhatToDo
//
//  Created by FUTURE on 2023/09/15.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    var todoList = [TodoData]()
    
    
    //싱글톤
    static let shared = CoreDataManager()
    private init() {}
    
    
    //앱 델리게이트 내부에 영구 컨테이너가 영구 저장소를 불러오는 코드가 있어. & 임시 저장소의 내용을 저장하는 메서드가 있어.
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //임시저장소
    lazy var context = appDelegate.persistentContainer.viewContext
    
    //엔터티 이름
    let modelName: String = "TodoData"
    
    
    //MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    func fetchData() {
        //객체 생성하여 TodoData 타입 데이터 가져올 거라고 명시
        let fetchRequest: NSFetchRequest<TodoData> = TodoData.fetchRequest()
        //CoreData의 context 가져오는 곳. DB와 앱 사이에서 데이터 임시 저장하고 관리
        let context = appDelegate.persistentContainer.viewContext
        //do가 성공, catch가 실패할 때 실행
        do {
            self.todoList = try context.fetch(fetchRequest)
            print("Fetched Data: \(self.todoList)")
            
        } catch {
            print(error)
        }
    }
    
    //MARK: - [Create] 코어데이터에 데이터 생성하기
    //특정 TodoData 완료 상태 변경하고 저장
    func saveTodoData(isCompleted: Bool, index: Int, completion: @escaping () -> Void) {
        let context = appDelegate.persistentContainer.viewContext
        self.todoList[index].isCompleted =  isCompleted
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    //특정 ID를 가진 TodoData 삭제
    func deleteTodoData(with id: UUID, completion: @escaping () -> Void) {
        let context = appDelegate.persistentContainer.viewContext
        
        if let index = todoList.firstIndex(where: { $0.id == id }) {
            // 해당 TodoData를 Core Data의 Context에서 삭제
            let todoDataToDelete = todoList[index]
            context.delete(todoDataToDelete)
            
            do {
                // Context에 변경이 있을 경우 저장
                try context.save()
                // todoList 배열에서도 해당 TodoData를 삭제
                todoList.remove(at: index)
                completion()  // 완료 후 실행할 작업
            } catch {
                print(error)
            }
        }
    }
    
    func createTodoData(title: String, isCompleted: Bool, date: Date) -> TodoData? {
        let context = appDelegate.persistentContainer.viewContext

        let todoData = TodoData(context: context)
        todoData.id = UUID()
        todoData.title = title
        todoData.isCompleted = isCompleted
        todoData.createDate = date
        
        do {
            try context.save()
            return todoData
        } catch {
            print("Error creating todo data: \(error)")
            return nil
        }
    }
    
    
    func updateTodoData(id: UUID, newTitle: String, completion: @escaping () -> Void) {
        let context = appDelegate.persistentContainer.viewContext
        if let index = todoList.firstIndex(where: { $0.id == id }) {
            todoList[index].title = newTitle
            todoList[index].modifyDate = Date() // 수정 날짜를 현재 날짜로 설정

            do {
                try context.save()
                completion()
            } catch {
                print("Error updating todo data: \(error)")
            }
        }
    }

    
    
}



