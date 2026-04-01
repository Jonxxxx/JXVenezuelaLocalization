report 84124 JXVZWithholdIIBBByVend
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    caption = 'Detalle percepciones IIBB proveedores', Comment = 'ESP=Percepciones IIBB proveedores';
    DefaultLayout = RDLC;
    RDLCLayout = 'ReportLayout/JXVZWithholdIIBBByVend.rdl';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting("No.") order(ascending);
            RequestFilterFields = "No.", "Gen. Bus. Posting Group";

            trigger OnAfterGetRecord()
            begin
                JXVZVendorWithholdCondition.Reset();
                JXVZVendorWithholdCondition.SetRange(JXVZVendorCode, Vendor."No.");
                if JXVZVendorWithholdCondition.FindSet() then
                    repeat
                        JXVZWithholdingTax.Reset();
                        JXVZWithholdingTax.SetRange(JXVZTaxCode, JXVZVendorWithholdCondition.JXVZTaxCode);
                        if JXVZWithholdingTax.FindFirst() then
                            if (JXVZWithholdingTax.JXVZTaxType = JXVZWithholdingTax.JXVZTaxType::"IB-ARBA") or
                                (JXVZWithholdingTax.JXVZTaxType = JXVZWithholdingTax.JXVZTaxType::"IB-CABA") or
                                (JXVZWithholdingTax.JXVZTaxType = JXVZWithholdingTax.JXVZTaxType::"IB-MIS") then begin
                                JXVZWithholdScale.Reset();
                                JXVZWithholdScale.SetRange(JXVZTaxCode, JXVZWithholdingTax.JXVZTaxCode);
                                JXVZWithholdScale.SetRange(JXVZWitholdingCondition, JXVZVendorWithholdCondition.JXVZTaxConditionCode);
                                JXVZWithholdScale.SetRange(JXVZTo, 0);
                                if JXVZWithholdScale.FindFirst() then begin
                                    JXVZExportFilesTmp.Reset();
                                    JXVZExportFilesTmp.SetRange(Field1, Vendor."No.");
                                    if JXVZExportFilesTmp.IsEmpty() then begin
                                        JXVZExportFilesTmp.Init();
                                        PrKey += 1;
                                        JXVZExportFilesTmp.pKey := PrKey;
                                        JXVZExportFilesTmp.Field1 := Vendor."No.";
                                        JXVZExportFilesTmp.Field2 := Vendor.Name;
                                        JXVZExportFilesTmp.Field3 := Vendor."VAT Registration No.";
                                        case JXVZWithholdingTax.JXVZTaxType of
                                            JXVZWithholdingTax.JXVZTaxType::"IB-ARBA":
                                                JXVZExportFilesTmp.Field4 := Format(JXVZWithholdScale.JXVZSurplus);
                                            JXVZWithholdingTax.JXVZTaxType::"IB-CABA":
                                                JXVZExportFilesTmp.Field5 := Format(JXVZWithholdScale.JXVZSurplus);
                                            JXVZWithholdingTax.JXVZTaxType::"IB-MIS":
                                                JXVZExportFilesTmp.Field6 := Format(JXVZWithholdScale.JXVZSurplus);
                                        end;
                                        JXVZExportFilesTmp.Insert(false);
                                    end else begin
                                        case JXVZWithholdingTax.JXVZTaxType of
                                            JXVZWithholdingTax.JXVZTaxType::"IB-ARBA":
                                                JXVZExportFilesTmp.Field4 := Format(JXVZWithholdScale.JXVZSurplus);
                                            JXVZWithholdingTax.JXVZTaxType::"IB-CABA":
                                                JXVZExportFilesTmp.Field5 := Format(JXVZWithholdScale.JXVZSurplus);
                                            JXVZWithholdingTax.JXVZTaxType::"IB-MIS":
                                                JXVZExportFilesTmp.Field6 := Format(JXVZWithholdScale.JXVZSurplus);
                                        end;
                                        JXVZExportFilesTmp.Modify(false);
                                    end;
                                end;
                            end;
                    until JXVZVendorWithholdCondition.Next() = 0;
            end;
        }

        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) order(ascending);
            column(No; JXVZExportFilesTmp.Field1)
            { }
            column(Name; JXVZExportFilesTmp.Field2)
            { }
            column(VAT; JXVZExportFilesTmp.Field3)
            { }
            column(ARBA; JXVZExportFilesTmp.Field4)
            { }
            column(CABA; JXVZExportFilesTmp.Field5)
            { }
            column(MIS; JXVZExportFilesTmp.Field6)
            { }

            trigger OnPreDataItem()
            begin
                JXVZExportFilesTmp.Reset();
                SetRange(Number, 1, JXVZExportFilesTmp.Count());
            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    JXVZExportFilesTmp.FindFirst()
                else
                    JXVZExportFilesTmp.Next();
            end;
        }
    }

    var
        JXVZWithholdingTax: Record JXVZWithholdingTax;
        JXVZWithholdScale: Record JXVZWithholdScale;
        JXVZVendorWithholdCondition: Record JXVZVendorWithholdCondition;
        JXVZExportFilesTmp: Record JXVZExportFilesTmp temporary;
        PrKey: Integer;
}