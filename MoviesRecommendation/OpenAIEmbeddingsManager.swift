//
//  OpenAIEmbeddingsManager.swift
//  MoviesRecommendation
//
//  Created by Mariusz Smoliński on 13.05.25.
//

import Foundation
import Alamofire

class OpenAIEmbeddingsManager {
    private let apiKey = APIKeys.openAIAPIKey
    private let url = "https://api.openai.com/v1/embeddings"
    private let model = "text-embedding-ada-002"
    
    func fetchEmbedding(for text: String) async throws -> [Double] {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        let parameters: Parameters = [
            "model": model,
            "input": text
        ]
        
        do{
            let dataTask = AF.request(
                url,
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers
            )
                .validate()
                .serializingDecodable(EmbeddingsResponse.self)
            
            let response = try await dataTask.value
            
            guard let embedding = response.data.first?.embedding else {
                throw AFError.responseValidationFailed(reason: .dataFileNil)
            }
            return embedding
            
        }catch{
            throw EmbeddingError.requestFailed
        }
    }
}

enum EmbeddingError: LocalizedError {
    case requestFailed
    
    var errorDescription: String? {
        "Failed to fetch an embedding."
    }
}

