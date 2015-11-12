DECLARE @ProgID varchar(15);
SET @ProgID = 'STSoft'
          
Update Sys_Menu Set M_ProgID = @ProgID
Update Sys_Group Set G_ProgID = @ProgID
Update Sys_Entity Set E_ProgID = @ProgID
Update Sys_PopItem Set P_ProgID = @ProgID
Update Sys_DataDict Set D_Entity = REPLACE(D_Entity, 'JSMGR', @ProgID)