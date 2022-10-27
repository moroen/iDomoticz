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
        settings = Settings()
    }

    var body: some View {
        VStack {
            List {
                Section(header: Text("Domoticz")) {
                    LabelTextView("Host", value: $settings.domoticzConfig.host)
                    LabelTextView("Port", value: $settings.domoticzConfig.port)
                }
                Section(header: Text("MQTT")) {
                    LabelTextView("Enable", value: $settings.mqttConfig.enabled)
                    LabelTextView("Host", value: $settings.mqttConfig.host)
                    LabelTextView("Port", value: $settings.mqttConfig.port)
                    LabelTextView("Topic", value: $settings.mqttConfig.topic)
                }
            }

            Button(action: {
                self.settings.mqttConfig.saveConfig()
                self.settings.domoticzConfig.saveConfig()
                domoticzData.update()
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

@ViewBuilder func LabelTextView(_ label: String, value: Binding<String>) -> some View {
    VStack(alignment: .leading, spacing: 2) {
        Text(label).font(.caption).foregroundColor(Color(.placeholderText))
        TextField(label, text: value)
    }
}

@ViewBuilder func LabelTextView(_ label: String, value: Binding<Int>) -> some View {
    VStack(alignment: .leading, spacing: 2) {
        Text(label).font(.caption).foregroundColor(Color(.placeholderText))
        TextField(label, value: value, formatter: NumberFormatter()).keyboardType(.numberPad)
    }
}

@ViewBuilder func LabelTextView(_ label: String, value: Binding<Bool>) -> some View {
    VStack(alignment: .leading, spacing: 2) {
        Toggle(isOn: value) { Text(label).font(.caption).foregroundColor(Color(.placeholderText)) }
    }
}
