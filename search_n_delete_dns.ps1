$dnsServer = "localhost"
$zoneName = "xyz.com"
$searchString = "*-stag.xyz.com"

echo "Searching for DNS records ending with ""$searchString"" in ""$zoneName"" on ""$dnsServer""..."

# Get the DNS records matching the search string
$recordsContainingStagManaged = Get-DnsServerResourceRecord -ZoneName $zoneName | Where-Object { $_.HostName -like "*-stag.xyz.com" }

# Display the matching records and delete them
if ($recordsContainingStagManaged.Count -gt 0) {
    $recordsContainingStagManaged | ForEach-Object {
        echo "Deleting record: $($_.HostName) ($($_.RecordData.IPv4Address))"
        $recordType = $_.RecordType
        $recordData = $_.RecordData
        $recordName = $_.HostName
        # dnscmd /RecordDelete $zoneName "$recordName" "$recordType" "$recordData" /f
    }
    echo "DNS records ending with ""$searchString"" in ""$zoneName"" have been deleted."
} else {
    echo "No DNS records ending with ""$searchString"" found in ""$zoneName""."
}

pause
