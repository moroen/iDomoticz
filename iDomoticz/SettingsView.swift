//
//  SettingsView.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 10/05/2022.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var domoticzData: DomoticzData
    @State private var ip: String
    @State private var port: Int
    
    enum FocusedField: Hashable {
        case ip
        case port
    }
    
    
    @FocusState private var focusedField: FocusedField?
    
    
    init(domoticzData: DomoticzData) {
        self.ip = domoticzData.host
        self.port = domoticzData.port
        self.domoticzData = domoticzData
    }
    
    var body: some View {
        
        VStack {
            Form {
         
                
                Section(header: Text("Server")) {
                    TextField("Host", text: $ip)
                    TextField("Port", value: $port, formatter: NumberFormatter()).focused($focusedField, equals: FocusedField.port)
                }
                
                Section() {
                
                }
            }.onSubmit {
                domoticzData.host=ip
                domoticzData.port=port
            }
            
            Button(action: {
                domoticzData.host=ip
                domoticzData.port=port
                domoticzData.loadDataFromUrl()
            }) {
                Text("Update")
            }
        }
    }
}

struct ActionTextField: View {
    @State private var value: String = ""
    @FocusState private var hasFocus: Bool
    
    private var action: (String)->Void
    
    init(action: @escaping (String)->Void) {
        self.action = action
    }
    
    var body: some View {
        TextField("Test", text: $value).focused($hasFocus).onChange(of: hasFocus, perform: {focused in
            if !focused {self.action(self.value)}
        }).onSubmit {
            self.action(self.value)
        }
    }
}
    
    /*
     struct SettingsView_Previews: PreviewProvider {
     static var previews: some View {
     SettingsView()
     }
     }
     */
