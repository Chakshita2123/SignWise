//
//  File.swift
//  SignWise
//
//  Created by Student on 25/02/26.
//

import Foundation

// Categories
enum SignCategory: String, CaseIterable {
    case greetings = "Greetings"
    case numbers   = "Numbers"
    case emergency = "Emergency"
    case family    = "Family"
    case emotions  = "Emotions"
    case health    = "Health"
    
    var emoji: String {
        switch self {
        case .greetings: return "👋"
        case .numbers:   return "🔢"
        case .emergency: return "🚨"
        case .family:    return "👨‍👩‍👧"
        case .emotions:  return "😊"
        case .health:    return "🏥"
        }
    }
}

// Sign Model
struct Sign: Identifiable {
    let id = UUID()
    let word: String
    let category: SignCategory
    let handShape: String
    let movement: String
    let tip: String
}

// All 50 Signs
let allSigns: [Sign] = [

    // GREETINGS
    Sign(word: "Hello",     category: .greetings, handShape: "Open flat hand", movement: "Wave side to side near your face", tip: "Like a casual wave to a friend"),
    Sign(word: "Thank You", category: .greetings, handShape: "Flat open hand", movement: "Touch fingertips to chin, move hand forward", tip: "Like blowing a kiss of gratitude"),
    Sign(word: "Please",    category: .greetings, handShape: "Flat open hand", movement: "Rub hand in circular motion on chest", tip: "Rubbing your heart when asking nicely"),
    Sign(word: "Sorry",     category: .greetings, handShape: "Fist hand", movement: "Rotate fist in circular motion on chest", tip: "Rubbing away the mistake from your heart"),
    Sign(word: "Yes",       category: .greetings, handShape: "Fist hand", movement: "Nod fist up and down", tip: "Your hand is nodding yes"),
    Sign(word: "No",        category: .greetings, handShape: "Index + middle finger extended", movement: "Tap fingers to thumb twice", tip: "Like a finger wagging no"),
    Sign(word: "Goodbye",   category: .greetings, handShape: "Open flat hand", movement: "Fold fingers down and up repeatedly", tip: "Like fingers waving bye"),
    Sign(word: "Welcome",   category: .greetings, handShape: "Flat open hand", movement: "Sweep hand inward toward your body", tip: "Gesturing someone to come in"),

    // NUMBERS
    Sign(word: "One",   category: .numbers, handShape: "Index finger up", movement: "Hold still, palm facing out", tip: "Just your pointer finger up"),
    Sign(word: "Two",   category: .numbers, handShape: "Index + middle finger up", movement: "Hold still, palm facing out", tip: "Peace sign facing forward"),
    Sign(word: "Three", category: .numbers, handShape: "Thumb + index + middle up", movement: "Hold still", tip: "Three fingers up like counting"),
    Sign(word: "Four",  category: .numbers, handShape: "Four fingers up, thumb folded", movement: "Hold still", tip: "All fingers except thumb"),
    Sign(word: "Five",  category: .numbers, handShape: "All five fingers spread open", movement: "Hold still", tip: "Open palm, all fingers spread"),
    Sign(word: "Six",   category: .numbers, handShape: "Thumb + pinky extended", movement: "Hold still, palm facing out", tip: "Like a phone call gesture"),
    Sign(word: "Seven", category: .numbers, handShape: "Thumb + index + middle + ring up", movement: "Hold still", tip: "Four fingers + thumb"),
    Sign(word: "Ten",   category: .numbers, handShape: "Thumb up, fist closed", movement: "Shake wrist slightly", tip: "Thumbs up with a little wiggle"),

    // EMERGENCY
    Sign(word: "Help",      category: .emergency, handShape: "Fist on flat palm", movement: "Lift both hands upward together", tip: "Like lifting someone up for help"),
    Sign(word: "Danger",    category: .emergency, handShape: "Both fists", movement: "Right fist brushes up over left fist", tip: "Warning motion — alert and sharp"),
    Sign(word: "Stop",      category: .emergency, handShape: "Flat hand", movement: "Bring hand down sharply onto open palm", tip: "Like chopping a stop signal"),
    Sign(word: "Fire",      category: .emergency, handShape: "Both hands, fingers wiggling", movement: "Move hands upward like flames", tip: "Fingers flicker like actual fire"),
    Sign(word: "Ambulance", category: .emergency, handShape: "Fist hand", movement: "Rotate fist in circles near shoulder", tip: "Mimicking a spinning siren light"),
    Sign(word: "Police",    category: .emergency, handShape: "C-shape hand", movement: "Tap on chest where badge would be", tip: "Tapping where a badge would be"),
    Sign(word: "Hurt",      category: .emergency, handShape: "Both index fingers pointing", movement: "Twist toward each other near pain area", tip: "Two fingers twisting like pain"),
    Sign(word: "Call 911",  category: .emergency, handShape: "Thumb + pinky out", movement: "Hold to ear, then point outward", tip: "Phone gesture + urgent point"),

    // FAMILY
    Sign(word: "Mother",  category: .family, handShape: "Open 5-hand", movement: "Tap thumb on chin twice", tip: "Female signs are near the chin"),
    Sign(word: "Father",  category: .family, handShape: "Open 5-hand", movement: "Tap thumb on forehead twice", tip: "Male signs are near the forehead"),
    Sign(word: "Sister",  category: .family, handShape: "L-shape hand", movement: "Brush jaw then bring hands together", tip: "Combine female + same person"),
    Sign(word: "Brother", category: .family, handShape: "L-shape hand", movement: "Touch forehead then bring hands together", tip: "Combine male + same person"),
    Sign(word: "Baby",    category: .family, handShape: "Both arms crossed", movement: "Rock arms side to side like a cradle", tip: "Cradling a baby in your arms"),
    Sign(word: "Family",  category: .family, handShape: "Both F-shape hands", movement: "Circle outward then meet again", tip: "Circle that comes back together"),
    Sign(word: "Friend",  category: .family, handShape: "Both index fingers hooked", movement: "Hook together then swap positions", tip: "Two people linked together"),
    Sign(word: "Home",    category: .family, handShape: "Flat O-shape", movement: "Touch to mouth then to cheek", tip: "Where you eat and sleep"),

    // EMOTIONS
    Sign(word: "Happy",    category: .emotions, handShape: "Flat open hand", movement: "Brush chest upward twice", tip: "Joy bubbling up from your chest"),
    Sign(word: "Sad",      category: .emotions, handShape: "Both open hands near face", movement: "Slowly pull both hands downward", tip: "Sadness pulling your face down"),
    Sign(word: "Angry",    category: .emotions, handShape: "Bent claw hand", movement: "Pull hand away from face sharply", tip: "Pulling anger out from inside"),
    Sign(word: "Scared",   category: .emotions, handShape: "Both fists at chest", movement: "Open both hands quickly outward", tip: "Heart jumping in shock"),
    Sign(word: "Love",     category: .emotions, handShape: "Both arms crossed", movement: "Hug crossed arms against chest", tip: "Hugging the feeling of love"),
    Sign(word: "Tired",    category: .emotions, handShape: "Both bent hands at chest", movement: "Drop and rotate downward", tip: "Energy drooping and falling"),
    Sign(word: "Excited",  category: .emotions, handShape: "Both open hands", movement: "Brush outward on chest alternately", tip: "Energy bouncing around inside"),
    Sign(word: "Confused", category: .emotions, handShape: "Index finger pointing to head", movement: "Circular motion near temple", tip: "Things spinning in your head"),
    Sign(word: "Proud",    category: .emotions, handShape: "Thumb up", movement: "Move thumb upward along chest", tip: "Pride rising through your core"),

    // HEALTH
    Sign(word: "Doctor",   category: .health, handShape: "M-shape hand", movement: "Tap fingers on wrist like checking pulse", tip: "Checking pulse like a doctor"),
    Sign(word: "Medicine", category: .health, handShape: "Middle finger extended", movement: "Stir middle finger in open palm", tip: "Stirring medicine in your palm"),
    Sign(word: "Hospital", category: .health, handShape: "H-shape hand", movement: "Draw H shape on upper arm", tip: "The letter H drawn on your arm"),
    Sign(word: "Pain",     category: .health, handShape: "Both index fingers", movement: "Twist toward each other", tip: "Two tension points meeting"),
    Sign(word: "Water",    category: .health, handShape: "W-shape hand", movement: "Tap index finger on chin twice", tip: "W for water tapped on chin"),
    Sign(word: "Eat",      category: .health, handShape: "Flat O-shape", movement: "Tap fingertips to mouth repeatedly", tip: "Bringing food to mouth"),
    Sign(word: "Sleep",    category: .health, handShape: "Open hand near face", movement: "Close hand as it moves down, tilt head", tip: "Eyes closing as you fall asleep"),
    Sign(word: "Sick",     category: .health, handShape: "Middle fingers bent", movement: "Touch middle finger to forehead + stomach", tip: "Head and stomach feeling ill"),
    Sign(word: "Better",   category: .health, handShape: "Flat hand at mouth", movement: "Move hand outward and upward", tip: "Good feeling moving outward and up"),
]
