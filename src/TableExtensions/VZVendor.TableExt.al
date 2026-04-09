tableextension 84113 JXVZVendor extends Vendor
{
    fields
    {
        field(84101; JXVZFiscalType; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Fiscal type', Comment = 'ESP = "Tipo fiscal"';
            TableRelation = JXVZFiscalType."No.";

        }

        field(84103; JXVZWithholdingCondition; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Withholding condition', Comment = 'ESP=Condicion de retencion';
            TableRelation = JXVZVendorWithholdCondition.JXVZVendorCode WHERE(JXVZVendorCode = FIELD("No."));
        }
        field(84104; JXVZProvinceCode; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Province Code', Comment = 'ESP=Codigo provincia';
            TableRelation = JXVZProvince;
        }

        field(84105; JXVZWithholdingCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Withholding Code', Comment = 'ESP=Codigo retencion';
            TableRelation = JXVZWithholdArea.JXVZWithholdingCode;

            trigger OnValidate()
            var
                JXVZVendorWithholdCondition: Record JXVZVendorWithholdCondition;
                JXVZWithholdAreaLine: Record JXVZWithholdAreaLine;
                JXVZWithholdDetailEntry: Record JXVZWithholdDetailEntry;
                ShowConfirm: Boolean;
                PerformProcess: Boolean;
                _JXVZ01Lbl: Label 'Do you want to change vendor condition?';
            begin
                ShowConfirm := false;
                PerformProcess := true;

                JXVZVendorWithholdCondition.Reset();
                JXVZVendorWithholdCondition.SetRange(JXVZVendorCode, "No.");
                if (JXVZVendorWithholdCondition.FindSet()) then
                    ShowConfirm := true;

                if ShowConfirm then
                    if not (Confirm(_JXVZ01Lbl, false)) then
                        PerformProcess := false;

                if PerformProcess then begin
                    JXVZVendorWithholdCondition.Reset();
                    JXVZVendorWithholdCondition.SetRange(JXVZVendorCode, "No.");
                    if (JXVZVendorWithholdCondition.FindSet()) then
                        repeat
                            JXVZVendorWithholdCondition.Delete();
                        until JXVZVendorWithholdCondition.Next() = 0;

                    JXVZWithholdAreaLine.Reset();
                    JXVZWithholdAreaLine.SetRange(JXVZWithholdingCode, JXVZWithholdingCode);
                    if (JXVZWithholdAreaLine.FindSet()) then
                        repeat
                            JXVZWithholdDetailEntry.Reset();
                            JXVZWithholdDetailEntry.SetRange(JXVZWitholdingNo, JXVZWithholdAreaLine.JXVZWithholdingNo);
                            if (JXVZWithholdDetailEntry.FindFirst()) then begin
                                JXVZVendorWithholdCondition.Init();
                                JXVZVendorWithholdCondition.JXVZVendorCode := "No.";
                                JXVZVendorWithholdCondition.JXVZTaxCode := JXVZWithholdAreaLine.JXVZTaxCode;
                                JXVZVendorWithholdCondition.JXVZTaxConditionCode := JXVZWithholdDetailEntry.JXVZConditionCode;
                                JXVZVendorWithholdCondition.Insert();

                                JXVZWithholdingCondition := JXVZVendorWithholdCondition.JXVZVendorCode;
                            end;
                        until JXVZWithholdAreaLine.Next() = 0;
                end;
            end;
        }
        field(84106; JXVZFEDocumentType; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document type',
                        Comment = 'ESP = Tipo documento';
            TableRelation = JXVZFECustDocumentType;
            ValidateTableRelation = true;
        }

        modify("VAT Registration No.")
        {
            trigger OnAfterValidate()
            var
                CompInfo: Record "Company Information";
                JXVZLogicalFactory: Codeunit JXVZLogicalFactory;
            begin
                CompInfo.Reset();
                if CompInfo.FindFirst() then
                    if CompInfo.JXVZVenezuelaLocEnabled then begin
                        Clear(JXVZLogicalFactory);
                        JXVZLogicalFactory.ValidateVenezuelanRIFOrError("VAT Registration No.", Rec."Country/Region Code");
                        Rec."VAT Registration No." := JXVZLogicalFactory.NormalizeVenezuelanRIF("VAT Registration No.");
                    end;
            end;
        }
    }

    /*procedure "#ValidateTaxAreaCode"()
    var
        TaxArea: Record "Tax Area";
    begin
        //JXVZ (02)
        if TaxArea.Get("Tax Area Code") then begin
            JXVZFiscalType := TaxArea.JXVZFiscalType;
            "Tax Liable" := true;
        end else begin
            JXVZFiscalType := '';
            "Tax Liable" := false;
        end;
        //JXVZ (02) END
    end;*/


    /*var
        TextJXL0010Lbl: Label 'The RIF must not have any more than 11 digits';
        TextJXL0011Lbl: Label 'The RIF must not have less than 11 digits';
        TextJXL0012Lbl: Label 'The number of RIF is not correct';
        TextJXL0013Lbl: Label 'It is not configured fiscal type in tax area code %1';
        TextJXL0014Lbl: Label 'Fiscal Type must be %1';
        TextJXL0015Lbl: Label 'Complete the field Tax Area Code first';*/
}