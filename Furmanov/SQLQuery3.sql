USE master;
USE AirlineBD;
ALTER DATABASE AirlineBD SET RECOVERY FULL;

DROP DATABASE AirlineBD

SELECT AuditID, TableName, OperationType, RecordID, UserName, EventTime, LEFT(NewValue, 80) AS NewValuePreview
FROM dbo.Audit
ORDER BY AuditID;