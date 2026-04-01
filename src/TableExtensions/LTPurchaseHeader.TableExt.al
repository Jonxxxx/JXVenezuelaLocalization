tableextension 84116 JXVZPurchaseHeader extends "Purchase Header"
{
    fields
    {
        field(84100; JXVZFiscalType; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Fiscal type', Comment = 'ESP = "Tipo fiscal"';
            TableRelation = JXVZFiscalType."No.";
        }

        field(84101; JXVZWithholdingCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Withholding code', Comment = 'ESP=Codigo retencion';
            TableRelation = JXVZWithholdArea.JXVZWithholdingCode;
        }

        field(84103; JXVZProvince; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Province', Comment = 'ESP=Provincia';
            TableRelation = JXVZProvince;
        }

        field(84104; JXInvoiceType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Invoice type',
                        Comment = 'ESP = Tipo factura';
            OptionMembers = ,Invoice,DebitMemo;
            OptionCaption = ' ,Invoice,DebitMemo', Comment = 'ESP= ,Factura,Nota debito';
        }

        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            begin
                ValidateJXVZFields();
            end;
        }
        modify("Buy-from Vendor Name")
        {
            trigger OnAfterValidate()
            begin
                ValidateJXVZFields();
            end;
        }
    }

    trigger OnAfterInsert()
    begin
        JXVZSetDefaultValues();
    end;

    local procedure ValidateJXVZFields()
    var
        Vendor: Record Vendor;
        CompanyInformation: Record "Company Information";
    begin
        if (CompanyInformation.JXIsVenezuela()) then begin
            Vendor.Reset();
            Vendor.SetRange("No.", "Buy-from Vendor No.");
            if Vendor.FindFirst() then begin
                rec.JXVZFiscalType := Vendor.JXVZFiscalType;
                rec.JXVZProvince := Vendor.JXVZProvinceCode;
                rec.JXVZWithholdingCode := Vendor.JXVZWithholdingCode;
            end;
        end;
    end;

    local procedure JXVZSetDefaultValues()
    var
        JXVZFEConfiguration: Record JXVZFEConfiguration;
        CompanyInformation: Record "Company Information";
    begin
        if (CompanyInformation.JXIsVenezuela()) then begin
            JXVZFEConfiguration.Reset();
            if JXVZFEConfiguration.FindFirst() then
                if ((rec."Document Type" = rec."Document Type"::Order) or (rec."Document Type" = rec."Document Type"::Invoice)) then
                    rec.validate(JXInvoiceType, JXVZFEConfiguration.JXVZDefValueInvoiceType);
        end;
    end;

    var
        ErrorZeroLbl: Label 'Value cannot be 0', Comment = 'ESP=El valor no puede ser 0';
}