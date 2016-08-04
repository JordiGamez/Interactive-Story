//
//  InteractiveStory.swift
//  InteractiveStory
//
//  Created by Jordi Gamez on 4/8/16.
//  Copyright © 2016 Jordi Gamez. All rights reserved.
//

import Foundation
import UIKit

enum Story: String {
    case ReturnTrip
    case TouchDown
    case Homeward
    case Rover
    case Cave
    case Crate
    case Monster
    case Droid
    case Home
}

extension Story {
    var artwork: UIImage {
        return UIImage(named: self.rawValue)!
    }
    
    var text: String {
        switch self {
        case .ReturnTrip:
            return "On your return trip from studying Saturn's ring, you hear a distress signal that seems to be coming from the surface of Mars. It's strange because there hasn't been a colony there in years. \"Help me, you're my only hope.\""
            
        case .TouchDown:
            return "You deftly land your ship near where the distress signar originated. You didn't notice anything strange on your fly-by, behind you is an abandoned rover from the early 21st century and a smal crate."
        
        case .Homeward:
            return ""
            
        case .Rover:
            return ""
            
        case .Cave:
            return ""
            
        case .Crate:
            return ""
            
        case .Monster:
            return ""
            
        case .Droid:
            return ""
            
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
    static var story: Page {
        let returnTrip = Page(story: .ReturnTrip)
        let touchDown = returnTrip.addChoice("Stop and Investigate", story: .TouchDown)
        let homeward = returnTrip.addChoice("Continue Home to Earth", story: .Homeward)
        
        let rover = touchDown.addChoice("Explore the Rover", story: .Rover)
        let crate = touchDown.addChoice("Open the Crate", story: .Crate)
        
        homeward.addChoice("Head back to Mars", page: touchDown)
        let home = homeward.addChoice("Continue Home to Earth", story: .Home)
        
        let cave = rover.addChoice("Explore the Coordinates", story: .Cave)
        rover.addChoice("Return to Earth", page: home)

        cave.addChoice("Continue towards faint light", story: .Droid)
        cave.addChoice("Refill the ship and explore the rover", page: rover)
        
        crate.addChoice("Explore the Rover", page: rover)
        crate.addChoice("Use the key", story: .Monster)
        
        return returnTrip
    }
}