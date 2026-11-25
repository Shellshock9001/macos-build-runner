import SwiftUI

@main
struct RunnerProbe: App {
    var body: some Scene {
        WindowGroup {
            VStack(spacing: 18) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.green)
                Text("macOS runner")
                    .font(.largeTitle.bold())
                Text("Native iOS smoke test")
                    .font(.headline)
                Text("SwiftUI • Apple Silicon")
                    .foregroundStyle(.secondary)
            }
            .padding(32)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemBackground))
            .accessibilityIdentifier("runner-probe")
        }
    }
}
