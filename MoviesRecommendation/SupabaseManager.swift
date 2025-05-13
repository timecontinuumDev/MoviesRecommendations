//
//  SupabaseManager.swift
//  MoviesRecommendation
//
//  Created by Mariusz Smoliński on 13.05.25.
//

import Foundation
import Supabase

public class SupabaseManager {
    static let shared = SupabaseManager()
    private let client: SupabaseClient
    
    private init() {
        let url = URL(string: APIKeys.supabaseURL)
        let key = APIKeys.supabaseAPIKey
        client = SupabaseClient(supabaseURL: url!, supabaseKey: key)
    }
    
    struct EmbeddingRow: Codable {
        let content: String
        let embedding: [Double]
    }
    
    func saveEmbedding(text: String, vector: [Double]) async throws {
        let row = EmbeddingRow(content: text, embedding: vector)
        let response = try await client.from("documents")
            .insert(row)
            .execute()
        //add error handling
        
        //        if let error = response. {
        //            throw EmbeddingError.requestFailed
        //        }
    }
}




