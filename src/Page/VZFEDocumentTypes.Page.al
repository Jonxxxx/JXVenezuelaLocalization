page 84104 JXVZFEDocumentTypes
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = JXVZFEDocumentType;
    Caption = 'document type',
                Comment = 'ESP = Tipo documento';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(JXVZId; Rec.JXVZId)
                {
                    ApplicationArea = All;
                    ToolTip = 'Id', Comment = 'ESP = Id';
                }
                field(JXVZDescription; Rec.JXVZDescription)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description', Comment = 'ESP = Descripcion';
                }
                field(JXVZSValue; Rec.JXVZSValue)
                {
                    ApplicationArea = All;
                    ToolTip = 'Value', Comment = 'ESP = Valor';
                }
            }
        }
    }
}