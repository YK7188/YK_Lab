

## Preparing installation package using ODT

1. Download ODT from Microsoft and extract it.

2. Create a configuration XML
- 64bit
- Montly
- English and Japanese
- Access and Publisher excluded from installation
- Silent installation

```xml
<Configuration>
  <Add OfficeClientEdition="64" Channel="MonthlyEnterprise">
    <Product ID="O365ProPlusRetail">
      <Language ID="en-us" />
      <Language ID="ja-jp" />
      <ExcludeApp ID="Access" />
      <ExcludeApp ID="Publisher" />
    </Product>
  </Add>

  <Display Level="None" AcceptEULA="TRUE" />

  <Property Name="AUTOACTIVATE" Value="1" />

  <Updates Enabled="TRUE" />

  <RemoveMSI />
  
</Configuration>
```

3. Run setup.exe /download
4. setup.exe /configure

## Deployment 

