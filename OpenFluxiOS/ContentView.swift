import SwiftUI

struct ContentView: View {
    @State private var running = false
    @State private var documentURL = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Yandex Docs") {
                    TextField(
                        "Document URL",
                        text: $documentURL
                    )
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                    Button(running ? "Stop" : "Start") {
                        toggleClient()
                    }
                }

                Section("Status") {
                    HStack {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundStyle(running ? .green : .red)

                        Text(running ? "OpenFlux running" : "Stopped")
                    }

                    if running {
                        Text("SOCKS5: 127.0.0.1:1080")
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle("OpenFlux")
        }
    }

    private func toggleClient() {
        if running {
            // Пока просто меняем UI.
            // Остановку добавим следующим этапом.
            running = false
            return
        }

        guard !documentURL.isEmpty else {
            return
        }

        documentURL.withCString { ptr in
            RunMainClient(UnsafeMutablePointer(mutating: ptr))
        }

        running = true
    }
}
