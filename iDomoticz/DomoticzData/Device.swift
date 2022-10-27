//
//  Device.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 21/06/2022.
//

import Foundation

protocol DomoticzDeviceDefinition {
    var switchTypeCode: Int {get}
    var favorite: Int {get}
    var status: String {get set}
    var idx: String {get}
    var planID: String {get}
    var level: Int {get}
    var name: String {get}
}


class DomoticzDevice: ObservableObject {
    @Published var info: DomoticzDeviceDefinition
    
    public var favorite: Bool {
        get { return self.info.favorite == 1}
    }
    
    init (definition: DomoticzDeviceDefinition) {
        self.info = definition
    }
    
    public func updateStatus(status: String) {
        DispatchQueue.main.async {
            self.info.status = status
        }
    }
 
    public func setStatus(status: String) {}
}
