page 84139 JXVZProvinces
{
    Caption = 'Province', Comment = 'ESP=Provincia';
    PageType = List;
    SourceTable = JXVZProvince;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(JXVZCode; Rec.JXVZCode)
                {
                    ApplicationArea = All;
                    Tooltip = 'Code', Comment = 'ESP=Codigo';
                }
                field(JXVZDescription; Rec.JXVZDescription)
                {
                    ApplicationArea = All;
                    Tooltip = 'Description', Comment = 'ESP=Descripcion';
                }
            }
        }
    }

    actions
    {
    }
}

