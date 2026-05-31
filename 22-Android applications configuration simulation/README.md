> Tested: May 2026

# Lab Object

To verify app management and protection for Android devices.

1. Configure Microsoft Edge for non-enrolled BYOD Android

# Test configure Edge for BYOD devices

## STEP 1 — Create app configuration policy

Go to:

Apps > Android > Configuration > Create > Managed Apps

For testing, set bookmarks:

image

## STEP 2 — Create app protection policy

Go to:

Apps > Android > Protection > Create > Android

Keep the default configuration for this test.
 
## STEP 3 — Verify the behavior on the phone

Prompted to set a PIN as shown below.

image

> App protection is applied.

Bookmarks apper as configured.

image 

> App configuration is applied.





# Config in common

Devices > Android > Configuration > New Policy > Android Enterprise > Templates > Device restrictions

Allow installation from unknown sources

Allow access to all apps in Google Play store (work profile-level)

What if a user access normal Android Store instead of Managed Google play 


------
Fully Managed Android

Usually:

managed Play Store replaces normal experience
OR
Play Store becomes restricted/allowlisted

So if user opens app page not approved:

install button missing
OR
install blocked
OR
app invisible entirely

depending on policy.

------





## STEP 1 — Add Android app

Go to:

Apps > Android > Create

Select:

Store app > Managed Google Play

and add Microsoft Edge.

## STEP 2 — Assign the app

Go to:

Apps > Android > Edge > Assignments > Add group

to target users/devices.

## STEP 3 — Create app configuration policy

Go to:

Apps > Android > Configuration > Create > Managed Apps

For testing, set bookmarks:

image

## STEP 3 — Create app protection policy

Go to:

Apps > Android > Protection > Create > Android

Keep the default configuration for this test.
 
## STEP 4 — Verify the behavior on the phone

Prompted to set a PIN as shown below.

image

> App protection is applied.

Bookmarks apper as configured.

image 

> App configuration is applied.
