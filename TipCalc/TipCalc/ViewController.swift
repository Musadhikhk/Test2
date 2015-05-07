//
//  ViewController.swift
//  TipCalc
//
//  Created by sanu on 2/19/15.
//  Copyright (c) 2015 musadhikh. All rights reserved.
//

import UIKit
import CoreLocation

enum Parseresult {
    case NumericVal(Int)
    case Error(String)
}

enum WCEnum {
    case Wildcard
    case FromBeginning
    case ToEnd
    case Literal(Int)
}

func ~= (pattern: [ WCEnum ], valu: [Int]) -> Bool {
    var ctr = 0
    for curntPattern in pattern {
        if ctr >= valu.count || ctr < 0 { return false }
        
        let curntVal = valu[ctr]
        
        switch curntPattern {
            
        case .Wildcard : ctr++
        case .FromBeginning where ctr == 0 : ctr = ( valu.count - pattern.count + 1)
        case .FromBeginning : return false
        case .ToEnd : return true
        case .Literal(let v) : if v != curntVal {return false}
        else {ctr++}
            
        default :
            break
        }
    }
    
    return true
}
class ViewController: UIViewController, CLLocationManagerDelegate, BeaconAnalisysDelegate, UITableViewDelegate {

    @IBOutlet var totalTextField : UITextField!
    @IBOutlet var taxPctSlider : UISlider!
    @IBOutlet var taxPctLabel : UILabel!
    @IBOutlet var resultsTextView : UITextView!
    var fibonacciMemo = Dictionary <Int, Double>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        for i in 1...100 {
//            println(fizzBuzz(i))
//        }

        
        var names = [0, 1, "Ewa", "Barry", "Daniella"]

        let f0 :NSString = "0"
        let f1 :NSString = "1"
        let (x, y) = swap( &names[0], thatOne: &names[1])
        println(" x = \(x), y =\(y)")
        let vals = (10,20)
        var person1 = (name: "musadhih", age: 25)
        var enums = Parseresult.Error("some thing went wrong")
        let sampleView = UIView()
        sampleView.frame = CGRectMake(0, 0, 20, 30)
        
        switch sampleView {
            case _ where sampleView.frame.size.height < 40 : println("small view ")
            default : println("default")
        }
       
        var person : Person?
           person = Person(name: "name0")
        
        closureMode("name" , { (completionName, flag) -> () in
            
            println("completion \(completionName) and flag  \(flag)")
            
        })
        
        let value = optionalTesting("key")
        print(value)
        if let val = optionalTesting("key") {
   
            println("\(val)")
        }
        else{
            println("no value")
        }
          operatorTesting()
        
        
    }

    func fizzBuzz(number: Int) -> String {
        switch (number % 3, number % 5) {
        case (0, 0):
            // number divides by both 3 and 5
            return "\(number) FizzBuzz!"
        case (0, _):
            // number divides by 3
            return "\(number) Fizz!"
        case (_, 0):
            // number divides by 5
            return "\(number) Buzz!"
        case (_, _):
            // number does not divide by either 3 or 5
            return "\(number)"
        }
    }

    func swap<T>(inout thisOne : T, inout thatOne: T) -> (T, T) {
        let tempThis = thisOne
        thisOne = thatOne
        thatOne = tempThis
        
        return (thisOne, thatOne)
    }
   
    
    func patterns(){
        
        
        //tuple pattern
        
        let values = [(1,0),(2,0),(3,1),(1,4),(4,2)]
        
        for (let x, let y) in values{
            println("tuple1 x = \(x), y = \(y)")
        }
        
        for (let (x, y)) in values{
            println("tuple2 x = \(x), y = \(y)")
        }
        
        //value binding pattern
        let value = (1,2)
        
        switch value {
        case let (x,y) :
            println(" value1 x = \(x), y = \(y)")
            break
        case (let x,let y) :
            println(" value2 x = \(x), y = \(y)")
            break
        default :
            break;
        }
        
        // wild card pattern
        for _ in  0...3 {
            
            println("123")
        }
        
    }
    
    func operatorTesting(){
        let wallWestHouse = Board(location: nil, name: "wall", longDesc: "blah blah blah")
        let pathWestOfHouse = Thing(location:nil, name: "Path", longDesc: "balh2 balh2 balh2")
        
        wallWestHouse.performPull(pathWestOfHouse)
    }
    
    func closureFunction(param1: NSArray, funct: ()-> Void, completion: ((Bool) -> Void?) ){
        
        println("something happend with \(param1)")
        
        
    }

    
    func blockTest(){
        
        let redBox = UIView(frame: CGRectMake(0, 0, 320, 50))
        redBox.backgroundColor = UIColor.redColor()
        self.view.addSubview(redBox)
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            
            redBox.alpha = 0
            
        }) { (Bool) -> Void in
            
            println("redbox has faded out")
        }
    }

    
    func testOptionals () {
        var jhon: Person?
        
    }
   func testMemory() {
    
    
      /* var john: Person?
         var number73: Apartment?
        
        john = Person(name: "John Appleseed")
        number73 = Apartment(number: 73)
        
        john!.apartment = number73
        number73!.tenant = john
        
        println("john name: \(john!.name) and apartment: \(john!.apartment)")
        println("Apartment num: \(number73!.number) and tenant: \(number73!.tenant)")

        number73 = nil
        john = nil
*/
     /*  var john: Customer?
        john = Customer(name: "John Appleseed")
        john!.card = CreditCard(number: 1234_5678_9012_3456, customer: john!)
    
        

        john = nil
        
        let initTest = Initializer(10,"name")
        
        let size = WandH(width: 10,height: 20)
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func optionalTesting(key:String) ->String? {
       
        if key == "key1" {
            return "val1"
        }
        else if key == "key2" {
            return "val2"
        }
        
        return nil
    }
    
    func initializeLocationMangaer() {
        var locationManager = CLLocationManager()
        locationManager.delegate = self;
        
    }
    @IBAction func calculateTapped(sender : AnyObject) {
        
        // 1
        tipCalc.total = Double((totalTextField.text as NSString).doubleValue)
        // 2
        let possibleTips = tipCalc.returnPossibleTips()
        var results = ""
        // 3
        var keys = Array(possibleTips.keys)
        sort(&keys)
        for tipPct in keys {
            let tipValue = possibleTips[tipPct]!
            let prettyTipValue = String(format:"%.2f", tipValue)
            results += "\(tipPct)%: \(prettyTipValue)\n"
        }
        // 5
        resultsTextView.text = results
    }
    @IBAction func taxPercentageChanged(sender : AnyObject) {
        tipCalc.taxPct = Double(taxPctSlider.value) / 100.0
        refreshUI()
    }
    @IBAction func viewTapped(sender : AnyObject) {
        totalTextField.resignFirstResponder()
    }

    let tipCalc = TipCalculatorModel(total: 33.25, taxPct: 0.06)
    
    func refreshUI() {
        // 1
        totalTextField.text = String(format: "%0.2f", tipCalc.total)
        // 2
        taxPctSlider.value = Float(tipCalc.taxPct) * 100.0
        // 3
        taxPctLabel.text = "Tax Percentage (\(Int(taxPctSlider.value))%)"
        // 4
        resultsTextView.text = ""
    }

    func beaconAnalysis(userInfo: NSDictionary) {
       
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
        var view = UIView(frame: CGRectMake(0, 0, 50, 50))
        
        return view;
    }
}

