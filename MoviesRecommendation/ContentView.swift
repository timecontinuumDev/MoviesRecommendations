//
//  ContentView.swift
//  MoviesRecommendation
//
//  Created by Mariusz Smoliński on 13.05.25.
//

import SwiftUI

struct ContentView: View {
    @State private var userInput: String = ""
    @State private var embedding: [Double] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    private let embeddingsManager = OpenAIEmbeddingsManager()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Enter text to embed", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    Task {
                        await generateAndSaveEmbedding()
                    }
                }) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Generate Embedding")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .disabled(userInput.isEmpty || isLoading)
                .padding(.horizontal)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                if !embedding.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text("Embedding Result (\(embedding.count) dimensions):")
                                .font(.subheadline)
                                .bold()
                                .padding(.bottom, 5)
                            
                            Text(embedding.map { String(format: "%.4f", $0) }.joined(separator: ", "))
                                .font(.caption)
                                .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Text Embedding")
        }
    }
    
    @MainActor
    private func generateAndSaveEmbedding() async {
        errorMessage = nil
        embedding = []
        isLoading = true
        
        do {
            let vector = try await embeddingsManager.fetchEmbedding(for: userInput)
            embedding = vector
            try await SupabaseManager.shared.saveEmbedding(text: userInput, vector: vector)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

#Preview {
    ContentView()
}
