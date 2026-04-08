report 84110 JXVZCertWitholdingGan
{
    Caption = 'Profit withholding or vat certificate', Comment = 'ESP=Certificado de retenciones ganancias | IVA';
    //UsageCategory = None;

    DefaultLayout = RDLC;
    RDLCLayout = 'ReportLayout/VZCertWitholdingGan.rdl';

    dataset
    {
        dataitem(JXVZWithholdLedgerEntry; JXVZWithholdLedgerEntry)
        {
            DataItemTableView = SORTING(JXVZNo);
            RequestFilterFields = JXVZNo;
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(CompanyInformation_Address; CompanyInformation.Address)
            {
            }
            column(CompanyInformation_Address2; CompanyInformation."Address 2")
            {
            }
            column(CompanyInformation_VATRegistrationNo; CompanyInformation."VAT Registration No.")
            {
            }
            column(CompanyInformation_JXVZWithholdingAgentNo; '')
            {
            }
            column(CompanyInformation_JXVZProvince; CompanyInformation.JXVZProvince)
            {
            }
            column(Vendor_JXVZWitholdsNo; '')
            {
            }
            column(Vendor_VATRegistrationNo; Vendor."VAT Registration No.")
            {
            }
            column(Vendor_Address; Vendor.Address)
            {
            }
            column(Vendor_Name; Vendor.Name)
            {
            }
            column(JXVZWithholdLedgerEntry_JXVZWitholdingCertificateNo; JXVZWithholdLedgerEntry.JXVZWitholdingCertificateNo)
            {
            }
            column(JXVZWithholdLedgerEntry_JXVZWitholdingDate; JXVZWithholdLedgerEntry.JXVZWitholdingDate)
            {
            }
            column(Description; Description)
            {
            }
            column(JXVZWithholdLedgerEntry_JXVZCalculationBase; JXVZWithholdLedgerEntry.JXVZCalculationBase)
            {
            }
            column(JXVZWithholdLedgerEntry_JXVZWitholdingAmount; JXVZWithholdLedgerEntry.JXVZWitholdingAmount)
            {
            }
            column(JXVZWithholdLedgerEntry_JXVZWitholdingPercent; "JXVZWitholding%Calc")
            {
            }
            column(JXVZWithholdLedgerEntry_JXVZMinimumWitholding; JXVZWithholdLedgerEntry.JXVZMinimumWitholding)
            {
            }
            column(ReportTitleMan; ReportTitle)
            {
            }
            dataitem(JXVZHistPaymVoucherLine; JXVZHistPaymVoucherLine)
            {
                DataItemLink = JXVZPaymentOrderNo = FIELD(JXVZVoucherNo);
                DataItemTableView = SORTING(JXVZPaymentOrderNo, JXVZVoucherNo) ORDER(Ascending);
                column(Movimiento_Retenciones__Valor; JXVZWithholdLedgerEntry.JXVZTaxCode)
                {
                }
                column(Acumulado; accumulated)
                {
                }
                column(Hist_Lin_Comp_OPago__Nro_Comprobante_; JXVZPaymentOrderNo)
                {
                }
                column(movfac__External_Document_No__; VendorLedgerEntry."External Document No.")
                {
                }
                column(Posted_PO_Voucher_Line_Voucher_No_; JXVZVoucherNo)
                {
                }

                trigger OnAfterGetRecord()
                var
                    JXVZWithholdLedgerEntryByDoc: Record JXVZWithholdLedgerEntryByDoc;
                begin
                    accumulated := 0;
                    VendorLedgerEntry.Reset();
                    VendorLedgerEntry.SetCurrentKey("Entry No.");
                    VendorLedgerEntry.SetRange(VendorLedgerEntry."Document No.", JXVZHistPaymVoucherLine.JXVZVoucherNo);
                    if VendorLedgerEntry.FindFirst() then;

                    if (JXVZHistPaymVoucherLine.JXVZDocumentType = JXVZHistPaymVoucherLine.JXVZDocumentType::Factura) OR
                       (JXVZHistPaymVoucherLine.JXVZDocumentType = JXVZHistPaymVoucherLine.JXVZDocumentType::"Nota Débito") then begin
                        JXVZWithholdLedgerEntryByDoc.Reset();
                        JXVZWithholdLedgerEntryByDoc.SetRange(JXVZPostedPaymentJournal, JXVZWithholdLedgerEntry.JXVZVoucherNo);
                        JXVZWithholdLedgerEntryByDoc.SetRange("Invoice No.", VendorLedgerEntry."Document No.");
                        JXVZWithholdLedgerEntryByDoc.SetRange(JXVZWitholdingNo, JXVZWithholdLedgerEntry.JXVZWitholdingNo);
                        if JXVZWithholdLedgerEntryByDoc.FindSet() then begin
                            repeat
                                accumulated += JXVZWithholdLedgerEntryByDoc.JXVZBase;
                            until JXVZWithholdLedgerEntryByDoc.Next() = 0;
                        end else begin
                            PurchInvHeader.Reset();
                            PurchInvHeader.SetRange("No.", VendorLedgerEntry."Document No.");
                            if PurchInvHeader.FindFirst() then begin
                                PurchInvHeader.CalcFields(Amount);
                                accumulated := PurchInvHeader.Amount;
                                if (PurchInvHeader."Currency Code" <> '') then
                                    accumulated := round(accumulated / PurchInvHeader."Currency Factor", 0.01);
                            end;
                        end;
                    end else
                        if JXVZHistPaymVoucherLine.JXVZDocumentType = JXVZHistPaymVoucherLine.JXVZDocumentType::"Nota d/c" then begin
                            JXVZWithholdLedgerEntryByDoc.Reset();
                            JXVZWithholdLedgerEntryByDoc.SetRange(JXVZPostedPaymentJournal, JXVZWithholdLedgerEntry.JXVZVoucherNo);
                            JXVZWithholdLedgerEntryByDoc.SetRange("Invoice No.", VendorLedgerEntry."Document No.");
                            JXVZWithholdLedgerEntryByDoc.SetRange(JXVZWitholdingNo, JXVZWithholdLedgerEntry.JXVZWitholdingNo);
                            if JXVZWithholdLedgerEntryByDoc.FindSet() then begin
                                repeat
                                    accumulated += abs(JXVZWithholdLedgerEntryByDoc.JXVZBase) * -1;
                                until JXVZWithholdLedgerEntryByDoc.Next() = 0;
                            end else begin
                                PurchCrMemoHdr.Reset();
                                PurchCrMemoHdr.SetRange("No.", VendorLedgerEntry."Document No.");
                                if PurchCrMemoHdr.FindSet() then begin
                                    PurchCrMemoHdr.CalcFields(Amount);
                                    accumulated := abs(PurchCrMemoHdr.Amount) * -1; //Siempre en negativo

                                    if (PurchCrMemoHdr."Currency Code" <> '') then
                                        accumulated := round(accumulated / PurchCrMemoHdr."Currency Factor", 0.01);
                                end;
                            end;
                        end;

                end;
            }

            trigger OnAfterGetRecord()
            var
                JXVZVendorWithholdCondition: Record JXVZVendorWithholdCondition;
                JXVZWithholdScale: Record JXVZWithholdScale;
                JXVZWithholdingTax: Record JXVZWithholdingTax;
            begin
                if ReportTitle = '' then begin
                    JXVZWithholdingTax.Reset();
                    JXVZWithholdingTax.SetRange(JXVZTaxCode, JXVZWithholdLedgerEntry.JXVZTaxCode);
                    if JXVZWithholdingTax.FindFirst() then
                        if JXVZWithholdingTax.JXVZTaxType = JXVZWithholdingTax.JXVZTaxType::IVA then
                            ReportTitle := 'CERTIFICADO DE RETENCION IVA'
                        else
                            ReportTitle := 'CERTIFICADO DE RETENCION GANANCIAS';
                end;

                JXVZWithholdDetailEntry.Reset();
                JXVZWithholdDetailEntry.SetCurrentKey(JXVZWitholdingNo, JXVZTaxCode, JXVZRegime);
                JXVZWithholdDetailEntry.SetRange(JXVZWithholdDetailEntry.JXVZWitholdingNo, JXVZWithholdLedgerEntry.JXVZWitholdingNo);
                if JXVZWithholdDetailEntry.FindFirst() then
                    Description := JXVZWithholdDetailEntry.JXVZRegime + ' - ' + JXVZWithholdDetailEntry.JXVZDescription;

                clear("JXVZWitholding%Calc");

                Vendor.Reset();
                Vendor.SetCurrentKey("No.");
                Vendor.SetRange("No.", JXVZVendorCode);
                if Vendor.FindFirst() then begin
                    JXVZVendorWithholdCondition.Reset();
                    JXVZVendorWithholdCondition.SetRange(JXVZVendorCode, vendor."No.");
                    JXVZVendorWithholdCondition.SetRange(JXVZTaxCode, JXVZWithholdLedgerEntry.JXVZTaxCode);
                    if JXVZVendorWithholdCondition.FindFirst() then begin
                        JXVZWithholdScale.Reset();
                        JXVZWithholdScale.SetRange(JXVZWithholdScale.JXVZScaleCode, JXVZWithholdLedgerEntry.JXVZScaleCode);
                        JXVZWithholdScale.SetRange(JXVZWithholdScale.JXVZWitholdingCondition, JXVZVendorWithholdCondition.JXVZTaxConditionCode);
                        JXVZWithholdScale.SetRange(JXVZWithholdScale.JXVZTaxCode, JXVZWithholdLedgerEntry.JXVZTaxCode);
                        if JXVZWithholdScale.FindSet() then
                            repeat
                                if JXVZWithholdScale.JXVZTo = 0 then begin
                                    if (JXVZWithholdScale.JXVZFrom <= JXVZWithholdLedgerEntry.JXVZCalculationBase) then begin
                                        "JXVZWitholding%Calc" := JXVZWithholdScale.JXVZSurplus;
                                    end;
                                end else
                                    if (JXVZWithholdScale.JXVZFrom <= JXVZWithholdLedgerEntry.JXVZCalculationBase) and
                                        (JXVZWithholdScale.JXVZTo > JXVZWithholdLedgerEntry.JXVZCalculationBase) then
                                        "JXVZWitholding%Calc" := JXVZWithholdScale.JXVZSurplus;
                            until JXVZWithholdScale.Next() = 0;
                    end;
                end;

                if ("JXVZWitholding%Calc" = 0) then
                    "JXVZWitholding%Calc" := JXVZWithholdLedgerEntry."JXVZWitholding%";
            end;

            trigger OnPreDataItem()
            begin
                SetFilter(JXVZTaxCode, '<>%1', '');
                ok := CompanyInformation.FindFirst();
            end;
        }
    }

    var
        CompanyInformation: Record "Company Information";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        Vendor: Record Vendor;
        JXVZWithholdDetailEntry: Record JXVZWithholdDetailEntry;
        //JXVZProvince: Record JXVZProvince;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        ok: Boolean;
        Description: Text[100];
        aliquot: Decimal;
        minimum: Decimal;
        accumulated: Decimal;
        "JXVZWitholding%Calc": Decimal;
        ReportTitle: Text;
}

