/**
 * GOAL:
 *    To check to make sure that you don't need to do [unowned self] in a lazy var closure that doesn't retain self.
 *
 * FINDINGS:
 *    You don't need to use [unowned self] in a lazy var closure that doesn't retain self directly (i.e. only uses
 *    self.property1, self.property2, etc.
 *
 * Version: Apple Swift version 2.2 (swiftlang-703.0.18.5 clang-703.0.31)
 * Date:    5-11-2016
 * Author:  Noah Gilmore
 */

import Foundation

class MyClass {
  deinit {
    print("MyClass dealloc")
  }
}

class MyContainerClass {
  private let myObject1 = MyClass()
  private let myObject2 = MyClass()

  // We don't do unowned self here
  fileprivate lazy var viewsDict: [String: MyClass] = {
    return [
      "one": self.myObject1,
      "two": self.myObject2
    ]
  }()

  deinit {
    print("MyParentClass dealloc")
  }
}

// We expect MyClass dealloc to pe printed twice for this function and MyContainerClass dealloc to be printed once
func test() {
  let a = MyContainerClass()
  print(a.viewsDict)
}

// We expect MyClass dealloc to pe printed twice for this function and MyContainerClass dealloc to be printed once
func testWithoutAccessingViewsDict() {
  let a = MyContainerClass()
  print(a)
}

// If [unowned self] is not needed, MyClass dealloc should be printed 4 times total, MyContainerClass dealloc
// should be printed twice total. If [unowned self] is needed, no deallocs will be printed due to retain cycle.
test()
testWithoutAccessingViewsDict()
