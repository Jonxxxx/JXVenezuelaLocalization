table 84120 JXVZWithholdArea
{
    Caption = 'Withholding area', Comment = 'ESP=Area de retencion';
    LookupPageID = JXVZWithholdAreaList;

    fields
    {
        field(1; JXVZWithholdingCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Withholding code', Comment = 'ESP=Codigo de retencion';
            NotBlank = false;
        }
        field(2; JXVZDescription; Text[50])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Description', Comment = 'ESP=Descripcion';
        }
    }

    keys
    {
        key(Key1; JXVZWithholdingCode)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Vendor: Record Vendor;
        TextVendLbl: Label 'It''s not possible to delete area code %1 because it''s being used by Vendor %2.', Comment = '%1=Area code, %2 vendor code';
    begin
        Vendor.Reset();
        Vendor.SetRange(Vendor.JXVZWithholdingCode, JXVZWithholdingCode);
        if Vendor.FindFirst() then
            Error(TextVendLbl, JXVZWithholdingCode, Vendor."No.");
    end;
}