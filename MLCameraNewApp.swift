//
//  MLCameraNewApp.swift
//  MLCameraNew
//
//  Created by Eirini Schoinas on 2/11/24.
//

import SwiftUI

@main
struct testApp: App {
    @StateObject var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            DebugModeView()
                .environmentObject(appModel)
            //#-learning-code-snippet(mlgameview.replace)
            .task {
                await appModel.useLastTrainedModel()
            }
        }
    }
}
