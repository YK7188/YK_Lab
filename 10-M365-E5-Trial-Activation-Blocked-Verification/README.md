> Tried: April 2026

## Objective
Attempt to start a Microsoft 365 E5 trial in a new tenant to access additional Microsoft Intune features (e.g., quality updates and driver updates in Windows Update for Business).

## Steps

1.Accessed the Microsoft 365 pricing page and initiated tenant creation using an available business trial plan:
   
https://www.microsoft.com/en-us/microsoft-365/business/microsoft-365-plans-and-pricing

<br>
2. During checkout, the following error appeared:

&nbsp;&nbsp;&nbsp;`Something happened.
We need some more information to verify your order.`

<br>
3. Despite the error, the tenant was created and accessible:

https://admin.microsoft.com

<br>
4. Inside the admin portal:

- Microsoft 365 E5 (Trial) was available as an additional trial option  

- Attempted to activate the E5 trial  

<br>
5. During checkout, the error below appears.

&nbsp;&nbsp;`Something happened. The verification checks on your order failed.`

<br>
6. Attempted to contact Microsoft support:

- Chatbot redirected to phone/email support

- No email option available

- Phone support was unreachable (line busy across multiple attempts)

<br>
7. Retried to create a tenant with different parameters:

- Different IP address

- Different credit card

- Different company name

> All attempts resulted in the same verification failure

## Conclusion
The tenant was successfully created, but trial license activation consistently failed due to verification checks.

This suggests Microsoft applies backend validation mechanisms that can block trial activation even when the admin portal is accessible.
  

