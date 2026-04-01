page 84145 JXVZFiscalType
{
    PageType = Card;
    //ApplicationArea = All;
    //UsageCategory = Administration;
    SourceTable = JXVZFiscalType;
    Caption = 'Fiscal type', Comment = 'Tipo fiscal';

    layout
    {
        area(Content)
        {
            group(General)
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

                field(JXFiscalType; Rec.JXFiscalType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Fiscal type',
                        Comment = 'ESP = Tipo fiscal';
                }

                field(JXFEVATCondition; Rec.JXFEVATCondition)
                {
                    ApplicationArea = All;
                    ToolTip = 'VAT Condition FE', Comment = 'ESP="Condicion IVA FE"';
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