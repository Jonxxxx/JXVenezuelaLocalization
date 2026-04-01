page 84142 JXVZSetupCustomsPerceptions
{
    PageType = List;
    SourceTable = JXVZSetupCustomsPerceptions;
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Setup customs perceptions', comment = 'ESP=Configuración percepciones aduaneras';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(JXVZProvince; Rec.JXVZProvince)
                {
                    ApplicationArea = All;
                    ToolTip = 'Province', comment = 'ESP=Provincia';
                }
                field(JXVZAliquot; Rec.JXVZAliquot)
                {
                    ApplicationArea = All;
                    ToolTip = 'Aliquot', comment = 'ESP=Alicuota';
                }
                field(JXVZCoefficient; Rec.JXVZCoefficient)
                {
                    ApplicationArea = All;
                    ToolTip = 'Coefficient', comment = 'ESP=Coeficiente';
                }
            }
        }
    }

    actions
    {
    }
}