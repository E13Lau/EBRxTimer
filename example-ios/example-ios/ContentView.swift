//
//  ContentView.swift
//  example-ios
//
//  Created by lau on 2020/12/8.
//

import SwiftUI
import EBRxTimer

struct ContentView: View {
    var model = EBRxTimer()
    var body: some View {
        Text(model.text)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
