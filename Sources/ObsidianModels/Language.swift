import Foundation

public enum Language: String, CaseIterable, Sendable {
    case spanish = "es"
    case french = "fr"
    case german = "de"
    case italian = "it"
    case portuguese = "pt"
    case japanese = "ja"
    case korean = "ko"
    case chinese = "zh"
    case russian = "ru"
    case arabic = "ar"
    case hindi = "hi"
    case dutch = "nl"

    public var description: String {
        switch self {
        case .spanish: "Spanish (Español)"
        case .french: "French (Français)"
        case .german: "German (Deutsch)"
        case .italian: "Italian (Italiano)"
        case .portuguese: "Portuguese (Português)"
        case .japanese: "Japanese (日本語)"
        case .korean: "Korean (한국어)"
        case .chinese: "Chinese (中文)"
        case .russian: "Russian (Русский)"
        case .arabic: "Arabic (العربية)"
        case .hindi: "Hindi (हिन्दी)"
        case .dutch: "Dutch (Nederlands)"
        }
    }

    public var instructions: String {
        switch self {
        case .spanish:
            """
            - Use formal "usted" for professional content, "tú" for casual notes
            - Maintain proper Spanish punctuation (¿¡)
            - Use Latin American Spanish unless context suggests otherwise
            - Preserve technical terminology commonly used in Spanish tech communities
            - Use "computadora" for computer, "aplicación" for app
            """
        case .french:
            """
            - Use appropriate formal/informal register based on content context
            - Maintain proper French punctuation and spacing (« », etc.)
            - Use standard French unless context suggests Canadian French
            - Preserve technical terms that are commonly kept in English in French tech
            - Use "ordinateur" for computer, "logiciel" for software
            """
        case .german:
            """
            - Use appropriate formal (Sie) or informal (du) based on content context
            - Maintain proper German capitalization (nouns capitalized)
            - Use standard German orthography
            - Preserve technical terms commonly used in English in German tech communities
            - Use compound words appropriately (e.g., "Computerprogramm")
            """
        case .italian:
            """
            - Use appropriate formal (Lei) or informal (tu) based on content context
            - Maintain proper Italian punctuation and grammar
            - Use standard Italian unless context suggests regional variants
            - Preserve technical terms commonly kept in English in Italian tech
            - Use "computer" (borrowed) or "elaboratore" for computer
            """
        case .portuguese:
            """
            - Use Brazilian Portuguese specifically (NOT European Portuguese)
            - Use "tu" for second person
            - Use Brazilian vocabulary: "tela" (screen), "arquivo" (file), "pasta" (folder)
            - Maintain proper Brazilian punctuation and grammar
            - Preserve technical terms commonly used in English in Brazilian tech communities
            - Use proper verb conjugation; avoid excessive gerund forms (-ndo endings)
            """
        case .japanese:
            """
            - Use appropriate levels of politeness (keigo) based on content context
            - Maintain proper Japanese typography and spacing
            - Use common katakana for foreign technical terms (コンピュータ, ファイル)
            - Preserve programming terms that are typically kept in English
            - Use appropriate particles (は, が, を, に, で) correctly
            """
        case .korean:
            """
            - Use appropriate honorific levels based on content context
            - Maintain proper Korean punctuation and spacing
            - Use Hangul for Korean terms, preserve English for technical terms
            - Use proper Korean word order (SOV)
            - Include appropriate particles and honorifics
            """
        case .chinese:
            """
            - Use Simplified Chinese (简体中文) unless context suggests Traditional
            - Maintain proper Chinese punctuation (，。；：！？)
            - Preserve technical terms commonly kept in English
            - Use appropriate Chinese technical vocabulary
            - Maintain proper character spacing and formatting
            """
        case .russian:
            """
            - Use appropriate formal/informal register based on content context
            - Maintain proper Russian Cyrillic script
            - Use correct case system (nominative, accusative, etc.)
            - Preserve technical terms commonly used in English in Russian tech
            - Use proper Russian punctuation and grammar rules
            """
        case .arabic:
            """
            - Use Modern Standard Arabic for formal content
            - Ensure proper RTL (right-to-left) text direction consideration
            - Preserve technical terms commonly used in English
            - Maintain appropriate Arabic punctuation (،؛؟!)
            - Use proper Arabic grammar and sentence structure
            """
        case .hindi:
            """
            - Use standard Hindi (Devanagari script)
            - Maintain proper Hindi grammar and sentence structure
            - Preserve technical terms commonly used in English in Indian tech
            - Use appropriate honorifics based on content context
            - Include proper Hindi punctuation and formatting
            """
        case .dutch:
            """
            - Use standard Dutch (Nederlands)
            - Maintain proper Dutch grammar and word order
            - Use appropriate formal/informal register based on content context
            - Preserve technical terms commonly used in English in Dutch tech
            - Use proper Dutch punctuation and capitalization rules
            """
        }
    }
}
