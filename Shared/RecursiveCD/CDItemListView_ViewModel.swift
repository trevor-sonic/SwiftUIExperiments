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
        
        @Published var objectNames: [String] = []
        
        // sub vm
        @Published var detailsVM: CDItemDetailsView.ViewModel
        @Published var addSheetVM = ArrayTypesListView.ViewModel()
        @Published var showingSheet = false
        
        var navigationTitle: String {
            return parentItem?.title ?? "Root"
        }
        
        // MARK: - Relational vars
        @Published var parentItem: Item?
        var parentVM: ViewModel?
        
        // MARK: - init
        init(parentItem: Item? = nil, parentVM: ViewModel? = nil){
            
            self.items = parentItem?.itemsAsArray ?? []
            
            self.parentVM = parentVM
            self.parentItem = parentItem
            
            
            detailsVM = CDItemDetailsView.ViewModel(item: parentItem)
            
            
            
            setObjectNames()
            setObjectProperty()

            setAddSheetItems()
            
            addSubVMListeners()
            
        }
        
        func loadItem(){
            
            print("⚠️ Implementing RE \(#function) in CD List")
            if let uuid = parentItem?.uuidAsString {
                if let item  = ItemCRUD().findBy(uuid: uuid){
                    self.parentItem = item
                    self.items = item.itemsAsArray
                }
            }
            
        }
        
        func test(){
            //let path = "rootItem.car.driver"
            let path = "rootItem.gallery"
            
            let theItem = ItemCRUD().getItem(path: path)
            print("👉🏻 theItem: \(String(describing: theItem?.title))")
            
            let items = ItemCRUD().getItems(path: path)
            items.map{
                print("👉🏻 item: \($0.name)")
            }
            
            
//            items[0].isDeleted
        }
        // set object names for detailsVM and ArrayTypeList
        func setObjectNames(){
            let objects = ItemCRUD().findObjects(isMasterObject: true)
            objectNames = objects.compactMap{ $0.name }
            print("👉🏻 objectNames: \(String(describing: objectNames))")
            detailsVM.objectNames = objectNames
            
            if let valueArray = parentItem?.valueArray{
                
                // use rawValue for known types and object name for object type
                let rawValue = Int(valueArray) ?? Item.ValueType.object(nil).rawValue
                    
                   let standardType = Item.ValueType(rawValue: rawValue, name: valueArray )
                    print("👉🏻 standardType: \(String(describing: standardType))")

                // set initial selected array type
                detailsVM.typeListVM.arrayTypesListVM.selectedType = Item.ValueType(rawValue: rawValue, name: valueArray )
            }
            
        }
        func setObjectProperty(){
            guard let valueObject = parentItem?.valueObject else {return}
            detailsVM.typeListVM.objectPropertyVM
                .isMasterObject = valueObject == "master" ? true:false
        }
        func setAddSheetItems(){
            addSheetVM.validTypes = Item.ValueType.addNewTypes
            addSheetVM.objectNames = objectNames
        }
        func addSubVMListeners(){
            listenTitleChanges()
            listenNameChanges()
            listenTypeChangesAndValue()
            listenArrayTypeSelection()
            listenObjectPropertyChanges()
            listenAddItem()
        }
        
        // MARK: - Sub VM Listeners
        func listenTypeChangesAndValue(){
            detailsVM.typeListVM
                .$selectedType
                .sink { [weak self] value in
                    print("selectedType value: \(String(describing: value)) in CDItemListView_ViewModel")
                    if let _self = self, let item = self?.parentItem, let value = value {
                        
                        if item.valueType != value.asNSNumber {
                            
                            _self.detailsVM.typeCellVM.text = _self.detailsVM.typeListVM.typeAndValueText(of: value)
                            
                            
                            item.valueType = value.asNSNumber
                            _self.model?.update(parentItem: _self.parentItem, item: item, property: .valueType)
                        }
                    }
                }
                .store(in: &cancellables)
            
            // value changes (in typeListVM string)
            detailsVM.typeListVM.stringInputVM
                .$text
                .sink { [weak self] value in
                    print("stringInputVM value: \(String(describing: value)) in CDItemListView_ViewModel")
                    if let _self = self, let item = _self.parentItem {
                        
                        if item.valueString != value{
                            let uiString = _self.detailsVM.typeListVM.typeWithArrow() + value
                            _self.detailsVM.typeCellVM.text = uiString
                            
                            
                            _self.detailsVM.typeListVM.needUpdate.toggle()
                            
                            
                            item.valueString = value
                            _self.model?.update(parentItem: _self.parentItem, item: item, property: .valueString)
                        }
                    }
                }
                .store(in: &cancellables)
            
            // value changes (in typeListVM int)
            detailsVM.typeListVM.intInputVM
                .$text
                .sink { [weak self] value in
                    print("intInputVM value: \(String(describing: value)) in CDItemListView_ViewModel")
                    if let _self = self, let item = _self.parentItem {
                        
                        if item.valueInt != Int(value).getAsNSNumber() {
                            _self.detailsVM.typeCellVM.text = _self.detailsVM.typeListVM.typeWithArrow() + value
                            
                            _self.detailsVM.typeListVM.needUpdate.toggle()
                            
                            item.valueInt = Int(value).getAsNSNumber()
                            _self.model?.update(parentItem: _self.parentItem, item: item, property: .valueInt)
                        }
                    }
                }
                .store(in: &cancellables)
            
            // value changes (in typeListVM double)
            detailsVM.typeListVM.doubleInputVM
                .$text
                .sink { [weak self] value in
                    print("doubleInputVM value: \(String(describing: value)) in CDItemListView_ViewModel")
                    if let _self = self, let item = _self.parentItem {
                        
                        
                        
                        if item.valueDouble != Double(value).getAsNSNumber() {
                            _self.detailsVM.typeCellVM.text = _self.detailsVM.typeListVM.typeWithArrow() + value
                            
                            _self.detailsVM.typeListVM.needUpdate.toggle()
                            
                            item.valueDouble = Double(value).getAsNSNumber()
                            _self.model?.update(parentItem: _self.parentItem, item: item, property: .valueDouble)
                        }
                        
                    }
                }
                .store(in: &cancellables)
        }
        func listenObjectPropertyChanges(){
            detailsVM.typeListVM.objectPropertyVM
                .$isMasterObject
                .sink { [weak self] value in
                    if let _self = self, let item = _self.parentItem {
                        let stringValue = value ? "master":""
                        if item.valueObject != stringValue {
                            item.valueObject = stringValue
                            _self.model?.update(parentItem: _self.parentItem, item: item, property: .valueObject)
                        }
                    }
                }
                .store(in: &cancellables)
        }
        func listenArrayTypeSelection(){
            detailsVM.typeListVM.arrayTypesListVM
                .$selectedType
                .sink { [weak self] value in
                    
                    if let value = value {
                        if let _self = self, let item = _self.parentItem {
                            var name  = ""
                            switch value {
                            case .object(let objectName):
                                if let objectName = objectName {
                                    name = objectName
                                }
                                
                            default:
                                name = value.rawValue.description
                            }
                            
                            if item.valueArray != name {
                                item.valueArray = name
                                _self.model?.update(parentItem: _self.parentItem, item: item, property: .valueArray)
                            }
                        }
                    }
                }
                .store(in: &cancellables)
        }
        func listenAddItem(){
            addSheetVM
                .$selectedType
                .sink { [weak self] value in
                    
                    if let value = value {
                        if let _self = self {
                            print("⚠️ name: \(value) is selected \(#function) in CDItemList_ViewModel")
                            _self.showingSheet = false
                            _self.addItem(valueType: value)
                        }
                    }
                }
                .store(in: &cancellables)
        }
        func listenTitleChanges(){
            detailsVM.titleVM
                .$text
                .sink { [weak self] value in
                    //print("name holder value: \(String(describing: value)) in CDItemListView_ViewModel")
                    if let item = self?.parentItem, item.title != value {
                        
                        self?.model?.update(parentItem: self?.parentItem, item: item, property: .title(value))
                        self?.needUpdate.toggle()
                    }
                }
                .store(in: &cancellables)
        }
        
        func listenNameChanges(){
            detailsVM.nameVM
                .$text
                .sink { [weak self] value in
                    if let item = self?.parentItem, item.name != value {
                        
                        self?.model?.update(parentItem: self?.parentItem, item: item, property: .name(value))
                        self?.needUpdate.toggle()
                    }
                }
                .store(in: &cancellables)
        }
        
        // MARK: - methods
        func checkAddItemType(){
            if let type = detailsVM.typeListVM.selectedType,
                type == .array,
               let arrayType = detailsVM.typeListVM.arrayTypesListVM.selectedType {
                addItem(valueType: nil)
            }else{
                showingSheet = true
            }
            
        }
        /// Add item
        func addItem(valueType: Item.ValueType?){
            
            print("Add into parent: \(parentItem?.title) in CDItemListView_ViewModel")
            
            if let type = detailsVM.typeListVM.selectedType,
                type == .array,
               let arrayType = detailsVM.typeListVM.arrayTypesListVM.selectedType {
                
                
                print("⚠️ Add \(arrayType) array Item Implementing \(#function) in  CDItemListView_ViewModel")
                
                if let model = model {
                    items = model.addItem(parentItem: parentItem, valueType: arrayType)
                    detailsVM.items = items
                    
                }
                
                
            }else{
                
                if let model = model, let valueType = valueType {
                    //items = model.addItem(parentItem: parentItem)
                    items = model.addItem(parentItem: parentItem, valueType: valueType)
                    detailsVM.items = items
                    
                }
            }
        }
        
        /// Delete item
        func delete(at offsets: IndexSet) {
            if let model = model {
                items = model.delete(parentItem: parentItem, items: items, offsets: offsets)
                detailsVM.items = items
            }
        }
        
        /// Move - reorder item
        func move(from source: IndexSet, to destination: Int) {
            if let model = model {
                items = model.move(parentItem: parentItem, items: items, from: source, to: destination)
                detailsVM.items = items
            }
        }
    }
}
