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

Image

# Important Finding Before Testing

Before setting:

Migration Complete

behavior appeared inconsistent and partially followed legacy MFA behavior.

After changing the migration status to:

Migration Complete

Authentication Methods Policy behavior became more aligned with the configured settings.

# Authentication Methods Policy

This determine available authentication methods tenant-wide.

image

When a method is enabled, it appears as an available method when a user:

- Encounters a prompt to register an MFA method (Let's keep your account secure) as shown below if no method has been registered yet.

     image phone and authenticator

- Adds an MFA method in the Mysignins page (https://mysignins.microsoft.com/security-info) as below.

# MFA Registration Policy

image

When enabled, a target user with no MFA method registered will experience a Let's keep your account secure prompt to register an MFA method when signing in to Office cloud apps such as office.com.

image

### Key Point

- During the test, regardless of wether the policy is enabled, test users with no MFA method registered were prompted for the registration when signing in to portal.azure.com, intune.microsoft.com.
- Once any MFA method is registered, a user can sign in to Office cloud apps with no second factor authentication prompted. This policy alone is not meant for enforcing MFA.

# Registration Campaign

image 

When enabled, a target user is prompted to add Microsoft Authenticator as an improved MFA method as shown below.

image 

This prompt only appears when the user has at least one another method registered.

### Key Point

- Like MFA registration policy, this alone does not enforce MFA.

### Conditional Access

Conditional access was configured for testing.

Target resources:

All resources (formerly 'All cloud apps')

Access controlls:

- Grant access
- Require multifactor authentication
  
When this policy is enabled:

- A user with no MFA method registered is prompted to register a method just like MFA registration policy.
- A user with any MFA method registered is prompted for the secondary authentication.


# Final Note

The test confirms that Conditional access is the only way to enforce MFA and, Registration policy and Registration Campaign support the structure.

Also, important to note that some sites such as portal.azure.com and intune.microsoft.com act like MFA-enforced.
