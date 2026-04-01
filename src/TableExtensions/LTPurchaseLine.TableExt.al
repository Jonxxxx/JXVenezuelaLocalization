tableextension 84117 JXVZPurchaseLine extends "Purchase Line"
{
    fields
    {
        field(84107; JXVZWithholdingCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Withholding Code', Comment = 'ESP=Codigo retencion';
            TableRelation = JXVZWithholdArea.JXVZWithholdingCode;
        }

        modify("No.")
        {
            trigger OnAfterValidate()
            var
                PurchaseHeader: Record "Purchase Header";
                CompanyInformation: Record "Company Information";
                VATPostingSetup: Record "VAT Posting Setup";
            begin
                if (CompanyInformation.JXIsVenezuela()) then begin
                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("Document Type", "Document Type");
                    PurchaseHeader.SetRange("No.", "Document No.");
                    if PurchaseHeader.FindFirst() then
                        JXVZWithholdingCode := PurchaseHeader.JXVZWithholdingCode;

                    if (Type = Type::"Fixed Asset") then begin
                        VATPostingSetup.Reset();
                        VATPostingSetup.SetRange("VAT Bus. Posting Group", rec."VAT Bus. Posting Group");
                        VATPostingSetup.SetRange("VAT Prod. Posting Group", rec."VAT Prod. Posting Group");
                        if VATPostingSetup.FindFirst() then
                            rec.Validate("VAT Calculation Type", VATPostingSetup."VAT Calculation Type");
                    end;
                end;
            end;
        }
    }
}