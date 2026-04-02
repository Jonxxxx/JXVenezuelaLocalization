report 84123 JXVZWithholdIIBBByCust
{
    UsageCategory = None;
    ApplicationArea = All;
    caption = 'Detalle percepciones IIBB clientes', Comment = 'ESP=Percepciones IIBB clientes';
    DefaultLayout = RDLC;
    RDLCLayout = 'ReportLayout/JXVZWithholdIIBBByCust.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.") order(ascending);
            RequestFilterFields = "No.", "Gen. Bus. Posting Group";

            trigger OnAfterGetRecord()
            begin
                TaxGroup.Reset();
                TaxGroup.SetFilter(Code, '%1|%2', 'IVA 21%', 'IVA21%');//Always find 21%
                if TaxGroup.FindFirst() then;

                TaxArea.Reset();
                TaxArea.SetRange(Code, Customer."Tax Area Code");
                if TaxArea.FindFirst() then begin
                    TaxAreaLine.Reset();
                    TaxAreaLine.SetRange("Tax Area", TaxArea.Code);
                    if TaxAreaLine.FindSet() then
                        repeat
                            TaxJurisdiction.Reset();
                            TaxJurisdiction.SetRange(Code, TaxAreaLine."Tax Jurisdiction Code");
                            TaxJurisdiction.SetRange(JXVZTaxType, TaxJurisdiction.JXVZTaxType::GrossIncome);
                            if TaxJurisdiction.FindFirst() then begin
                                TaxDetail.Reset();
                                TaxDetail.SetRange("Tax Jurisdiction Code", TaxJurisdiction.Code);
                                TaxDetail.SetRange("Tax Group Code", TaxGroup.Code);
                                if TaxDetail.FindFirst() then begin
                                    JXVZExportFilesTmp.Reset();
                                    JXVZExportFilesTmp.SetRange(Field1, Customer."No.");
                                    if JXVZExportFilesTmp.IsEmpty() then begin
                                        JXVZExportFilesTmp.Init();
                                        PrKey += 1;
                                        JXVZExportFilesTmp.pKey := PrKey;
                                        JXVZExportFilesTmp.Field1 := Customer."No.";
                                        JXVZExportFilesTmp.Field2 := Customer.Name;
                                        JXVZExportFilesTmp.Field3 := Customer."VAT Registration No.";
                                        case TaxJurisdiction.JXVZVAType of
                                            TaxJurisdiction.JXVZVAType::ARBA:
                                                JXVZExportFilesTmp.Field4 := Format(TaxDetail."Tax Above Maximum");
                                            TaxJurisdiction.JXVZVAType::CABA:
                                                JXVZExportFilesTmp.Field5 := Format(TaxDetail."Tax Above Maximum");
                                            TaxJurisdiction.JXVZVAType::MISIONES:
                                                JXVZExportFilesTmp.Field6 := Format(TaxDetail."Tax Above Maximum");
                                        end;
                                        JXVZExportFilesTmp.Insert(false);
                                    end else begin
                                        case TaxJurisdiction.JXVZVAType of
                                            TaxJurisdiction.JXVZVAType::ARBA:
                                                JXVZExportFilesTmp.Field4 := Format(TaxDetail."Tax Above Maximum");
                                            TaxJurisdiction.JXVZVAType::CABA:
                                                JXVZExportFilesTmp.Field5 := Format(TaxDetail."Tax Above Maximum");
                                            TaxJurisdiction.JXVZVAType::MISIONES:
                                                JXVZExportFilesTmp.Field6 := Format(TaxDetail."Tax Above Maximum");
                                        end;
                                        JXVZExportFilesTmp.Modify(false);
                                    end;
                                end;
                            end;
                        until TaxAreaLine.Next() = 0;
                end;
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
        TaxJurisdiction: Record "Tax Jurisdiction";
        TaxArea: Record "Tax Area";
        TaxAreaLine: Record "Tax Area Line";
        TaxGroup: Record "Tax Group";
        TaxDetail: Record "Tax Detail";
        JXVZExportFilesTmp: Record JXVZExportFilesTmp temporary;
        PrKey: Integer;
}