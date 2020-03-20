# yaml2code
Architect a .NET Solution from yaml
![yaml2code](/yaml2code.png)

# How to use
- Ensure you have at least .NET Core SDK 3.0 installed
- Pull this repo
- Run Import-Module powershell-yaml
- Edit code.yaml if you wish
- Call yaml2code.ps1

# Why?
I like writing little Powershell scripts on the side, and I've recently begun looking into yaml which I find quite readable.

I was wondering to what extent a .NET solution could be defined and it's creation automated

# The future

I'd really like to add -features per project, which call upon powershell scripts in a Features folder.

For example, I'd like to define something like
projects:
  - name: Application
  - features:
    - commands:
      - PurchaseOrderRaised
      - PurchaseOrderCancelled
      - PurchaseOrderReconcilled
    - queries:
      - AllOpenPurchaseOrders
      - MismatchedPurchaseOrders

And have the code stub out the commands, interfaces, etc, in the correct structure.

