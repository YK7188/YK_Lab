Labbed: Sep 2026

# Scenario

An organization hires an external contractor from ABC Corporation for a 90-day project named XYZ. The contractor is provided with a standard Microsoft Entra ID user account, requires access to several corporate resources, and may occasionally need elevated privileges to perform Microsoft Entra administration.

This lab implements the contractor lifecycle using Microsoft Entra Identity Governance:
- Access package
- Approval workflow for access requests, reviews
- Privileged Identity Management (PIM) for temporary administrative privileges

---

# Requirements

The contractor requires:
- Access to a project Microsoft Team
- Access to a project SharePoint site
- Access to an Enterprise Application
- Membership in a project Security Group
- Manager approval before access is granted
- Access limited to 90 days
- Periodic manager review of existing access
- Temporary Microsoft Entra administrative privileges when required

> The contractor does not require permanent administrative privileges.

---

# Step 1 - Create an Entitlement Management Catalog

### 1. Create a catalog

Navigate to:

Microsoft Entra admin center 竊・Identity Governance 竊・Entitlement Management

Create a catalog for the contractor project.

Example:

Catalog: Contractor_ABC

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/35-AccessManagementSimulation_Contractor/01.png" width="700">

### 2. Add resources to the catalog

Add the resources required by contractors to the catalog. In this test, the following resource types are added:

- Security groups and Teams
- Applications

> The Team is backed by a Microsoft 365 Group and its associated SharePoint team site.
> Membership granted through the Access Package therefore also provides access to the group's SharePoint site.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/35-AccessManagementSimulation_Contractor/02.png" width="600">

---

# Step 2 - Create the Contractor Access Package

### 1. Create an access package

Choose the catalog and create:

Access Package: Contractor_ABC_PJ_XYZ and add the required project resources.

### 2. Configure the request policy

Configure the package so that eligible contractors can request access.

|Setting |	This lab|
|---|---|
|Eligible users |	Contractor1|
|Requestor justification |	Required|
|Approval |	Required|
|Approval stages | 1|
|Approver |	Manager/test manager account|
|Disable assignment emails	| No|

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/35-AccessManagementSimulation_Contractor/04.png" width="700">

### 3. Configure the life cycle

Set the assignment expiration to 90 days and configure the remaining lifecycle settings as follows.

|Setting	|This lab|
|---|---|
|Users can request specific timeline|No|
|Allow users to extend access	|Yes	|
|Require approval to grant extension|	Yes|
|Require access reviews	|Yes|

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/35-AccessManagementSimulation_Contractor/05.png" width="600">

---

# Step 3 窶・Test Self-Service Access, Approval and Review

### 1. Request access as the contractor

Sign in to [My Access](https://myaccess.microsoft.com) as Contractor1 and request the package.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/35-AccessManagementSimulation_Contractor/06.png" width="700">

Justification question appears as configured.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/35-AccessManagementSimulation_Contractor/07.png" width="300">

### 2. Review the request as the approver

Sign in to [My Access](https://myaccess.microsoft.com) as the manager and approve the request.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/35-AccessManagementSimulation_Contractor/09.png" width="700">

An approval request is also sent to the approver by email.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/35-AccessManagementSimulation_Contractor/08.png" width="400">

### 3. Verify resource access

After approval, Contractor1 receives the expected access to:
-	Team
-	SharePoint
-	Enterprise Application
-	Security Group

The example below shows that the applications have been successfully assigned in Entra ID.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/35-AccessManagementSimulation_Contractor/10.png" width="600">

### 4. Verify Access Review

For testing, the Access Review start date is adjusted so that the review begins immediately.

Once the review starts, the manager receives an email notification requesting a review of the contractor's existing access.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/35-AccessManagementSimulation_Contractor/11.png" width="500">

The manager opens the review in **My Access** and confirms that the contractor still requires access.

The approved review retains the contractor's existing Access Package assignment. The review does not extend the configured 90-day expiration period.

### 5. Resulting workflow

```
Contractor requests access
          竊・
Manager approval
          竊・
Access Package assigned
          竊・
Project resources granted
          竊・
Periodic Access Reviews
```

---

# Step 4 - Provide Temporary Entra Device Administration with PIM

The contractor occasionally needs to manage Microsoft Entra device objects. The **Cloud Device Administrator** role is therefore assigned as an eligible PIM role rather than as a permanently active role.

### 1. Configure activation settings

Go to:

ID Governance > Privileged Identity Management > Microsoft Entra roles > Manage > Roles > **Cloud Device Administrator**

and configure the following activation settings for this test.

Activation settings
|Setting|This Lab|
|---|---|
|Activation maximum| 8 hours|
|On activation require| Azure MFA|
|Justification| Yes|
|Ticket| No|
|Approval| Yes|
|Custom extensions| No|

<br>
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/35-AccessManagementSimulation_Contractor/12.png" width="600">

> PIM activation settings are configured for the role rather than separately for each eligible user.

### 2. Configure access reviews

Go to:

ID Governance > Privileged Identity Management > Microsoft Entra roles > Manage > Access reviews > New

and configure a review for the role.

> PIM Access Reviews are configured for a role rather than for an individual role assignment. The **Manager** reviewer option can dynamically route each assignee's review to their manager. Periodic reviews determine whether the contractor should continue to retain the eligible **Cloud Device Administrator** assignment.

<br>
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/35-AccessManagementSimulation_Contractor/17.png" width="600">

### 3. Assign the role

Return to:

PIM > Microsoft Entra roles > Manage > Assignments > Add assignments

Choose **Eligible** for **Assignment type** and configure the assignment start and end dates to align with the contractor engagement.

<br>
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/35-AccessManagementSimulation_Contractor/13.png" width="500">

### 4. Verification

When the contractor logs into Entra ID, the role appears as eligible. Once activation is requested, the designated PIM approver receives an approval request. After approval is granted, **Cloud Device Administrator** becomes active for the contractor for the requested duration, up to the configured 8-hour maximum.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/35-AccessManagementSimulation_Contractor/14.png" width="700">

### Resulting workflow

```
Role configuration and eligible assignment
                 竊・
Contractor requests activation
                 竊・
       MFA and justification
                 竊・
      PIM approver approval
                 竊・
Cloud Device Administrator becomes ACTIVE
                 竊・
 Active for requested duration
       (up to 8 hours)
                 竊・
Role automatically deactivates
```

---

# Step 5 窶・End the Contractor Lifecycle

The contractor's normal project access and privileged role eligibility have separate lifecycles.

### 1. Access Package expiration

At the end of the 90-day assignment, if no extension has been approved:

- The Access Package assignment expires.
- Access granted through the package is automatically removed, including the associated Team, SharePoint site, Enterprise Application, and Security Group membership.
  
### 2. PIM role expiration

The **Cloud Device Administrator** eligible assignment has its own start and end date.

When the eligible assignment expires:

- The contractor can no longer activate the role.

> The Access Package expiration and PIM role expiration are independent. In this scenario, both can be aligned with the 90-day contractor engagement.


