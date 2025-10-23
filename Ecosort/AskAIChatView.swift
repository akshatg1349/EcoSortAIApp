//
//  AskAIChatView.swift
//  EcosortAI
//

import SwiftUI

struct AskAIChatView: View {
    @State private var input = ""
    @State private var messages: [String] = []
    @State private var errorMessage: String?
    @State private var tokenUsage: Int?

    private let chatService = ChatService()

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Ask EcoSort AI")
                        .font(.title)
                        .bold()
                        .padding(.top, 20)
                    
                    ForEach(messages, id: \.self) { msg in
                        Text(msg)
                            .padding()
                            .background(Color.green.opacity(0.15))
                            .cornerRadius(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }

            if let tokenUsage = tokenUsage {
                Text("Last response used \(tokenUsage) tokens")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.bottom, 4)
            }

            HStack {
                TextField("Type a message...", text: $input)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    sendMessage()
                }
                .disabled(input.isEmpty)
            }
            .padding()
        }
    }

    private func sendMessage() {
        let userText = input
        input = ""
        messages.append("You: \(userText)")

        chatService.sendMessage(userText) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (reply, usage)):
                    self.messages.append("AI: \(reply)")
                    self.tokenUsage = usage
                    self.errorMessage = nil
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

