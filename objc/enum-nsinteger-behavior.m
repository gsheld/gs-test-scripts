/*
 * GOAL: 
 *      1) To test whether the compiler will allow NSInteger values to be passed into
 *         a function in place of an enumerated type with a backing NSInteger type.
 *      2) To observe the behavior when an NSInteger with no corresponding enumerated type value
 *         is passed into said function.
 *
 * FINDINGS:
 *      As it happens, there are no compiler/run-time errors at all for the following code. In fact
 *      the compiler will not even warn the user that there is case where no char* can be returned
 *      from `testFunctionWithEnum()`; in this case null is returned.
 *
 *  @author Grant Sheldon
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TestEnumType) {
    TestEnumTypeDefault = 0,
    TestEnumTypeSomethingElse = 1
};

char* testFunctionWithEnum(TestEnumType type) {
    switch (type) {
        case TestEnumTypeDefault:
            return "Default case";
            break;
        case TestEnumTypeSomethingElse:
            return "Something else case";
            break;
    }
}

int main(int argc, char * argv[]) {
    puts(testFunctionWithEnum(TestEnumTypeDefault));
    puts(testFunctionWithEnum(3));
}
