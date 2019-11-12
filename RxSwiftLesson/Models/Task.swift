//
//  Task.swift
//  RxSwiftLesson
//
//  Created by Bruno Garcia on 11/11/2019.
//  Copyright © 2019 Bruno Garcia. All rights reserved.
//

import Foundation

enum Category: Int {
    case Work
    case Home
    case Personal
}

struct Task {
    var name: String
    var category: Category
}
