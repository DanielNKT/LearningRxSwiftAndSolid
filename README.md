🧠 LearningRxSwiftAndSolid

A demo iOS project built to explore RxSwift, SOLID principles, and Clean Architecture — featuring modular layers, reactive bindings, and complete unit tests.

🚀 Overview

This project demonstrates how to structure an iOS app that follows Clean Architecture while maintaining SOLID design principles. It’s intended as a learning and showcase project for building scalable, testable, and maintainable Swift codebases using RxSwift.

🧩 Key Features

✅ Reactive programming with RxSwift and RxCocoa

✅ Strict separation of concerns via Clean Architecture

✅ Strong adherence to SOLID principles

✅ Dependency Injection for easy testability

✅ Environment-based configuration (DEV / PRD)

✅ Full unit test coverage with mock data sources

✅ Lightweight and readable UseCase–Repository–ViewModel flow

🏗 Architecture
* Configs/       → Environment setup (DEV, PRD)
* Data/          → Data sources (API, persistence, DTOs, Repositories)
* Domain/        → Business logic (Entities, UseCases, Interfaces)
* Presentation/  → UI layer (ViewModels, RxSwift bindings)
* Util/          → Reusable helpers and extensions
* Mock/          → Mock data and repositories for unit testing

🔁 Data Flow Overview
View ↔ ViewModel ↔ UseCase ↔ Repository ↔ DataSource


* Presentation Layer:
Contains reactive ViewModels that expose inputs and outputs using Observable, Driver, or Relay.

* Domain Layer:
Defines application-specific business logic in the form of UseCases, independent of frameworks or UI.

* Data Layer:
Implements the data retrieval logic, connecting APIs, databases, or mock data to the repositories.

* Configs & Util:
Support modular configuration and environment-based setup.

🧱 SOLID Principles in Practice
Principle	Application Example
* Single Responsibility:	Each layer and class has one reason to change — e.g., UserRepositoryImpl only manages data sources.
* Open/Closed:	UseCases and Repositories are open for extension but closed for modification via protocol-based abstraction.
* Liskov Substitution:	Repository interfaces allow interchangeable implementations (e.g., MockUserRepository for tests).
* Interface Segregation:	Lightweight protocols ensure classes depend only on what they need.
* Dependency Inversion:	Higher-level modules depend on abstractions, not concrete implementations.

🧪 Unit Testing

* Uses RxTest and RxBlocking for reactive testing

* Mock Repositories in Mock/ layer simulate data responses

* Ensures ViewModels and UseCases work independently from real APIs

⚙️ Environment Configuration

- Environment variables are defined in the Configs/ folder using *.xcconfig.
- Switch between DEV and PRD modes easily.

🛠 Technologies Used

* Swift 5+

* RxSwift / RxCocoa

* XCTest / RxTest

* Clean Architecture

* SOLID Principles

📚 Learning Goals

This project aims to demonstrate:

* How to design reactive data flow using RxSwift

* How to apply SOLID in real-world Swift architecture

* How to achieve high testability through clean separation of dependencies

🧑‍💻 Author

Nguyen Khanh Toan
💼 iOS Developer | Passionate about Clean Architecture, RxSwift, and scalable design
