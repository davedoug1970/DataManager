
## DataManager

DataManager is a generics based set of protocols and classes that allow you to use an entity class/struct that you have created and store data in a json or plist file.  I am always open to suggestions on how I can improve it.

## Problem Statement

Need to be able to read and write to either json or plist files.  Want to be able to easily swap between file type.  Would like the code to be reusable so I do not have to write a lot of boilerplate code to store entities in json or plist files.

Swift Protocols used:
- Codable
- Identifiable
- Hashable
    
Swift built in classes used:
- JSONDecoder
- JSONEncoder
- JSONSerialization
- PropertyListSerialization
- PropertyListEncoder
- Bundle
- FileManager
 
## Diagram
    
<p align="center">
    <img src="diagram.png" alt="diagram" />
</p>

## Example Data Provider Implementations

In addtion to the DataManager, which store objects as JSON or Plists, I have added several different implementations for various other data providers.

Data Providers Implemented:
- API 
- CoreData
- Realm
