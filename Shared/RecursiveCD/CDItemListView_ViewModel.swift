//
//  CDItemListView_ViewModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 10/07/2023.
//

import SwiftUI
import Combine


// MARK: - ViewModel
extension CDItemListView {
    
    @MainActor class ViewModel: ObservableObject {
        
        var cancellables = Set<AnyCancellable>()
        
        // Model to deal with CD
        var model: CDItemListModel? = CDItemListModel()
        
        // MARK: - Bindables
        @Published var items: [Item]
        @Published var selectedItem: Item? {
            didSet{
                print("didSet selectedItem \(selectedItem?.title)")
            }
        }
        @Published var path: NavigationPath = NavigationPath()
        @Published var needUpdate: Bool = false
        
        // sub vm
        @Published var detailsVM: CDItemDetailsView.ViewModel
        
        var navigationTitle: String {
            return parentItem?.title ?? "Root"
        }
        
        // MARK: - Relational vars
        var parentItem: Item?
        var parentVM: ViewModel?
        //var subItemsVM: [String:TextInputView.ViewModel] = [:]
        
        // MARK: - init
        init(parentItem: Item? = nil, parentVM: ViewModel? = nil){
            
            self.items = parentItem?.itemsAsArray ?? []
            
            self.parentVM = parentVM
            self.parentItem = parentItem
            
            
            detailsVM = CDItemDetailsView.ViewModel(item: parentItem)
            
            addSubVMListeners()
        }
        
        func addSubVMListeners(){
            listenTitleChanges()
            listenNameChanges()
            listenTypeChangesAndValue()
        }
        
        // MARK: - Sub VM Listeners
        func listenTypeChangesAndValue(){
            detailsVM.typeListVM
                .$selectedType
                .sink { [weak self] value in
                    print("selectedType value: \(String(describing: value)) in CDItemListView_ViewModel")
                    if let _self = self, let item = self?.parentItem, let value = value {
                        
                    
                        _self.detailsVM.typeCellVM.text = _self.detailsVM.typeListVM.typeAndValueText(of: value)
                        
                        
                        item.valueType = value.asNSNumber
                        _self.model?.update(item: item)
                        
                    }
                }
                .store(in: &cancellables)
            
            // value changes (in typeListVM string)
            detailsVM.typeListVM.stringInputVM
                .$text
                .sink { [weak self] value in
                    print("stringInputVM value: \(String(describing: value)) in CDItemListView_ViewModel")
                    if let _self = self, let item = _self.parentItem {
                        
                        let uiString = _self.detailsVM.typeListVM.typeWithArrow() + value
                        _self.detailsVM.typeCellVM.text = uiString
                        
                        
                        _self.detailsVM.typeListVM.needUpdate.toggle()
                        
                        
                        item.valueString = value
                        _self.model?.update(item: item)
                    }
                }
                .store(in: &cancellables)
            
            // value changes (in typeListVM int)
            detailsVM.typeListVM.intInputVM
                .$text
                .sink { [weak self] value in
                    print("intInputVM value: \(String(describing: value)) in CDItemListView_ViewModel")
                    if let _self = self, let item = _self.parentItem {
                        
                        
                        _self.detailsVM.typeCellVM.text = _self.detailsVM.typeListVM.typeWithArrow() + value
                        
                        _self.detailsVM.typeListVM.needUpdate.toggle()
                        
                        item.valueInt = Int(value) as NSNumber?
                        _self.model?.update(item: item)
                    }
                }
                .store(in: &cancellables)
            
            // value changes (in typeListVM double)
            detailsVM.typeListVM.doubleInputVM
                .$text
                .sink { [weak self] value in
                    print("doubleInputVM value: \(String(describing: value)) in CDItemListView_ViewModel")
                    if let _self = self, let item = _self.parentItem {
                        
                        _self.detailsVM.typeCellVM.text = _self.detailsVM.typeListVM.typeWithArrow() + value
                        
                        _self.detailsVM.typeListVM.needUpdate.toggle()
                        
                        item.valueDouble = Double(value) as NSNumber?
                        _self.model?.update(item: item)
                    }
                }
                .store(in: &cancellables)
        }
        
        
        func listenTitleChanges(){
            detailsVM.titleVM
                .$text
                .sink { [weak self] value in
                    //print("name holder value: \(String(describing: value)) in CDItemListView_ViewModel")
                    if let item = self?.parentItem {
                        item.title = value
                        self?.model?.update(item: item)
                        self?.needUpdate.toggle()
                    }
                }
                .store(in: &cancellables)
        }
        
        func listenNameChanges(){
            detailsVM.nameVM
                .$text
                .sink { [weak self] value in
                    if let item = self?.parentItem {
                        item.name = value
                        self?.model?.update(item: item)
                        self?.needUpdate.toggle()
                    }
                }
                .store(in: &cancellables)
        }
        
        // MARK: - methods
        /// Add item
        func addItem(){
            print("⚠️ Implementing \(#function) in  CDItemListView_ViewModel")
            print("Add into parent: \(parentItem?.title) in CDItemListView_ViewModel")
            if let model = model {
                items = model.addItem(parentItem: parentItem)
                detailsVM.items = items
                
            }
        }
        
        /// Delete item
        func delete(at offsets: IndexSet) {
            print("⚠️ Implementing \(#function) in  CDItemListView_ViewModel")
            if let model = model {
                items = model.delete( items: items, offsets: offsets)
                detailsVM.items = items
            }
        }
        
        /// Move - reorder item
        func move(from source: IndexSet, to destination: Int) {
            print("⚠️ Implement \(#function) in  CDItemListView_ViewModel")
            if let model = model {
                items = model.move( items: items, from: source, to: destination)
                detailsVM.items = items
            }
        }
    }
}
