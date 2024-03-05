/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI
import Charts



struct DebugModeView: View {
    @EnvironmentObject var appModel: AppModel
    
    private var livePredictionData: [PredictionMetric] {
        return appModel.predictionProbability.data
    }
   
    func doWork() -> Text {
        struct Holder {
            static var check = "not done"
        }
        print(Holder.check)
        if (Holder.check != "done")
        {
            let _ = print(appModel.predictionLabel)
            let _ = appModel.camera.takePhoto()
            Holder.check = "done"
        }
        return Text("done")
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 0) {
                CameraView(showNodes: true)
                    .environmentObject(appModel)
                    .overlay(alignment: .bottomTrailing) {
                        PredictionLabelOverlay(label: appModel.predictionLabel, showIcon: false)
                    }
               // let result = print("Prediction", appModel.predictionLabel)

                // let _ = try await (appModel.camera.start())
                //let _ = print("Probability", appModel.predictionProbability)
                //let _ = print("Can?", appModel.canPredict)
                
                /*
                if (check != "done" && appModel.predictionLabel == "Rock")
                {
                    let _ = appModel.camera.takePhoto()
                    let _ = print("Called")
                    let _ = print(check)
                    let _ = print(appModel.predictionLabel)
                    doWork()
                //}*/
                doWork()
                
                
                
                predictionBarChart()
            }
            .task {
                await appModel.findExistingModels()
            }
            .toolbar {
                availableMLModelsToolbarItem()
            }
        }
        .accentColor(.accent)
    }

    private func predictionBarChart() -> some View {
        VStack {
            Chart(livePredictionData, id: \.category) {
                BarMark(xStart: .value("zero", 0.0),
                        xEnd: .value("Probability", $0.value),
                        y: .value("Category", $0.category))
            }
            .chartXScale(domain: 0...1)
            .chartXAxisLabel("Confidence")
            .chartXAxis(.visible)
            .chartYAxis(.visible)
            .animation(.easeIn, value: livePredictionData)
            .foregroundColor(.accent)
        }
        .modifier(ChartViewStyle())
    }

    private func availableMLModelsToolbarItem() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink {
                MLModelListView()
                    .environmentObject(appModel)
            } label: {
                Text("ML Models")
            }
        }
    }
}

struct DebugModeView_Previews: PreviewProvider {
    static var previews: some View {
        DebugModeView()
            .environmentObject(AppModel())
    }
}
