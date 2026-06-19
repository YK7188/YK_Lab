> Tested: June 2026


# Scenario

The organization requires VPN profiles to be automatically deployed to Intune-managed devices.

### Requirements:

- Windows, iPhones and Android devices must automatically receive VPN settings.
- Authentication should use certificates rather than passwords where possible.
- VPN settings should be centrally managed through Microsoft Intune.

# Premise

### A VPN server is already available for testing.

For this lab:
- strongSwan is hosted on an Oracle Cloud VM.
- DuckDNS provides a public FQDN for the VPN server.

The VPN server configuration itself is outside the scope of this lab.

### CA and Certificate Deployment (Labbed in [18.Hybrid PKI simulation](https://github.com/YK7188/YK_Lab1/tree/main/18.Hybrid%20PKI%20simulation))

- PKCS Connector has been configured and Intune can request certificates on behalf of users/devices. This enables certificate issuance from on-prem CA via Intune.
- Trusted Root Certificate deployment has been configured with Trusted Certificate Profile. 
- Computer certificate deployment has been configured with PKCS certificate profile.

# Step 1 - Prepare Certificates

### Create and issue the server certificate

Go to the CA server and open certtmpl.msc. Create and issue a new template for the VPN server.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/28-Intune%20VPN%20Profiles%20%26%20Certificate%20Deployment/02.issue_VPNtempl.jpg" width="600">

Obtain Certificate signing request (CSR) from the VPN server and submit a PKCS certificate by running the command below.

```
certreq -submit `
-config "SRV1.yasutakakojima8911.com\CORP-ROOT-CA" `
-attrib "CertificateTemplate:vpn Server" `
C:\vpn-server\vpn-server.csr `
C:\vpn-server\vpn-server.cer
```

Certificate is now stored in the targeted folder ready to be imported to the VPN server.

### Export the CA Root Certificate

strongSwan must trust the CA. Export the CA certificate on the CA server so it can be imported to the VPN server.

Open certsrv.msc > right click the root CA > properties > General > View certificate > Details > Copy to file

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/28-Intune%20VPN%20Profiles%20%26%20Certificate%20Deployment/03.export_CAcert.jpg" width="800">

### Import the Certificates into the VPN Server

Import the server certificate and CA certificate into the VPN server. The VPN server is now ready to accept certificate-based VPN connections.

# Step 2 - Create the VPN profile

### Create the VPN profile for Windows

Intune > Devices > Windows > Configuration > Create > New policy > Windows 10 and later > Templates > VPN

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/28-Intune%20VPN%20Profiles%20%26%20Certificate%20Deployment/04.create_VPNPolicy.jpg" width="700">

Enter the correct information for configuration settings:
- Use this VPN profile with a user/device scope > Device 
- Connection type > IKEv2
- Register IP addresses with internal DNS > Enable

Result:

The VPN profile appears in the native Windows VPN client. Because a PKCS device certificate is already deployed through Intune, the device can authenticate to the VPN without entering credentials.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/28-Intune%20VPN%20Profiles%20%26%20Certificate%20Deployment/05.vpn_shown.jpg" width="500">

### Create the VPN profile for Android

Intune > Devices > Android > Configuration > Create > New policy > Android Enterprise > Templates > VPN

The image below shows the VPN client types supported by Intune.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/28-Intune%20VPN%20Profiles%20%26%20Certificate%20Deployment/09.no_strongswan.jpg" width="500">

Result: 

- The native Intune VPN profile templates do not support strongSwan.
- The strongSwan client was manually configured to use the PKCS certificate deployed by Intune.
- The Android device successfully connected using certificate authentication.

### Create the VPN profile for iPhone

Intune > Devices > Apple mobile > Configuration > Create > New policy > iOS/iPadOS > Templates > VPN

Configure a profile choosing IKEv2 for Connection type. 

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/28-Intune%20VPN%20Profiles%20%26%20Certificate%20Deployment/10.not_credentials_strongswan.jpg" width="500">

Once the policy applies to the iPhone, the configured profile appears on the native vpn client.

<img src="https://github.com/YK7188/YK_Lab1/blob/main/docs/images/28-Intune%20VPN%20Profiles%20%26%20Certificate%20Deployment/10.not_credentials_strongswan.jpg" width="500">

Result: 

- The VPN profile was successfully deployed to the device.
- The PKCS certificate was successfully deployed and selectable by the VPN profile.
- The iPhone never successfully established a VPN connection.
- A manually created VPN profile produced the same result.
- Further troubleshooting would be required to identify the root cause.
  
# Final Note

This lab demonstrated deployment of VPN profiles and certificates through Microsoft Intune across Windows, Android and iOS devices.

- Windows successfully connected using the native VPN client and PKCS certificate. No manual client configuration was required.
- Android successfully connected using the strongSwan client and PKCS certificate. Manual client configuration was required.
- iPhone received both the VPN profile and PKCS certificate but could not establish a successful VPN connection during testing.

In production environments, organizations commonly use vendor-supported VPN solutions such as Cisco AnyConnect, GlobalProtect, or F5 Access. These solutions typically provide tighter integration with Intune and reduce the amount of manual client configuration required.
