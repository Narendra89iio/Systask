//
//  NewsApi.swift
//  NYTimesMostPopular
//
//  Created by Narendra Bokkasam on 09/04/18.
//  Copyright © 2018 Narendra. All rights reserved.
//

import Foundation

class NewsAPI: NSObject {
    
    static let service = NewsAPI()
    
    private static let basePath = "https://api.nytimes.com/svc/mostpopular/v2/mostviewed"
    private static let key = "7e11c87d12f143aaa500a3ab076bdb5d"
    
    
    @objc dynamic private(set) var articles: [Article] = []
    
    func resetArticles() {
        articles = []
    }
    
    func fetchArticles(by section: String) {
        let url = URL(string: "\(NewsAPI.basePath)/\(section)/\("7").json?api-key=\(NewsAPI.key)")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else { return }
            do {
                let str = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(str)
                if let dict = str as? Dictionary<String, Any> {
                    if let list = dict["results"] as? [Dictionary<String, Any>] {
                        var articlesFromData: [Article] = []
                        for object in list {
                            let article = Article(dict: object)
                            articlesFromData.append(article)
                        }
                        self.articles = articlesFromData
                    }
                }
            } catch {
                print("json error: \(error)")
            }
        })
        task.resume()
    }
}
