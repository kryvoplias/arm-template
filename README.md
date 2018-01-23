# arm-template
Investigating into Azure Resource Manager Templates

# Sctructure
![Screenshot0](https://raw.githubusercontent.com/kryvoplias/arm-template/master/screenshots/screenshot.jpg)

# How to use with PowerShell
1. Log in to Azure.
```PowerShell
az login
```

2. Execute PowerShell script
```PowerShell
.\resource-group-create.ps1
```

# Templates structure
```
template.json
├── web-ip
├── rdp-ip
├── web-lb
├── vnet
│   └── web-subnet
│   └── rdp-subnet
│   └── api1-subnet
│   └── api2-subnet
│
├── template-jumpbox.json (linked template)
│   └── rdp-vm
│   └── rdp-vm-nic
│
├── template-vmss.json (linked template)
│   └── web-vmss
│
├── template-api.json (linked template)
│   └── api1-lb
│   └── template-sql-server.json (linked template)
│   │   └── api1-sqlserver
│   │   └── api1-sample-db
│   └── template-vmss.json (linked template)
│       └── api1-vmss
│
└── template-api.json (linked template)
    └── api2-lb
    └── template-sql-server.json (linked template)
    │   └── api2-sqlserver
    │   └── api2-sample-db
    └── template-vmss.json (linked template)
        └── api2-vmss
```