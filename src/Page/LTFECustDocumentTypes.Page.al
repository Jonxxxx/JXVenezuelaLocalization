page 84105 JXVZFECustDocumentTypes
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = JXVZFECustDocumentType;
    Caption = 'FE customer document types', Comment = 'ESP = Clientes tipos de documentos FE';

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