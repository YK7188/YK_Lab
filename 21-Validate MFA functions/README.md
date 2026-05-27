> Tested: May 2026

# Lab Goal

Understand the practical relationship between:

- Authentication Methods Policy
- MFA Registration Policy
- Registration Campaign
- Conditional Access

in modern Microsoft Entra ID MFA onboarding and enforcement.

# Environment
- Microsoft 365 Developer tenant
- Legacy per-user MFA disabled
- Authentication Methods migration status set to:

Migration Complete

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/21-MFA%20function/01.Migration_ToModern.jpg" width="700">

# Important Finding Before Testing

Before setting:

Migration Complete

behavior appeared inconsistent and partially followed legacy MFA behavior.

After changing the migration status to:

Migration Complete

Authentication Methods Policy behavior became more aligned with the configured settings.

# Authentication Methods Policy

This determines which authentication methods are available tenant-wide.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/21-MFA%20function/11.Auth_Method.jpg" width="600">

When a method is enabled, it appears as an available method when a user with no MFA method registered:

- Encounters a prompt to register an MFA method (Let's keep your account secure) > add a sign-in method as shown below.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/21-MFA%20function/13.MFA_add_Prompt.jpg" width="400">

- Adds an MFA method in the Mysignins page (https://mysignins.microsoft.com/security-info) as below.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/21-MFA%20function/12.mysignins.jpg" width="600">

# MFA Registration Policy

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/21-MFA%20function/14.reg_policy.jpg" width="700">

When enabled, a target user with no MFA method registered will experience a Let's keep your account secure prompt to register an MFA method when signing in to Office cloud apps such as office.com.

### Key Point

- During the test, regardless of whether the policy is enabled, test users with no MFA method registered were prompted to register an MFA method when signing in to portal.azure.com, intune.microsoft.com.
- Once any MFA method is registered, a user can sign in to Office cloud apps with no second factor authentication prompted. This policy alone is not meant for enforcing MFA.

# Registration Campaign

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/21-MFA%20function/17.registration_campaign.jpg" width="600">

When enabled, a target user is prompted to add Microsoft Authenticator as an improved MFA method as shown below.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/21-MFA%20function/16.improve_your_signins.jpg" width="400"> 

This prompt only appears when the user has at least one other MFA method registered.

### Key Point

- Like MFA registration policy, this alone does not enforce MFA.

# Conditional Access

Conditional access was configured for testing.

Target resources:

- All resources (formerly 'All cloud apps')

Access controls:

- Grant access
- Require multifactor authentication

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/21-MFA%20function/17.CA_Grant.jpg" width="300"> 
  
When this policy is enabled:

- A user with no MFA method registered is prompted to register a method just like MFA registration policy.
- A user with any MFA method registered is prompted for the secondary authentication.

# Final Note

The test confirmed that Conditional Access was the primary and most predictable method for enforcing MFA during sign-in, while MFA Registration Policy and Registration Campaign supported the onboarding process.

During testing, portal.azure.com and intune.microsoft.com consistently triggered MFA-related registration behavior even without a tenant Conditional Access policy or registration policy configured.

Additionally, TAP, Email OTP, and QR Code did not function as primary workforce MFA onboarding methods even when enabled in Authentication Methods Policy.

### Realistic MFA configuration example:

1. Conditional access

- Target resources: All resources (formerly 'All cloud apps')
- Access controls:
  - Grant access
  - Require multifactor authentication

2. Authentication Methods

- Primary: Microsoft Authenticator
- Secondary: SMS or voice call

Registration Campaign and MFA Registration Policy are optional.
