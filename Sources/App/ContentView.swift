import SwiftUI

struct ContentView: View {
    @State private var message = "Hello from SwiftCode!"

    var body: some View {
        VStack(spacing: 20) {
            Text(message)
                .font(.largeTitle)
                .multilineTextAlignment(.center)

            Button("Tap Me") {
                message = "Built on Windows"
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
