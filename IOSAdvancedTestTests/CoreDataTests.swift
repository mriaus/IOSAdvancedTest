//
//  CoreDataTests.swift
//  IOSAdvancedTestTests
//
//  Created by Marcos on 28/10/23.
//

import XCTest
@testable import IOSAdvancedTest
import CoreData

final class CoreDataTests: XCTestCase {

    var managedObjectContext: NSManagedObjectContext!
    private var sut: CoreDataProvider!
    
    override func setUp() {
        super.setUp()
        
        let persistentContainer = NSPersistentContainer(name: "IOSAdvancedTest")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        persistentContainer.persistentStoreDescriptions = [description]
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Not container config: \(error)")
            }
        }
        managedObjectContext = persistentContainer.viewContext
        sut = CoreDataProvider(context: managedObjectContext)

    }
    
    override func tearDown() {
        super.tearDown()
        managedObjectContext = nil
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_given_character() {
        let character = CharacterDAO(character: Character(id: "1234", name: "name1", description: "Desc1", photo: nil, isFavorite: false), context: managedObjectContext)
        do{
            try managedObjectContext.save()
        }catch {
            XCTFail("Error saving the user \(error)")
        }
        let fetchCharacter = NSFetchRequest<CharacterDAO>(entityName: CharacterDAO.entityName)
        fetchCharacter.predicate = NSPredicate(format: "name == %@", "name1")
        
        do{
            let character = try managedObjectContext.fetch(fetchCharacter)
            XCTAssertNotNil(character.first, "User not saved")
        }catch {
            XCTFail("Error when doing the fetch: \(error)")
        }
        managedObjectContext.delete(character)
    }
    
    func test_givenDataProvider_GivenACharacter_SaveTheCharacter(){
        let character = Character(id: "1234", name: "name1", description: "Desc1", photo: nil, isFavorite: false)
        
        sut.saveCharacter(character: character)
        let characters = sut.loadCharacters()
        let characterFiltered = characters.filter { characterFilter in
            characterFilter.id == "1234"
        }
        
        XCTAssertEqual(character.id, characterFiltered[0].id)
        managedObjectContext.delete(CharacterDAO(character: characterFiltered[0],context: managedObjectContext))
    }
    
    func test_givenDataProvider_RemoveAllTheCharacters(){
        sut.deleteAllCharacters()
        
       let characters = sut.loadCharacters()
        XCTAssertEqual(characters.count, 0)
    }

}
