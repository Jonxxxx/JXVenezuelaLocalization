table 84144 JXVZImportLog
{
    DataClassification = CustomerContent;
    Caption = 'Import log';

    fields
    {
        field(1; "No."; Integer)
        {
            DataClassification = CustomerContent;
        }

        field(2; "Import Type"; Code[50])
        {
            DataClassification = CustomerContent;
        }

        field(3; "User Id"; Code[80])
        {
            DataClassification = CustomerContent;
        }

        field(4; "Import Date"; Date)
        {
            DataClassification = CustomerContent;
        }

        field(5; "Import Time"; Time)
        {
            DataClassification = CustomerContent;
        }

        field(6; Error; Boolean)
        {
            DataClassification = CustomerContent;
        }

        field(7; "Error description"; Text[500])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    procedure InsertLog(pImportType: Code[50]; pError: Boolean; pErrorDesc: Text[500])
    var
        JXVZImportLogInsert: Record JXVZImportLog;
        JXVZImportLogAux: Record JXVZImportLog;
        LastNo: Integer;
    begin
        JXVZImportLogAux.Reset();
        if JXVZImportLogAux.FindLast() then
            LastNo := JXVZImportLogAux."No."
        else
            LastNo := 1;

        JXVZImportLogInsert.Init();
        JXVZImportLogInsert."No." := LastNo + 1;
        JXVZImportLogInsert."Import Type" := pImportType;
        JXVZImportLogInsert."Import Date" := Today();
        JXVZImportLogInsert."Import Time" := Time();
        JXVZImportLogInsert."User Id" := UserId();
        JXVZImportLogInsert.Error := pError;
        JXVZImportLogInsert."Error description" := pErrorDesc;
        JXVZImportLogInsert.Insert(false);
    end;
}