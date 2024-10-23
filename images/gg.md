Sub GenerateMaintenanceScheduleForMultipleAssets()
    Dim wsInput As Worksheet
    Dim wsOutput As Worksheet
    Dim currentHours As Long
    Dim monthlyHours As Long
    Dim totalMonths As Long
    Dim nextCheckUp As Long
    Dim nextMaintenance As Long
    Dim rowIndex As Long
    Dim monthCount As Long
    Dim eventType As String
    Dim assetName As String
    Dim lastRow As Long
    Dim assetRow As Long
    
    ' Set input and output worksheets
    Set wsInput = ThisWorkbook.Sheets("Assets") ' Input sheet with assets data
    Set wsOutput = ThisWorkbook.Sheets("MaintenanceSchedule") ' Output sheet for the schedule
    
    ' Clear the output sheet
    wsOutput.Cells.Clear
    
    ' Set headers in the output sheet
    wsOutput.Cells(1, 1).Value = "Asset Name"
    wsOutput.Cells(1, 2).Value = "Month"
    wsOutput.Cells(1, 3).Value = "Hours at Month End"
    wsOutput.Cells(1, 4).Value = "Event Type"
    
    rowIndex = 2 ' Start filling data from row 2 in the output sheet
    
    ' Find the last row with data in the input sheet
    lastRow = wsInput.Cells(wsInput.Rows.Count, "A").End(xlUp).Row
    
    ' Loop through each asset in the input sheet
    For assetRow = 2 To lastRow
        ' Get asset details
        assetName = wsInput.Cells(assetRow, 1).Value
        currentHours = wsInput.Cells(assetRow, 2).Value
        monthlyHours = wsInput.Cells(assetRow, 3).Value
        totalMonths = 10 * 12 ' 10 years = 120 months
        nextCheckUp = 150   ' Initial check-up threshold
        nextMaintenance = 300 ' Initial maintenance threshold
        
        ' Skip any past due check-ups and maintenance
        Do While currentHours >= nextCheckUp
            nextCheckUp = nextCheckUp + 150
        Loop
        Do While currentHours >= nextMaintenance
            nextMaintenance = nextMaintenance + 300
        Loop
        
        ' Loop through each month for 10 years
        For monthCount = 1 To totalMonths
            currentHours = currentHours + monthlyHours
            
            ' Determine event type (Check-Up or Maintenance)
            If currentHours >= nextMaintenance Then
                eventType = "Maintenance"
                nextMaintenance = nextMaintenance + 300
                nextCheckUp = nextCheckUp + 150
            ElseIf currentHours >= nextCheckUp Then
                eventType = "Check-Up"
                nextCheckUp = nextCheckUp + 150
            Else
                eventType = ""
            End If
            
            ' Add to the schedule if there is an event
            If eventType <> "" Then
                wsOutput.Cells(rowIndex, 1).Value = assetName
                wsOutput.Cells(rowIndex, 2).Value = monthCount
                wsOutput.Cells(rowIndex, 3).Value = currentHours
                wsOutput.Cells(rowIndex, 4).Value = eventType
                rowIndex = rowIndex + 1
            End If
        Next monthCount
    Next assetRow
End Sub