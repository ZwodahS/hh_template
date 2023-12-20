# Importing strings from another language
`python3 bin/csvtojson.py import/zh-cn`
`hl bin/stringman import import/zh-cn.json zh-cn`

# Deployment
`STEAMAPI=1 STEAM_USER=[user] RELEASE=1 make dist-steam-demo push-steam-demo dist-steam push-steam archive`
`STEAMAPI=1 STEAM_USER=[user] RELEASE=1 make dist push-all archive`

# Exporting strings
`hl bin/stringman writekeys`
`python3 bin/jsontocsv.py export/en`
