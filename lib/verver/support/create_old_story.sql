-- usage example : sqlcmd.exe -i create_old_story.sql -s . -d V1Web -v DaysOld=5 ScopeOid=1013 StoryName="Not New Story"
BEGIN TRANSACTION

	DECLARE
	  @age INT = 0 - '$(DaysOld)'
	 ,@assetType VARCHAR(100) = 'Story'
	 ,@storyName VARCHAR(100) = '$(StoryName)'
	 ,@storyNameId INT
	 ,@auditId INT
	 ,@scopeId INT = '$(ScopeOid)'
	 ,@storyNumber INT
	 ,@assetId INT
	 ,@statusId INT
	 ,@timeboxId INT
	 ,@defaultAuditId INT = 250
	 ,@defaultBaseAssetId INT = 900

	SET IDENTITY_INSERT Audit ON

	IF (SELECT MAX(ID + 1) FROM dbo.Audit WHERE ID < 1000 and ID >= @defaultAuditId) IS NULL
		SELECT @auditId = @defaultAuditId
	ELSE
		SELECT @auditId = (SELECT MAX(ID + 1) FROM dbo.Audit WHERE ID < 1000 and ID >= @defaultAuditId )
	
	INSERT INTO [dbo].[Audit]
			   (ID,
			   [ChangeDateUTC]
			   ,[ChangedByID]
			   ,[ChangeReason]
			   ,[ChangeComment])
		 VALUES
			   (@auditId,
				DATEADD(DAY, @age, GETDATE()),
				NULL, NULL, NULL)
			
	SELECT @auditId = @@IDENTITY

	SET IDENTITY_INSERT Audit OFF

	declare @key int
	EXEC [dbo].[_SaveString]@storyName, @key = @storyNameId OUTPUT

	SELECT @scopeId = (SELECT MAX(ID) FROM [dbo].Scope_Now where ID != 0)
	SELECT @storyNumber = (SELECT (MAX(Number)+1) FROM [dbo].Workitem_Now)
	SELECT @statusId = (SELECT MIN(ID) FROM [dbo].List_Now where AssetType = 'StoryStatus')
	SELECT @timeboxId = (SELECT MAX(ID) from [dbo].Timebox_Now)


	IF (@scopeId IS NULL) SELECT @scopeId = 0
	IF (@storyNumber IS NULL) SELECT @storyNumber = 900	

	IF (SELECT MAX(ID + 1) FROM dbo.[BaseAsset_Now] WHERE ID < 1000 and ID >= @defaultBaseAssetId) IS NULL
		SELECT @assetId = @defaultBaseAssetId
	ELSE
		SELECT @assetId = (SELECT MAX(ID + 1) FROM dbo.[BaseAsset_Now] WHERE ID < 1000 and ID >= @defaultBaseAssetId )

	SELECT @age as Age, @storyName AS StoryName, @scopeId AS ScopeId, @storyNumber AS NumberId, @storyNameId AS StoryId, @auditId AS AuditId, @assetId AS AssetId

	INSERT INTO [dbo].[BaseAsset_Now]
			   (ID
			   ,[AssetType]
			   ,[AuditBegin]
			   ,[Name]
			   ,[Description]
			   ,[AssetState]
			   ,[SubState]
			   ,[SecurityScopeID])
		 VALUES
			   (@assetId
			   ,@assetType
			   ,@auditId
			   ,@storyNameId
			   ,NULL
			   ,64
			   ,NULL
			   ,0)

	INSERT INTO [dbo].[Workitem_Now]
			   (ID
			   ,[AssetType]
			   ,[AuditBegin]
			   ,[DetailEstimate]
			   ,[ToDo]
			   ,[ParentID]
			   ,[ScopeID]
			   ,[TimeboxID]
			   ,[Number]
			   ,[TeamID]
			   ,[SuperID])
		 VALUES
			   (@assetId
			   ,@assetType
			   ,@auditId
			   ,NULL
			   ,NULL
			   ,NULL
			   ,@scopeId
			   ,@timeboxId
			   ,@storyNumber
			   ,NULL
			   ,NULL)

	INSERT INTO [dbo].[PrimaryWorkitem_Now]
			   (ID
			   ,[AssetType]
			   ,[AuditBegin]
			   ,[Estimate]
			   ,[StatusID]
			   ,[PriorityID]
			   ,[SplitFromID])
		 VALUES
			   (@assetId
			   ,@assetType
			   ,@auditId
			   ,NULL
			   ,@statusId
			   ,NULL
			   ,NULL)
           
	INSERT INTO [dbo].[Story_Now]
			   (ID
			   ,[AssetType]
			   ,[AuditBegin]
			   ,[Value]
			   ,[CustomerID]
			   ,[CategoryID]
			   ,[RiskID]
			   ,[IdentifiedInID]
			   ,[Benefits])
		 VALUES
			   (@assetId
			   ,@assetType
			   ,@auditId
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL)
           
COMMIT