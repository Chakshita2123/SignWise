import Foundation
import SwiftUI

// MARK: - Category
enum SignCategory: String, CaseIterable {
    case greetings = "Greetings"
    case emergency = "Emergency"
    case family    = "Family"
    case emotions  = "Emotions"
    case health    = "Health"

    var emoji: String {
        switch self {
        case .greetings: return "👋"
        case .emergency: return "🚨"
        case .family:    return "👨‍👩‍👧"
        case .emotions:  return "😊"
        case .health:    return "🏥"
        }
    }
}

// MARK: - Sign Model
struct Sign: Identifiable {
    let id = UUID()
    let word: String
    let category: SignCategory
    let handShape: String
    let movement: String
    let tip: String
    let imageName: String
}

// MARK: - Flashcard Model
struct FlashCard: Identifiable {
    let id = UUID()
    let symbol: String
    let type: FlashCardType
    let handShape: String
    let imageName: String
}

enum FlashCardType: String, CaseIterable {
    case alphabet = "Alphabet"
    case number   = "Number"
}

// MARK: - Image Helper
// This shows image if it exists, otherwise shows a placeholder
struct SignImage: View {
    let imageName: String
    let size: CGFloat

    var body: some View {
        if let uiImage = UIImage(named: imageName) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .cornerRadius(12)
        } else {
            // Placeholder when image not added yet
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.07))
                    .frame(width: size, height: size)
                VStack(spacing: 8) {
                    Text("✋")
                        .font(.system(size: size * 0.4))
                    Text("No Image")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.3))
                }
            }
        }
    }
}

// MARK: - All 55 Signs
let allSigns: [Sign] = [

    // GREETINGS (12)
    Sign(word: "Hello",        category: .greetings, handShape: "Open flat hand", movement: "Wave side to side near your face", tip: "Like a casual wave to a friend", imageName: "hello"),
    Sign(word: "Goodbye",      category: .greetings, handShape: "Open flat hand", movement: "Fold fingers down and up repeatedly", tip: "Like fingers waving bye", imageName: "goodbye"),
    Sign(word: "Thank You",    category: .greetings, handShape: "Flat open hand", movement: "Touch fingertips to chin, move forward", tip: "Like blowing a kiss of gratitude", imageName: "thank_you"),
    Sign(word: "Please",       category: .greetings, handShape: "Flat open hand", movement: "Rub hand in circular motion on chest", tip: "Rubbing your heart when asking nicely", imageName: "please"),
    Sign(word: "Sorry",        category: .greetings, handShape: "Fist hand", movement: "Rotate fist in circular motion on chest", tip: "Rubbing away the mistake from your heart", imageName: "sorry"),
    Sign(word: "Yes",          category: .greetings, handShape: "Fist hand", movement: "Nod fist up and down", tip: "Your hand is nodding yes", imageName: "yes"),
    Sign(word: "No",           category: .greetings, handShape: "Index + middle finger extended", movement: "Tap fingers to thumb twice", tip: "Like a finger wagging no", imageName: "no"),
    Sign(word: "Welcome",      category: .greetings, handShape: "Flat open hand", movement: "Sweep hand inward toward body", tip: "Gesturing someone to come in", imageName: "welcome"),
    Sign(word: "How Are You",  category: .greetings, handShape: "Both bent hands", movement: "Rotate outward from chest", tip: "Opening up to ask how someone feels", imageName: "how_are_you"),
    Sign(word: "Good Morning", category: .greetings, handShape: "Flat open hand", movement: "Arc from below chin upward", tip: "Sun rising in the morning", imageName: "good_morning"),
    Sign(word: "Good Night",   category: .greetings, handShape: "Bent hand over other arm", movement: "Lower hand like sun setting", tip: "Sun going down at night", imageName: "good_night"),
    Sign(word: "My Name Is",   category: .greetings, handShape: "H-shape both hands", movement: "Tap fingers together twice", tip: "Two fingers meeting — introducing yourself", imageName: "my_name_is"),

    // EMERGENCY (10)
    Sign(word: "Help",         category: .emergency, handShape: "Fist on flat palm", movement: "Lift both hands upward together", tip: "Like lifting someone up for help", imageName: "help"),
    Sign(word: "Stop",         category: .emergency, handShape: "Flat hand", movement: "Bring hand down sharply onto open palm", tip: "Like chopping a stop signal", imageName: "stop"),
    Sign(word: "Danger",       category: .emergency, handShape: "Both fists", movement: "Right fist brushes up over left fist", tip: "Warning motion — alert and sharp", imageName: "danger"),
    Sign(word: "Fire",         category: .emergency, handShape: "Both hands fingers wiggling", movement: "Move hands upward like flames", tip: "Fingers flicker like actual fire", imageName: "fire"),
    Sign(word: "Police",       category: .emergency, handShape: "C-shape hand", movement: "Tap on chest where badge would be", tip: "Tapping where a badge would be", imageName: "police"),
    Sign(word: "Ambulance",    category: .emergency, handShape: "Fist hand", movement: "Rotate fist in circles near shoulder", tip: "Mimicking a spinning siren light", imageName: "ambulance"),
    Sign(word: "Hospital",     category: .emergency, handShape: "H-shape hand", movement: "Draw H shape on upper arm", tip: "The letter H drawn on your arm", imageName: "hospital"),
    Sign(word: "Hurt",         category: .emergency, handShape: "Both index fingers pointing", movement: "Twist toward each other", tip: "Two tension points meeting", imageName: "hurt"),
    Sign(word: "Call",         category: .emergency, handShape: "Thumb + pinky out", movement: "Hold to ear like a phone", tip: "Classic phone gesture", imageName: "call"),
    Sign(word: "Emergency",    category: .emergency, handShape: "E-shape hand", movement: "Shake hand side to side urgently", tip: "Urgent shaking motion", imageName: "emergency"),

    // FAMILY (10)
    Sign(word: "Mother",       category: .family, handShape: "Open 5-hand", movement: "Tap thumb on chin twice", tip: "Female signs are near the chin", imageName: "mother"),
    Sign(word: "Father",       category: .family, handShape: "Open 5-hand", movement: "Tap thumb on forehead twice", tip: "Male signs are near the forehead", imageName: "father"),
    Sign(word: "Brother",      category: .family, handShape: "L-shape hand", movement: "Touch forehead then bring hands together", tip: "Combine male + same person", imageName: "brother"),
    Sign(word: "Sister",       category: .family, handShape: "L-shape hand", movement: "Brush jaw then bring hands together", tip: "Combine female + same person", imageName: "sister"),
    Sign(word: "Baby",         category: .family, handShape: "Both arms crossed", movement: "Rock arms side to side like cradle", tip: "Cradling a baby in your arms", imageName: "baby"),
    Sign(word: "Family",       category: .family, handShape: "Both F-shape hands", movement: "Circle outward then meet again", tip: "Circle that comes back together", imageName: "family"),
    Sign(word: "Friend",       category: .family, handShape: "Both index fingers hooked", movement: "Hook together then swap positions", tip: "Two people linked together", imageName: "friend"),
    Sign(word: "Home",         category: .family, handShape: "Flat O-shape", movement: "Touch to mouth then to cheek", tip: "Where you eat and sleep", imageName: "home"),
    Sign(word: "Grandfather",  category: .family, handShape: "Open 5-hand", movement: "Two arcing hops forward from forehead", tip: "Father but one generation forward", imageName: "grandfather"),
    Sign(word: "Grandmother",  category: .family, handShape: "Open 5-hand", movement: "Two arcing hops forward from chin", tip: "Mother but one generation forward", imageName: "grandmother"),

    // EMOTIONS (12)
    Sign(word: "Happy",        category: .emotions, handShape: "Flat open hand", movement: "Brush chest upward twice", tip: "Joy bubbling up from your chest", imageName: "happy"),
    Sign(word: "Sad",          category: .emotions, handShape: "Both open hands near face", movement: "Slowly pull both hands downward", tip: "Sadness pulling your face down", imageName: "sad"),
    Sign(word: "Angry",        category: .emotions, handShape: "Bent claw hand", movement: "Pull hand away from face sharply", tip: "Pulling anger out from inside", imageName: "angry"),
    Sign(word: "Love",         category: .emotions, handShape: "Both arms crossed", movement: "Hug crossed arms against chest", tip: "Hugging the feeling of love", imageName: "love"),
    Sign(word: "Scared",       category: .emotions, handShape: "Both fists at chest", movement: "Open both hands quickly outward", tip: "Heart jumping in shock", imageName: "scared"),
    Sign(word: "Tired",        category: .emotions, handShape: "Both bent hands at chest", movement: "Drop and rotate downward", tip: "Energy drooping and falling", imageName: "tired"),
    Sign(word: "Excited",      category: .emotions, handShape: "Both open hands", movement: "Brush outward on chest alternately", tip: "Energy bouncing around inside", imageName: "excited"),
    Sign(word: "Confused",     category: .emotions, handShape: "Index finger pointing to head", movement: "Circular motion near temple", tip: "Things spinning in your head", imageName: "confused"),
    Sign(word: "Surprised",    category: .emotions, handShape: "Both index fingers at cheeks", movement: "Flick outward from cheeks", tip: "Eyes wide open in surprise", imageName: "surprised"),
    Sign(word: "Proud",        category: .emotions, handShape: "Thumb up", movement: "Move thumb upward along chest", tip: "Pride rising through your core", imageName: "proud"),
    Sign(word: "Embarrassed",  category: .emotions, handShape: "Both open hands near face", movement: "Alternating upward brushing on cheeks", tip: "Blushing cheeks", imageName: "embarrassed"),
    Sign(word: "Worried",      category: .emotions, handShape: "Both open hands", movement: "Alternate downward circles in front of face", tip: "Thoughts circling with worry", imageName: "worried"),

    // HEALTH (11)
    Sign(word: "Doctor",       category: .health, handShape: "M-shape hand", movement: "Tap fingers on wrist like checking pulse", tip: "Checking pulse like a doctor", imageName: "doctor"),
    Sign(word: "Medicine",     category: .health, handShape: "Middle finger extended", movement: "Stir middle finger in open palm", tip: "Stirring medicine in your palm", imageName: "medicine"),
    Sign(word: "Pain",         category: .health, handShape: "Both index fingers", movement: "Twist toward each other", tip: "Two tension points meeting", imageName: "pain"),
    Sign(word: "Water",        category: .health, handShape: "W-shape hand", movement: "Tap index finger on chin twice", tip: "W for water tapped on chin", imageName: "water"),
    Sign(word: "Eat",          category: .health, handShape: "Flat O-shape", movement: "Tap fingertips to mouth repeatedly", tip: "Bringing food to mouth", imageName: "eat"),
    Sign(word: "Sleep",        category: .health, handShape: "Open hand near face", movement: "Close hand as it moves down, tilt head", tip: "Eyes closing as you fall asleep", imageName: "sleep"),
    Sign(word: "Sick",         category: .health, handShape: "Middle fingers bent", movement: "Touch middle finger to forehead + stomach", tip: "Head and stomach feeling ill", imageName: "sick"),
    Sign(word: "Better",       category: .health, handShape: "Flat hand at mouth", movement: "Move hand outward and upward", tip: "Good feeling moving outward and up", imageName: "better"),
    Sign(word: "Fever",        category: .health, handShape: "Bent index finger", movement: "Slide finger across forehead", tip: "Checking temperature on forehead", imageName: "fever"),
    Sign(word: "Allergy",      category: .health, handShape: "Index finger on nose", movement: "Pull down then flick index finger", tip: "Nose reaction to allergen", imageName: "allergy"),
    Sign(word: "Breathe",      category: .health, handShape: "Both open hands on chest", movement: "Rise and fall with breathing motion", tip: "Hands moving with your breath", imageName: "breathe"),
]

// MARK: - Alphabet Flashcards A-Z
let alphabetCards: [FlashCard] = [
    FlashCard(symbol: "A", type: .alphabet, handShape: "Fist with thumb to side", imageName: "asl_a"),
    FlashCard(symbol: "B", type: .alphabet, handShape: "Flat hand, fingers together, thumb tucked", imageName: "asl_b"),
    FlashCard(symbol: "C", type: .alphabet, handShape: "Curved hand like letter C", imageName: "asl_c"),
    FlashCard(symbol: "D", type: .alphabet, handShape: "Index up, others curl to touch thumb", imageName: "asl_d"),
    FlashCard(symbol: "E", type: .alphabet, handShape: "All fingers bent, thumb tucked under", imageName: "asl_e"),
    FlashCard(symbol: "F", type: .alphabet, handShape: "Index + thumb touch, others up", imageName: "asl_f"),
    FlashCard(symbol: "G", type: .alphabet, handShape: "Index + thumb point sideways", imageName: "asl_g"),
    FlashCard(symbol: "H", type: .alphabet, handShape: "Index + middle point sideways together", imageName: "asl_h"),
    FlashCard(symbol: "I", type: .alphabet, handShape: "Pinky finger up, others folded", imageName: "asl_i"),
    FlashCard(symbol: "J", type: .alphabet, handShape: "Pinky up, draw J in air", imageName: "asl_j"),
    FlashCard(symbol: "K", type: .alphabet, handShape: "Index up, middle angled, thumb between", imageName: "asl_k"),
    FlashCard(symbol: "L", type: .alphabet, handShape: "Index up, thumb out — L shape", imageName: "asl_l"),
    FlashCard(symbol: "M", type: .alphabet, handShape: "Three fingers folded over thumb", imageName: "asl_m"),
    FlashCard(symbol: "N", type: .alphabet, handShape: "Two fingers folded over thumb", imageName: "asl_n"),
    FlashCard(symbol: "O", type: .alphabet, handShape: "All fingers curve to touch thumb", imageName: "asl_o"),
    FlashCard(symbol: "P", type: .alphabet, handShape: "Like K but pointing downward", imageName: "asl_p"),
    FlashCard(symbol: "Q", type: .alphabet, handShape: "Like G but pointing downward", imageName: "asl_q"),
    FlashCard(symbol: "R", type: .alphabet, handShape: "Index + middle crossed", imageName: "asl_r"),
    FlashCard(symbol: "S", type: .alphabet, handShape: "Fist with thumb over fingers", imageName: "asl_s"),
    FlashCard(symbol: "T", type: .alphabet, handShape: "Thumb between index and middle", imageName: "asl_t"),
    FlashCard(symbol: "U", type: .alphabet, handShape: "Index + middle up together", imageName: "asl_u"),
    FlashCard(symbol: "V", type: .alphabet, handShape: "Index + middle up in V shape", imageName: "asl_v"),
    FlashCard(symbol: "W", type: .alphabet, handShape: "Index + middle + ring up", imageName: "asl_w"),
    FlashCard(symbol: "X", type: .alphabet, handShape: "Index finger hooked/bent", imageName: "asl_x"),
    FlashCard(symbol: "Y", type: .alphabet, handShape: "Thumb + pinky out", imageName: "asl_y"),
    FlashCard(symbol: "Z", type: .alphabet, handShape: "Index draws Z in air", imageName: "asl_z"),
]

// MARK: - Number Flashcards 0-9
let numberCards: [FlashCard] = [
    FlashCard(symbol: "0", type: .number, handShape: "All fingers curve to touch thumb — O shape", imageName: "num_0"),
    FlashCard(symbol: "1", type: .number, handShape: "Index finger up, others folded", imageName: "num_1"),
    FlashCard(symbol: "2", type: .number, handShape: "Index + middle up, palm out", imageName: "num_2"),
    FlashCard(symbol: "3", type: .number, handShape: "Thumb + index + middle up", imageName: "num_3"),
    FlashCard(symbol: "4", type: .number, handShape: "Four fingers up, thumb folded", imageName: "num_4"),
    FlashCard(symbol: "5", type: .number, handShape: "All five fingers spread open", imageName: "num_5"),
    FlashCard(symbol: "6", type: .number, handShape: "Thumb + pinky extended", imageName: "num_6"),
    FlashCard(symbol: "7", type: .number, handShape: "Thumb + index + middle + ring up", imageName: "num_7"),
    FlashCard(symbol: "8", type: .number, handShape: "Thumb + index + middle + ring + pinky", imageName: "num_8"),
    FlashCard(symbol: "9", type: .number, handShape: "Index + thumb touch, others up", imageName: "num_9"),
]