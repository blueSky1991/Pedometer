//
//  PedometerManger.swift
//  Pedometer
//
//  Created by 张东东 on 2017/4/13.
//  Copyright © 2017年 张东东. All rights reserved.
//

import UIKit
import HealthKit


final class PedometerManger: NSObject {
    
    var healthStore : HKHealthStore?
    
    
    static var shareInstance: PedometerManger {
        
        struct Static {
            
            static let instance: PedometerManger = PedometerManger()
        }
        
        return Static.instance
    }
    
     private override init() {}
    
    
     func authorizeHealthKit(version:CGFloat , completion: @escaping (Bool,Error?) -> ()) {
        
         if version > 8.0 {
            
            if HKHealthStore.isHealthDataAvailable() {
                
                self.healthStore = HKHealthStore.init()
                let write = writeCompetence()
                let read = readCompetence()

                self.healthStore?.requestAuthorization(toShare: write, read: read, completion: { (success, error) in
                    
                     completion(success, error)
                    
                })

            }else{
            
                let error : NSError = NSError.init(domain: "com.raywenderlich.tutorials.healthkit", code: 2, userInfo: [NSLocalizedDescriptionKey : "HealthKit is not available in th is Device"])
                
                    completion(false,error)
                
                   return

            }
        
         }else{
            
            let error : NSError = NSError.init(domain: "com.sdqt.healthError", code: 0, userInfo: [NSLocalizedDescriptionKey : "iOS 系统低于8.0"])
            
            completion(false,error)

            
        }
    
    }
    
    
    public func getStepCount(completion: @escaping (Int,Error?) -> ()) {
    
        let stepCount = HKQuantityType.quantityType(forIdentifier: .stepCount)

        let timeSortDescriptor = NSSortDescriptor.init(key:HKSampleSortIdentifierEndDate, ascending: false)
        
    
        let query = HKSampleQuery.init(sampleType:stepCount!, predicate: predicateForSamplesToday(), limit: 0, sortDescriptors: [timeSortDescriptor]) { (query, results, error) in
            
            if (error != nil) {
                completion(0,error)
            }else{
            
                var  totleSteps:Double = 0.0;
                
                for i in 0 ..< (results?.count)! {
                    
                     let quantitySample =  results?[i] as! HKQuantitySample
                     let quantity = quantitySample.quantity
                     let heightUnit = HKUnit.count()
                     let usersHeight = quantity.doubleValue(for:heightUnit)
                     totleSteps += usersHeight
                }
                
                
                completion(Int(totleSteps),error)
            }

        }
        
        self.healthStore?.execute(query)
        
    }
    
    //获取公里数
    public func getDistance(compltion: @escaping (Double,Error?) -> ()){
    
    
        let WalkingRunning = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)
        
        let timeSortDescriptor = NSSortDescriptor.init(key:HKSampleSortIdentifierEndDate, ascending: false)
        
        
        let query = HKSampleQuery.init(sampleType:WalkingRunning!, predicate: predicateForSamplesToday(), limit: 0, sortDescriptors: [timeSortDescriptor]) { (query, results, error) in
            
            if (error != nil) {
                compltion(0,error)
            }else{
                
                var  totleSteps:Double = 0.0;
                
                for i in 0 ..< (results?.count)! {
                    let quantitySample =  results?[i] as! HKQuantitySample
                    let quantity = quantitySample.quantity
                    let kiloUnit = HKUnit.meterUnit(with: .kilo)
                    let usersHeight = quantity.doubleValue(for: kiloUnit)
                    totleSteps += usersHeight
                    
                }
                

                
                
                compltion(totleSteps,error)
            }
            
            
            
        }
        
        self.healthStore?.execute(query)

        
        
    }
    
    func predicateForSamplesToday() -> NSPredicate {
        
        let calendar = Calendar.current

        let set = Set.init(arrayLiteral:Calendar.Component.day,Calendar.Component.month,Calendar.Component.year)
        
        var components = calendar.dateComponents(set, from: Date.init())
        
        components.hour = 0
        components.minute = 0
        components.second = 0

        let startDate = calendar.date(from: components)
        let endDate = calendar.date(byAdding: Calendar.Component.day, value: 1, to: startDate!, wrappingComponents: true)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .init(rawValue: 0))
        return predicate
        
        
    }
    

    
    
    
}


extension PedometerManger{

    fileprivate   func writeCompetence() -> Set<HKQuantityType> {
    
        let heightType = HKQuantityType.quantityType(forIdentifier: .height)
        let bodyMassType = HKQuantityType.quantityType(forIdentifier: .bodyMass)
        let bodyTemperatureType = HKQuantityType.quantityType(forIdentifier: .bodyTemperature)
        let activeEnergyBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)
        
        return Set.init(arrayLiteral: heightType!,bodyMassType!,bodyTemperatureType!,activeEnergyBurnedType!)
        
    }
    
    fileprivate   func readCompetence() -> Set<HKQuantityType> {
        let height = HKQuantityType.quantityType(forIdentifier: .height)
        let bodyMass = HKQuantityType.quantityType(forIdentifier: .bodyMass)
        let bodyTemperature = HKQuantityType.quantityType(forIdentifier: .bodyTemperature)
        let stepCount = HKQuantityType.quantityType(forIdentifier: .stepCount)
        let distanceWalkingRunning = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)
        let activeEnergyBurned = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)
        return Set.init(arrayLiteral: height!,bodyMass!,bodyTemperature!,stepCount!,distanceWalkingRunning!,activeEnergyBurned!)
    }
    

}





