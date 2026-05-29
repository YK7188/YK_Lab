> Tested: May 2026

# STEP 1 — Add Android app

Go to:

Apps > Android > Create

Select:

Store app > Managed Google Play

and add an app.

# STEP 2 — Assign the app

Go to:

Assignments > Add group

to target users/devices.


# STEP 3 — Create app configuration policy

Go to:

Apps > Android > Configuration > Create > Managed Devices

For testing, set this JSON.

```
{
  "kind": "androidenterprise#managedConfiguration",
  "productId": "app:com.microsoft.emmx",
  "managedProperty": [
    {
      "key": "HomepageLocation",
      "valueString": "https://www.microsoft.com"
    }
  ]
}
```

image

