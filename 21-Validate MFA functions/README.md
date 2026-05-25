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

Image

# 

