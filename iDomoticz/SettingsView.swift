//
//  SettingsView.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 10/05/2022.
//

import SwiftUI

struct CustomSettingsView: View {
    @ObservedObject var domoticzData: DomoticzData
    @ObservedObject var settings: Settings
    
    enum FocusedField: Hashable {
        case ip
        case port
    }
    
    
    @FocusState private var focusedField: FocusedField?
    
    
    init(domoticzData: DomoticzData) {
        
    
        self.domoticzData = domoticzData
        self.settings = Settings()
    }
    
    var body: some View {
        
        VStack {
            List {
                Section(header: Text("Domoticz")) {
                    IOSStringItem(label: "Host", value: $settings.domoticzConfig.host)
                    IOSIntItem(label: "Port", value: $settings.domoticzConfig.port)
                }
                Section(header: Text("MQTT")) {
                    IOSToggleItem(label: "Enable", value: $settings.mqttConfig.enabled)
                    IOSStringItem(label: "Host", value: $settings.mqttConfig.host)
                    IOSIntItem(label: "Port", value: $settings.mqttConfig.port)
                }
            }
            
            Button(action: {
                self.settings.mqttConfig.saveConfig()
                self.settings.domoticzConfig.saveConfig()
            }) {
                Text("Update")
            }
        }
        
        /*
        VStack {
            Form {
         
                Section(header: Text("Server")) {
                    TextField("Host", text: $settings.domoticzConfig.host)
                    
                    HStack {
                        Text("Port:")
                    
                    TextField("Port", value: $settings.domoticzConfig.port, formatter: NumberFormatter()).focused($focusedField, equals: FocusedField.port)
                    }
                }
                
                Section(header: Text("MQTT")) {
                    Toggle("Use MQTT", isOn: $settings.mqttConfig.enabled)
                    TextField("Host", text: $settings.mqttConfig.host)
                    TextField("Port", value: $settings.mqttConfig.port, formatter: NumberFormatter())
                }
            }.onSubmit {
            }
            
            Button(action: {
                settings.mqttConfig.saveConfig()
                domoticzData.loadDataFromUrl()
            }) {
                Text("Update")
            }
        }
         */
    }
}

struct IOSStringItem: View {
    var label: String
    var value: Binding<String>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.caption).foregroundColor(Color(.placeholderText))
            TextField("Host", text: value)
        }
    }
}

struct IOSIntItem: View {
    var label: String
    var value: Binding<Int>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.caption).foregroundColor(Color(.placeholderText))
            TextField("Host", value: value, formatter: NumberFormatter()).keyboardType(.numberPad)
            
        }
    }
}

struct IOSToggleItem: View {
    var label: String
    var value: Binding<Bool>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Text(label).font(.callout).foregroundColor(Color(.placeholderText))
            Toggle(isOn: value) {Text(label).font(.caption).foregroundColor(Color(.placeholderText))}
        }
         
            
        
    }
}
