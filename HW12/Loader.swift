
import Foundation
import Alamofire




class Loader{
    
    func request1(urlString: String , completition: @escaping (Result<Weather, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error{
                    print("error")
                    completition(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let decoder = JSONDecoder()
                    let info = try decoder.decode(Weather.self, from: data)
                    completition(.success(info))
                    
                } catch let jsonError {
                    print("Failed JSON", jsonError)
                    completition(.failure(jsonError))
                }
            }
            
        }.resume()

      }
    
    func request2(urlString: String, completition: @escaping (Coords) -> Void) {
        AF.request(urlString).responseDecodable(of: Coords.self) { (response) in
            guard let info = response.value else { return }
           completition(info)
        }
    }
    
    }
    
    
    
    
    
    
    



