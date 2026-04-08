page 84149 JXVZImportLog
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = JXVZImportLog;
    Caption = 'Import log entries';
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'No.';
                }

                field("Import Type"; rec."Import Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Import Type';
                }
                field("Import Date"; rec."Import Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Import Date';
                }
                field("Import Time"; rec."Import Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Import Time';
                }
                field("User Id"; rec."User Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'User Id';
                }
                field(Error; rec.Error)
                {
                    ApplicationArea = All;
                    ToolTip = 'Error';
                }
                field("Error description"; rec."Error description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Error Description';
                }
            }
        }
    }
}