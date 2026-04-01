page 84104 JXVZFEDocumentTypes
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = JXVZFEDocumentType;
    Caption = 'FE document type',
                Comment = 'ESP = Tipo documento FE';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(JXId; Rec.JXId)
                {
                    ApplicationArea = All;
                    ToolTip = 'Id', Comment = 'ESP = Id';
                }
                field(JXDescription; Rec.JXDescription)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description', Comment = 'ESP = Descripcion';
                }
                field(JXFEValue; Rec.JXFEValue)
                {
                    ApplicationArea = All;
                    ToolTip = 'FE Value', Comment = 'ESP = Valor FE';
                }
            }
        }
    }
}