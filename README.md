# OpenClassroom - Project 5

General description:
- CountOnMe: Improve an existing application

Technical constraints:
- The code must:
    - Be commented correctly
    - Written in English
    - Respect the MVC pattern
    - Accompanied by complete unit tests
    - Allow the application to be displayed in all iPhone sizes in portrait mode.
    - Be free of any error or warning.
    - Be functional on iOS 11 and above and written in Swift 4 minimum.
    - The current algorithm should be preserved. The use of the expression NSExpression is not allowed.


Release notes:

dev-20221012:
- Setting up the MVC pattern
- Design improvement
- Code refactoring

dev-20221014:
- Using SwiftLint with a custom .swiftlint.yml file
- Responsive Design for all iPhone/iPad size in portrait and landscape mode
- Through Test-Driven Development:
    - Code refactoring
    - Added multiplication and division features
    - Added AC Button (All Clear)
    - Improved code to enable all features with given buttons (all cases) > No more alertVC/fatalError
- Unit/UI Tests passed (SimpleCalcTests cover 98,9% of the Model and SimpleCalcUITests cover 96,8% of the Controller)
- Changed iOS target from 12.2 to 11 as required
