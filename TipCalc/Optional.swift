//
//  Optional.swift
//  TipCalc
//
//  Created by sanu on 2/20/15.
//  Copyright (c) 2015 musadhikh. All rights reserved.
//

import Foundation

typealias CompletionBlock = ( completionName : NSString, flag: String) -> ()

func closureMode ( value: String, complt: ( completionName : NSString, flag: String) -> ())  {
    
    println("on my mark")
    var person = Person(name: value)
    var newName = person.testFun()
    complt(completionName: "success for ever",flag: newName)
}


class Person {
    let name: String?
    
    let age : Int
    init(name: String) {
        self.name = name
        age = 30
        println("\(name) is being initialized")
    }
    init(name : String, age: Int){
        self.name = name
        self.age = age
    }
    var apartment: Apartment?
    
    func testFun () -> String{
        return name!+" done"
    }
    
    class func clasFunc(){
        
    }
    
    deinit { println("\(name) is being deinitialized") }
}

class Apartment {
    let number: Int
    init(number: Int) {
        self.number = number
        println("Apartment #\(number) is being initialized")
    }
    weak var tenant: Person?

    deinit { println("Apartment #\(number) is being deinitialized") }
}

class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
        println("\(name) is being initialized")
    }
       
    deinit { println("\(name) is being deinitialized") }
}

class CreditCard {
    var number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
        println("Card #\(number) is being initialized")
    }
    deinit { println("Card #\(number) is being deinitialized") }
}
class Initializer {
    
    let number :Int
    var name : NSString
   
    init(){
        number = 0  //😈
        name = "John"
    }
    init(name : NSString){
        self.name = name
        number = 0
    }
    init(name : NSString, number : Int){
        self.name = name
        self.number = number
    }
    convenience init(_ integer : Int, _ strings : NSString){
       
        self.init(name : strings, number: 0)
    }
    
    
}

struct WandH {
    var width = 0, height = 0
}

class Thing {
    
    weak var location : Thing?
    var name : String
    var longDesc : String
    
    init(location : Thing?, name: String, longDesc: String){
        
        self.location = location
        self.name = name
        self.longDesc = longDesc
        
    }
}

class Board: Thing {
    weak var location1 : Board?
    var name1 : String
    var longDesc1 : String
    
    init(location : Board?, name: String, longDesc: String){
        
        self.location1 = location
        self.name1 = name
        self.longDesc1 = longDesc
        
        super.init(location: location, name: name, longDesc: longDesc)
    }
    
    func performPull(object: Thing){

        let string = an ~ object
        println("Printing  \(string)")
    }

}

infix operator ~  {}

func ~ (decorater: (Thing)-> String, object: Thing) -> String {
    
    return decorater(object)
}

func an(obj: Thing) -> String{
    
    let array: [Character] = ["a","A","e","E","i","I","o","O","u","U"]
    
    Thing.loadNibFrom("name", nibBundle: nil)
    
    for char in obj.name{
        
        if contains(array, char)
        {
            return obj.nameWithArticle
        }
        else
        {
            println("not contains")
        }
        break
    }

    return obj.name
}

extension Thing {
    
    class func loadNibFrom(nibName:String,nibBundle:NSBundle?){
        
    }
    var nameWithArticle: String { return "an " + name}
}

extension Thing: Printable {
    
    var description: String { return name}
}




