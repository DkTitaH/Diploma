//
//  APIService.swift
//  ITJobsNewsAndAnalytics
//
//  Created by iphonovv on 01.12.2020.
//

import Foundation

class APIService {
    
    enum ErrorType: Error {
        case invalidURL
        case parsingError
        case error(Error?)
    }
    
    enum Endpoint: String {
        case languages = "/languages"
        case salaryByLanguage = "/salary?language="
        case cities = "/cities"
        case salaryByCity = "/salary?city="
        case presonById = "/worker?id="
        case personsByLanguage = "/top_workers?language="
        case searchBySalary = "/salary?query="
    }
    
    static var shared: APIService {
        return APIService()
    }
    
    private let apiURL = "http://87.236.22.56"
    
    // Requests
    
    func getLanguages(completion: ((Result<[String], ErrorType>) -> ())?) {
        self.sendRequest(
            url: self.endpointURL(type: .languages),
            completion: completion
        )
    }
    
    func searchBySalary(salary: Int, completion: ((Result<[LanguageSalaryInPercentModel], ErrorType>) -> ())?) -> URLSessionDataTask? {
        return self.sendRequest(
            url: self.endpointURL(type: .searchBySalary).map { $0 + salary.description },
            completion: completion
        )
    }
    
    func getPerson(id: Int, completion: ((Result<PersonModel, ErrorType>) -> ())?) {
        self.sendRequest(
            url: self.endpointURL(type: .presonById).map { $0 + id.description },
            completion: completion
        )
    }
    
    func getCitites(completion: ((Result<[String], ErrorType>) -> ())?) {
        self.sendRequest(
            url: self.endpointURL(type: .cities),
            completion: completion
        )
    }
    
    func getTopOfCity(model: CityModel, completion: ((Result<Persons, ErrorType>) -> ())?) {
        let url = self.endpointURL(type: .salaryByCity).map { $0 + model.name }
        
        self.sendRequest(
            url: url,
            completion: completion
        )
    }
    
    func getPersonsByLanguage(model: AnalyticLanguageType, completion: ((Result<PersonsByLanguageModel, ErrorType>) -> ())?) {
        let url = self.endpointURL(type: .personsByLanguage).map { $0 + model.name }
        
        self.sendRequest(
            url: url,
            completion: completion
        )
    }
    
    func getSalary(model: AnalyticLanguageType, completion: ((Result<SalaryByLanguage, ErrorType>) -> ())?) {
        let url = self.endpointURL(type: .salaryByLanguage).map { $0 + model.name }
        
        self.sendRequest(
            url: url,
            completion: completion
        )
    }
    
    // Private methods
    
    private func endpointURL(type: Endpoint) -> URL? {
        let stringURL = self.apiURL + type.rawValue
        return URL(string: stringURL)
    }
    
    @discardableResult
    private func sendRequest<Value: Codable>(
        url: URL?,
        completion: ((Result<Value, ErrorType>) -> ())?
    )
        -> URLSessionDataTask?
    {
        guard let url = url else {
            completion?(.failure(.invalidURL))
            
            return nil
        }
        let request: URLRequest = .init(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                debugPrint(response)
            }
            
            
            if let error = error {
                DispatchQueue.main.async {
                    completion?(.failure(.error(error)))
                }
                
                return
            }
            
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
                
                if let model = try? JSONDecoder().decode(Value.self, from: data) {
                    DispatchQueue.main.async {
                        completion?(.success(model))
                    }
                } else {
                    completion?(.failure(.parsingError))
                }
            }
        }
        
        task.resume()
        
        return task
    }
}

struct Persons: Codable {
    var workers: [PersonModel]
}

struct PersonModel: Codable {
    var id: Int
    var position, language: String
    var specialization: String
    var workExperience, currentWorkExperience, monthSalary, changeSalary: Int
    var city: String
    var companySize: Int
    var companyType: String
    var sex: String
    var age: Int
    var education: String
    var university: String
    var studentStatus: String
    var englishLevel: String
    var subjectArea, fillingDate, userAgent: String
    var exp, currentJobExp, salary: Int
    var cls, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, position, language, specialization
        case workExperience = "work_experience"
        case currentWorkExperience = "current_work_experience"
        case monthSalary = "month_salary"
        case changeSalary = "change_salary"
        case city
        case companySize = "company_size"
        case companyType = "company_type"
        case sex, age, education, university
        case studentStatus = "student_status"
        case englishLevel = "english_level"
        case subjectArea = "subject_area"
        case fillingDate = "filling_date"
        case userAgent = "user_agent"
        case exp
        case currentJobExp = "current_job_exp"
        case salary, cls
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct LanguageSalaryInPercentModel: Codable {
    var name: String
    var percent: Double
}

struct PersonsByLanguageModel: Codable {
    var max: [PersonModel]
    var middle: [PersonModel]
    var min: [PersonModel]
}
