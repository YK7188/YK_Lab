# Scenario

A company operates offices in Tokyo and Osaka, with the Headquarters IT team managing Microsoft Entra ID.

The company wants to delegate identity administration to regional IT staff without giving them tenant-wide administrative privileges.

Requirements:
- Tokyo IT can reset passwords for non-privileged user accounts belonging to the Tokyo office.
- Tokyo IT must not be able to administer Osaka users.
- HQ IT retains tenant-wide administrative authority.

---

# Part 1 - Configure delegated administration

### 1. Create AU Tokyo_AU and Osaka_AU.

Go to:

Roles & admins > Admin units > Add

to create each AU. 

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/38-DelegatingITAdmin_withEntraAU/01.png" width="600">

Assign TokyoHelp1 to Helpdesk Administrator of Tokyo_AU.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/38-DelegatingITAdmin_withEntraAU/02.png" width="600">

Leave Osaka_AU without an AU-scoped administrator.

### 2. Assign HQHelp1 the Helpdesk Administrator role at tenant scope.

Go to:

Roles & admins > All roles > Helpdesk Administrator > add assignments

to assign the active role to HQHelp1

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/38-DelegatingITAdmin_withEntraAU/07.png" width="450">

### 3.	Add the respective test users to each AU.

TokyoUser1 to Tokyo_AU and OsakaUser1 to Osaka_AU respectively.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/38-DelegatingITAdmin_withEntraAU/03.png" width="600">

---

# Part 2 - Validate access boundaries

| Administrator | Target | Result |
|---|---|---|
| TokyoHelp1 | TokyoUser1 | Allowed |
| TokyoHelp1 | OsakaUser1 | Denied — insufficient administrative privileges |
| HQHelp1 | TokyoUser1 | Allowed |
| HQHelp1 | OsakaUser1 | Allowed |

<br>
<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/38-DelegatingITAdmin_withEntraAU/04.png" width="300">

---

# Part 3 - AU limitation

Create a security group Osaka_All including OsakaUser1.

Add Osaka_All to Tokyo_AU and attempt to reset OsakaUser1's password using TokyoHelp1.

<img src="https://github.com/YK7188/YK_Lab/blob/main/docs/images/38-DelegatingITAdmin_withEntraAU/05.png" width="600">

Result:

TokyoHelp1 receives the same insufficient privileges error when attempting to reset OsakaUser1's password. Although Osaka_All was added to Tokyo_AU, its individual members were not automatically added.


