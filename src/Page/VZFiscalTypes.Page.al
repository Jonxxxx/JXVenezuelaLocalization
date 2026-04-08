page 84146 JXVZFiscalTypes
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = JXVZFiscalType;
    Caption = 'Fiscal Types', Comment = 'Tipos fiscales';
    CardPageId = JXVZFiscalType;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description';
                }

                field(JXVZFiscalType; Rec.JXVZFiscalType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Fiscal type',
                        Comment = 'ESP = Tipo fiscal';
                }

                field(JXVZSVATCondition; Rec.JXVZSVATCondition)
                {
                    ApplicationArea = All;
                    ToolTip = 'VAT Condition', Comment = 'ESP="Condicion IVA"';
                    Visible = IsVenezuela;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        IsVenezuela := CompanyInformation.JXIsVenezuela();
    end;

    var
        CompanyInformation: Record "Company Information";
        IsVenezuela: Boolean;

}