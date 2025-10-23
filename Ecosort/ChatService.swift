//
//  ChatService.swift
//  EcosortAI
//

import Foundation

enum ChatError: Error, LocalizedError {
    case rateLimited
    case quotaExceeded
    case networkError
    case decodingError
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .rateLimited:
            return "Too many requests. Please wait a moment and try again."
        case .quotaExceeded:
            return "You’ve reached your usage limit. Please check your API plan or billing."
        case .networkError:
            return "Network error. Please check your connection."
        case .decodingError:
            return "Could not read the AI response."
        case .unknown(let msg):
            return msg
        }
    }
}

struct ChatRequest: Codable {
    let model: String
    let messages: [[String: String]]
}

struct ChatResponse: Codable {
    struct Choice: Codable {
        let message: Message
    }
    struct Message: Codable {
        let role: String
        let content: String
    }
    let choices: [Choice]
    // Optional: token usage info
    struct Usage: Codable {
        let prompt_tokens: Int
        let completion_tokens: Int
        let total_tokens: Int
    }
    let usage: Usage?
}

class ChatService {
    private let apiKey = "Key"

    func sendMessage(_ text: String,
                     completion: @escaping (Result<(String, Int?), ChatError>) -> Void) {
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ChatRequest(
            model: "gpt-4o-mini", // cheaper, faster model for chat
            messages: [["role": "user", "content": text]]
        )
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.networkError))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 429: // Too Many Requests
                    completion(.failure(.rateLimited))
                    return
                case 402, 403: // Payment Required / Forbidden
                    completion(.failure(.quotaExceeded))
                    return
                default:
                    break
                }
            }
            
            guard let data = data else {
                completion(.failure(.networkError))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)
                let reply = decoded.choices.first?.message.content ?? ""
                let tokenUsage = decoded.usage?.total_tokens
                completion(.success((reply, tokenUsage)))
            } catch {
                // Try to decode error JSON
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let errorDict = json["error"] as? [String: Any],
                   let message = errorDict["message"] as? String {
                    completion(.failure(.unknown(message)))
                } else {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}
