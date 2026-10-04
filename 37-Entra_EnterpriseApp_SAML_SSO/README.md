> Labbed: Oct 2026

# Scenario

A new application needs to be integrated with Microsoft Entra ID using **SAML-based Single Sign-On (SSO)** so that employees can authenticate to the application using their corporate Entra identities.

This lab uses **Microsoft Entra SAML Toolkit** as the Service Provider (SP) to simulate a third-party application and configure SAML-based SSO with Microsoft Entra ID.

---

# Part 1 - Add Microsoft Entra SAML Toolkit to Microsoft Entra ID

Navigate to:

**Microsoft Entra admin center > Entra ID > Enterprise apps > New application**

Search for:

**Microsoft Entra SAML Toolkit**

Select the application and click **Create**.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/37-Entra_EnterpriseApp_SAML_SSO/01.png" width="800">

The app now appears in Enterprise applications and is ready for SAML SSO configuration.

---

# Part 2 - Assign a Test User

Assign a test user in

**Enterprise apps > Microsoft Entra SAML Toolkit > Users and groups**

---

# Part 3 - Configure the Service Provider

### 1. Download the SAML signing certificate

On the Entra **Single sign-on** page, locate:

**SAML Certificates**

Download:

**Certificate (Raw)**

> The Service Provider uses this certificate to validate SAML responses signed by Microsoft Entra ID.

### 2. Record Entra configuration

From the same SAML configuration page, record:

- **Login URL**
- **Microsoft Entra Identifier**
- **Logout URL**

These values describe the Entra Identity Provider configuration.

### 3. Configure Microsoft Entra SAML Toolkit

Open:

https://samltoolkit.azurewebsites.net/

Register/sign in to the SAML Toolkit.

Open:

**SAML Configuration**

Create a SAML configuration using the values obtained from Entra:

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/37-Entra_EnterpriseApp_SAML_SSO/05.png" width="600">

The Service Provider is now configured to trust SAML assertions issued by Microsoft Entra ID.

---

# Part 4 - Complete and Test SSO

### 1. Update the Entra configuration

The SAML Toolkit provides Service Provider values including:

- SP Initiated Login URL
- Identifier / Entity ID
- Assertion Consumer Service (ACS) URL

Return to:

**Enterprise apps > Microsoft Entra SAML Toolkit > Single sign-on > Basic SAML Configuration**

Update the Entra configuration using the values below supplied by the Service Provider.

<br>
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/37-Entra_EnterpriseApp_SAML_SSO/06.png" width="800">

### 2. Test SSO

For a test, initiate authentication from the SAML Toolkit.

The assigned test user signs in successfully, while a user without an application assignment is denied access as shown below.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/37-Entra_EnterpriseApp_SAML_SSO/07.png" width="600">

Sign-in logs also show the failed login attempt.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/37-Entra_EnterpriseApp_SAML_SSO/09.png" width="700">

---

# Result

Microsoft Entra ID was configured as the Identity Provider for a SAML-based third-party application.

Adding the application to the tenant created an **Enterprise Application (service principal)** that represents the application in the tenant and allows its access and SSO configuration to be managed.

The lab demonstrated how user assignment, SAML configuration, signing certificates, and authentication logs work together to provide and troubleshoot SSO.

