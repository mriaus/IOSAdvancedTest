//
//  MockApiProvider.swift
//  IOSAdvancedTestTests
//
//  Created by Marcos on 28/10/23.
//

import Foundation
@testable import IOSAdvancedTest


class MockApiProvider: ApiProviderProtocol {
    
    
    
    required init(secureDataProvider: IOSAdvancedTest.SecureDataProviderProtocol) {}
    
    func login(for user: String, with password: String) {
        if(user != "" && password != ""){
            NotificationCenter.default.post(
                name: NotificationCenter.APILOGINNOTIFICATION,
                object: nil,
                userInfo: [NotificationCenter.TOKENKEY: "12345"]
            )
        }else{
            NotificationCenter.default.post(
                name: NotificationCenter.APILOGINNOTIFICATION,
                object: nil,
                userInfo: [NotificationCenter.TOKENKEY: ""]
            )
        }
                
       
    }
    
    func getCharacters(by name: String?, token: String, completion: ((IOSAdvancedTest.Characters) -> Void)?) {
        do {
            let data = try JSONSerialization.data(withJSONObject: goodResponseDataCharacters)
            let characters = try? JSONDecoder().decode([Character].self,
                                                   from: data)
            
            if let name {
                completion?(characters?.filter { $0.name == name } ?? [])
            } else {
                completion?(characters ?? [])
            }
        } catch {
            completion?([])
        }
    }


    func getLocations(by characterId: String?, token: String, completion: ((IOSAdvancedTest.CharacterLocations) -> Void)?) {
        do {
            let data = try JSONSerialization.data(withJSONObject: goodResponseDataLocations)
            let locations = try? JSONDecoder().decode([CharacterLocation].self,
                                                      from: data)
            
            if characterId == "D13A40E5-4418-4223-9CE6-D2F9A28EBE94" {
                completion?(locations ?? [])
            } else {
                completion?([])
            }
        } catch {
            completion?([])
        }
    }







private let goodResponseDataCharacters: [[String: Any]] = [
    [
        "id": "D13A40E5-4418-4223-9CE6-D2F9A28EBE94",
        "name": "Goku",
        "description": "Sobran las presentaciones cuando se habla de Goku. El Saiyan fue enviado al planeta Tierra, pero hay dos versiones sobre el origen del personaje. Según una publicación especial, cuando Goku nació midieron su poder y apenas llegaba a dos unidades, siendo el Saiyan más débil. Aun así se pensaba que le bastaría para conquistar el planeta. Sin embargo, la versión más popular es que Freezer era una amenaza para su planeta natal y antes de que fuera destruido, se envió a Goku en una incubadora para salvarle.",
        "photo": "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300",
        "favorite": false
    ],
    [
        "id": "6E1B907C-EB3A-45BA-AE03-44FA251F64E9",
        "name": "Vegeta",
        "description": "Vegeta es todo lo contrario. Es arrogante, cruel y despreciable. Quiere conseguir las bolas de Dragón y se enfrenta a todos los protagonistas, matando a Yamcha, Ten Shin Han, Piccolo y Chaos. Es despreciable porque no duda en matar a Nappa, quien entonces era su compañero, como castigo por su fracaso. Tras el intenso entrenamiento de Goku, el guerrero se enfrenta a Vegeta y estuvo a punto de morir. Lejos de sobreponerse, Vegeta huye del planeta Tierra sin saber que pronto tendrá que unirse a los que considera sus enemigos.",
        "photo": "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/vegetita.jpg?width=300",
        "favorite": false
    ]
]
    
    let goodResponseDataLocations: [[String: Any]] = [
        [
            "id": "B93A51C8-C92C-44AE-B1D1-9AFE9BA0BCCC",
            "hero": [
                "id": "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"
            ],
            "latitud": "35.71867899343361",
            "longitud": "139.8202084625344",
            "dateShow": "2022-02-20T00:00:00Z"
        ],
        [
            "hero": [
                   "id": "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"
               ],
               "longitud": "35.71867899343361",
               "id": "74AD579F-A26D-495C-95D7-3DDA1D2B7E68",
               "latitud": "139.8202084625344",
               "dateShow": "2023-07-26T00:00:00Z"
           ],
           [
               "hero": [
                   "id": "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"
               ],
               "longitud": "35.71867899343361",
               "id": "0D5731C7-03F0-4A0C-9DD4-31345EF268A3",
               "latitud": "139.8202084625344",
               "dateShow": "2023-07-26T00:00:00Z"
           ],
           [
               "hero": [
                   "id": "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"
               ],
               "longitud": "35.71867899343361",
               "id": "CDF68E12-4929-4534-AEB6-D01336B75D6F",
               "latitud": "139.8202084625344",
               "dateShow": "2023-07-26T00:00:00Z"
           ],
           [
               "hero": [
                   "id": "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"
               ],
               "longitud": "35.71867899343361",
               "id": "F67023D6-62BD-45DB-91EA-1EAEB13E507A",
               "latitud": "139.8202084625344",
               "dateShow": "2023-10-18T00:00:00Z"
           ]
    ]
}
