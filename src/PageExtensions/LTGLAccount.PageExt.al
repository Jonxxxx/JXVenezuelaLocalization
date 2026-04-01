pageextension 84127 JXVZGLAccount extends "G/L Account Card"
{
    layout
    {
        addlast(General)
        {
            field(JXVZTaxGroupCode; Rec."Tax Group Code")
            {
                Visible = IsVenezuela;
                ApplicationArea = All;
                ToolTip = 'Tax group code', Comment = 'ESP=Codigo grupo impuesto';
            }
        }

        addafter("Cost Accounting")
        {
            group(JXVZgentineVenezuela)
            {
                Visible = IsVenezuela;
                Caption = 'Venezuela',
                            Comment = 'ESP = Venezuela';

                field(JXVZPercepLineIIBB; Rec.JXVZPercepLineIIBB)
                {
                    ApplicationArea = All;
                    ToolTip = 'Perception by line IIBB ARBA', Comment = 'ESP = Percepcion por linea IIBB ARBA';
                }

                field(JXVZPercepLineIIBBCABA; Rec.JXVZPercepLineIIBBCABA)
                {
                    ApplicationArea = All;
                    ToolTip = 'Perception by line IIBB CABA', Comment = 'ESP = Percepcion por linea IIBB CABA';
                }

                field(JXVZPercepLineIIBBOthers; Rec.JXVZPercepLineIIBBOthers)
                {
                    ApplicationArea = All;
                    ToolTip = 'Perception by line IIBB Others', Comment = 'ESP = Percepcion por linea IIBB Otros';
                }

                field(JXVZPercepLineGAN; Rec.JXVZPercepLineGAN)
                {
                    ApplicationArea = All;
                    ToolTip = 'Perception by line Gain', Comment = 'ESP = Percepcion por linea Ganancias';
                }

                field(JXVZPercepLineVAT; Rec.JXVZPercepLineVAT)
                {
                    ApplicationArea = All;
                    ToolTip = 'VAT Perception by line', Comment = 'ESP = Percepcion IVA por linea';
                }

                field(JXVZPercepLineVAT105; Rec.JXVZPercepLineVAT105)
                {
                    ApplicationArea = All;
                    ToolTip = 'Perception by line VAT 10.5', Comment = 'ESP = Percepcion por linea IVA 10,5';
                }

                field(JXVZPercepLineVAT21; Rec.JXVZPercepLineVAT21)
                {
                    ApplicationArea = All;
                    ToolTip = 'Perception by line VAT 21', Comment = 'ESP = Percepcion por linea 21';
                }

                field(JXVZPercepLineVAT27; Rec.JXVZPercepLineVAT27)
                {
                    ApplicationArea = All;
                    ToolTip = 'Perception by line VAT 27', Comment = 'ESP = Percepcion por linea IVA 27';
                }

                field(JXVZProvinceCode; Rec.JXVZProvinceCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Province', Comment = 'ESP=Provincia';
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