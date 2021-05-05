//
//  GetPublicUserDataUdacity.swift
//  OnTheMap
//
//  Created by June2020 on 5/4/21.
//

import Foundation

struct PermissionsBase: Codable {
    var derivation: [String]
    var behavior: String
    var principalRef: [String:String]
    
    enum CodingKeys: String, CodingKey {
        case derivation
        case behavior
        case principalRef = "principal_ref"
    }
}
/*
struct Permissions: Codable {
    var permissions: [PermissionsBase]
    
    enum CodingKeys: String, CodingKey {
        case permissions
    }
}
*/
 

struct GuardBase: Codable {
    var canEdit: Bool
    var permissions: [PermissionsBase]
    var allowedBehaviors: [String]
    var subjectKind: String
    
    enum CodingKeys: String, CodingKey {
        
        case canEdit = "can_edit"
        case permissions
        case allowedBehaviors = "allowed_behaviors"
        case subjectKind = "subject_kind"
    }
}

struct EmailBase: Codable {
    var verificationCodeSent: Bool
    var verified: Bool
    var address: String
    
    enum CodingKeys: String, CodingKey {
        
        case verificationCodeSent = "_verification_code_sent"
        case verified = "_verified"
        case address
    }
}

struct MembershipsBase: Codable {
    var current: Bool
    var groupRef: [String:String]
    var creationTime: String
    var expirationTime: String
    
    enum CodingKeys: String, CodingKey {
        
        case current
        case groupRef = "group_ref"
        case creationTime = "creation_time"
        case expirationTime = "expiration_time"
    }
}

struct UserBase: Codable {
    var lastName: String
    var socialAccounts: [String]
    var mailingAddress: String
    var cohortKeys: [String]
    var signature: String
    var stripeCustomerId: String
    var guardy: GuardBase  // can't use keyword guard
    var facebookId: String
    var timezone: String
    var sitePreferences: String
    var occupation: String
    var image: String
    var firstName: String
    var jabberId: String
    var languages: String
    var badges: [String]
    var location: String
    var externalServicePassword: String
    var principals: [String]
    var enrollments: [String]
    var email: EmailBase
    var websiteUrl: String
    var externalAccounts: [String]
    var bio: String
    var coachingData: String
    var tags: [String]
    var affiliateProfiles: [String]
    var hasPassword: Bool
    var emailPreferences: [String:Bool]
    var resume: String
    var key: String
    var nickname: String
    var employerSharing: Bool
    var memberships: [MembershipsBase]
    var zendeskId: String
    var registered: Bool
    var linkedinUrl: String
    var googleId: String
    var imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case socialAccounts = "social_accounts"
        case mailingAddress = "mailing_address"
        case cohortKeys = "_cohort_keys"
        case signature = "_signature"
        case stripeCustomerId = "_stripe_customer_id"
        case guardy = "guard"
        case facebookId = "_facebook_id"
        case timezone
        case sitePreferences = "site_preferences"
        case occupation
        case image = "_image"
        case firstName = "first_name"
        case jabberId = "jabber_id"
        case languages
        case badges = "_badges"
        case location
        case externalServicePassword = "external_service_password"
        case principals = "_principals"
        case enrollments = "_enrollments"
        case email
        case websiteUrl = "website_url"
        case externalAccounts = "external_accounts"
        case bio
        case coachingData = "coaching_data"
        case tags
        case affiliateProfiles = "_affiliate_profiles"
        case hasPassword = "_has_password"
        case emailPreferences = "email_preferences"
        case resume = "_resume"
        case key
        case nickname
        case employerSharing = "employer_sharing"
        case memberships = "_memberships"
        case zendeskId = "zendesk_id"
        case registered = "_registered"
        case linkedinUrl = "linkedin_url"
        case googleId = "_google_id"
        case imageUrl = "_image_url"
    }
}

struct GetUserData: Codable {
    var user: UserBase
    
    enum CodingKeys: String, CodingKey {
        case user
        }
    }

