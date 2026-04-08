pageextension 84141 JXVZGeneralLedgerSetup extends "General Ledger Setup"
{
    layout
    {
        addafter(Application)
        {
            group(JXElectronicInvoice)
            {
                Visible = IsVenezuela;

                Caption = 'Venezuela',
                            Comment = 'ESP = Venezuela';

                field(JXVZRoundIVA; Rec.JXVZRoundIVA)
                {
                    ApplicationArea = All;
                    ToolTip = 'Round IVA decimals';
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