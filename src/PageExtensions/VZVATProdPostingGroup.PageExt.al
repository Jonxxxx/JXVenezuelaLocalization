pageextension 84102 JXVZVATProdPostingGroup extends "VAT Product Posting Groups"
{
    layout
    {
        addafter(Description)
        {
            field(JXVZVatPurchReport; Rec.JXVZVatPurchReport)
            {
                ApplicationArea = All;
                Visible = VisibleVenezuela;
                Caption = 'Libro IVA Venezuela';
                ToolTip = 'Indica el tipo de registro que se generará en el libro IVA Venezuela.';
            }
        }
    }

    trigger OnOpenPage()
    var
        CompInfo: Record "Company Information";
    begin
        VisibleVenezuela := false;

        if CompInfo.JXIsVenezuela() then
            VisibleVenezuela := true;
    end;

    var
        VisibleVenezuela: Boolean;
}