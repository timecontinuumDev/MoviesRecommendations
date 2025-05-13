//
//  OpenAIDataModels.swift
//  MoviesRecommendation
//
//  Created by Mariusz Smoliński on 13.05.25.
//

import Foundation

struct EmbeddingsResponse: Decodable {
    struct EmbeddingData: Decodable {
        let embedding: [Double]
        let index: Int
        let object: String
    }
    let data: [EmbeddingData]
}
