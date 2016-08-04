//
//  InteractiveStory.swift
//  InteractiveStory
//
//  Created by Jordi Gamez on 4/8/16.
//  Copyright © 2016 Jordi Gamez. All rights reserved.
//

import Foundation
import UIKit

enum Story {
    case ReturnTrip(String)
    case TouchDown
    case Homeward
    case Rover(String)
    case Cave
    case Crate
    case Monster
    case Droid(String)
    case Home
    
    var rawValue: String {
        switch self {
            case .ReturnTrip: return "ReturnTrip"
            case .TouchDown: return "TouchDown"
            case .Homeward: return "Homeward"
            case .Rover: return "Rover"
            case .Cave: return "Cave"
            case .Crate: return "Crate"
            case .Monster: return "Monster"
            case .Droid: return "Droid"
            case .Home: return "Home"
        }
    }
}

extension Story {
    var artwork: UIImage {
        return UIImage(named: self.rawValue)!
    }
    
    var text: String {
        switch self {
        case .ReturnTrip(let name):
            return "On your return trip from studying Saturn's ring, you hear a distress signal that seems to be coming from the surface of Mars. It's strange because there hasn't been a colony there in years. \"Help me \(name), you're my only hope.\""
            
        case .TouchDown:
            return "You deftly land your ship near where the distress signar originated. You didn't notice anything strange on your fly-by, behind you is an abandoned rover from the early 21st century and a smal crate."
        
        case .Homeward:
            return ""
            
        case .Rover(let name):
            return "The rover is covered in dust and most of the solar panels are broken. But you are quite surprised to see the on-board system booted up and running. In fact, there is a message on the screen. \"\(name), to 28.2342, -81.08273\". These coordinates aren't far but you don't know if your oxygen will last there and back."
            
        case .Cave:
            return ""
            
        case .Crate:
            return ""
            
        case .Monster:
            return ""
            
        case .Droid(let name):
            return "After a long walk slightly uphill, you end up at the top of a small crater. You look around and are overjoyed to see your robot friend, \(name)-S1124. It had been lost on a previus mission to Mars. You take it back to your ship and fly back to Earth."
            
        case .Home:
            return ""
        }
    }
}

class Page {
    let story: Story
    
    typealias Choice = (title: String, page: Page)
    
    var firstChoice: Choice?
    var secondChoice: Choice?
    
    init(story: Story) {
        self.story = story
    }
}

extension Page {
    func addChoice(title: String, page: Page) -> Page {
        switch (firstChoice, secondChoice) {
            case (.Some, .Some): break
            case (.None, .None), (.None, .Some): firstChoice = (title, page)
            case (.Some, .None): secondChoice = (title, page)
        }
        return page
    }
    
    func addChoice(title: String, story: Story) -> Page {
        let page = Page(story: story)
        return addChoice(title, page: page)
    }
}

struct Adventure {
    static func story(name: String) -> Page {
        let returnTrip = Page(story: .ReturnTrip(name))
        let touchDown = returnTrip.addChoice("Stop and Investigate", story: .TouchDown)
        let homeward = returnTrip.addChoice("Continue Home to Earth", story: .Homeward)
        
        let rover = touchDown.addChoice("Explore the Rover", story: .Rover(name))
        let crate = touchDown.addChoice("Open the Crate", story: .Crate)
        
        homeward.addChoice("Head back to Mars", page: touchDown)
        let home = homeward.addChoice("Continue Home to Earth", story: .Home)
        
        let cave = rover.addChoice("Explore the Coordinates", story: .Cave)
        rover.addChoice("Return to Earth", page: home)

        cave.addChoice("Continue towards faint light", story: .Droid(name))
        cave.addChoice("Refill the ship and explore the rover", page: rover)
        
        crate.addChoice("Explore the Rover", page: rover)
        crate.addChoice("Use the key", story: .Monster)
        
        return returnTrip
    }
}