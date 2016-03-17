//
//  MenuDataSource.swift
//  SPA
//
//  Created by Coder on 2/2/16.
//  Copyright © 2016 OWA. All rights reserved.
//

import Foundation

class orderDataSource{
    
    var orderList:Array<[String]>
    
    init(){
        
        orderList = []
        
        
    }
    
    func fetchingFirstPage() -> Array<[String]>{
        var orderList:Array<[String]> = []
        
        let orderItems = backendless.data.of(toApprove.ofClass()).find(BackendlessDataQuery())
        let currentPage = orderItems.getCurrentPage()
        
        for object in currentPage as! [toApprove] {
            let name = object.item
            let owner = object.ownerId
            
            orderList.append([name!,owner!])
        }
        
        return orderList
        
    }
    
    func fetchingSecondPage() -> Array<[String]>{
        var orderList:Array<[String]> = []
        
        let orderItems = backendless.data.of(toApprove.ofClass()).find(BackendlessDataQuery())
        let currentPage = orderItems.getCurrentPage()
        
        for object in currentPage as! [toApprove] {
            let name = object.objectId
            
            orderList.append([name!])
        }
        
        return orderList
        
    }
    
}