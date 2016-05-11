/// This playground checks to make sure that you don't need to do [unowned self] in a lazy var
/// closure that doesn't retain self.

import Foundation

class MyClass {
  deinit {
    print("MyClass dealloc")
  }
}

class MyParentClass {
  private let myObject1 = MyClass()
  private let myObject2 = MyClass()

  // We don't do unowned self here
  private lazy var viewsDict: [String: MyClass] = {
    return [
      "one": self.myObject1,
      "two": self.myObject2
    ]
  }()

  deinit {
    print("MyParentClass dealloc")
  }
}

// We expect MyClass dealloc to pe printed twice for this function and MyParentClass dealloc to be printed once
func test() {
  let a = MyParentClass()
  print(a.viewsDict)
}

// We expect MyClass dealloc to pe printed twice for this function and MyParentClass dealloc to be printed once
func testWithoutAccessingViewsDict() {
  let a = MyParentClass()
  print(a)
}

// If [unowned self] is not needed, MyClass dealloc should be printed 4 times total, MyParentClass dealloc
// should be printed twice total. If [unowned self] is needed, no deallocs will be printed due to retain cycle.
test()
testWithoutAccessingViewsDict()
