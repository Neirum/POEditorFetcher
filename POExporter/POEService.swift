//
//  POEService.swift
//  POExporter
//
//  Created by Stas Zherebkin on 12/1/17.
//  Copyright © 2017 prog. All rights reserved.
//

import Foundation

final class POEService {
    
    private let apiClient = POEApiClient(baseUrl: POEApi.endpoint)

    
    func loadProjectsList(completion: @escaping ([ProjectModel], Error?) -> Void) {
        let params = ["api_token": POEApi.apiToken]
        apiClient.load(action: POEApiActions.projectsList, params: params) { (data, error) in
            guard let data = data else {
                completion([], error ?? POEApiError.custom("Unknown error"))
                return
            }
            //Serialization server response
            let decoder = JSONDecoder()
            
                let _ = try! decoder.decode(POEApiModel.self, from: data)

            guard
                let fullResponse = try? decoder.decode(POEApiModel.self, from: data),
                let projModels = try? decoder.decode([ProjectModel].self, from: fullResponse.result!)
            else {
                completion([], POEApiError.custom("Json serialization error"))
                return
            }
            completion(projModels, error)
        }
    }
    
    func loadLanuagesList(from project: ProjectModel, completion: @escaping ([LanguageModel], Error?) -> Void) {
        
    }
    
    func loadTranslationFileLink(of language: LanguageModel, from project: ProjectModel, completion:  @escaping (String, Error?) -> Void) {
        
    }
    
}

fileprivate extension POEService {
    
    func decodeResponseJson(from data: Data) {
        
    }
}
