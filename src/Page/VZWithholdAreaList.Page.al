page 84124 JXVZWithholdAreaList
{
    Caption = 'Withholding area list', Comment = 'ESP=Lista de area de retencion';
    CardPageID = JXVZWithholdArea;
    PageType = List;
    SourceTable = JXVZWithholdArea;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                Editable = false;
                ShowCaption = false;
                field(JXVZWithholdingCode; Rec.JXVZWithholdingCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Withholding code', Comment = 'ESP=Codigo de retencion';
                }
                field(JXVZDescription; Rec.JXVZDescription)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description', Comment = 'ESP=Descripcion';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000005>")
            {
                ApplicationArea = All;
                Caption = 'Detail', Comment = 'ESP=Detalle';
                ToolTip = 'Detail', Comment = 'ESP=Detalle';
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page JXVZWithholdArea;
                RunPageLink = JXVZWithholdingCode = FIELD(JXVZWithholdingCode);
            }
        }
    }
}