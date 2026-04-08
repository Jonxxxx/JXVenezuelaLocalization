report 84111 JXVZCertWithholdingSUSS
{
    Caption = 'Withholding certificate SUSS', Comment = 'ESP=Certificado de retenciones SUSS';
    //UsageCategory = None;

    DefaultLayout = RDLC;
    RDLCLayout = 'src/ReportLayout/VZCertWithholdingSUSS.rdl';


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
            column(alicuota; aliquot)
            {
            }
            column(minimo; minimum)
            {
            }
            dataitem(JXVZHistPaymVoucherLine; JXVZHistPaymVoucherLine)
            {
                DataItemLink = JXVZPaymentOrderNo = FIELD(JXVZVoucherNo);
                DataItemTableView = SORTING(JXVZPaymentOrderNo, JXVZVoucherNo) ORDER(Ascending);
                /*column(Movimiento_Retenciones__Valor; JXVZWithholdLedgerEntry.Value)
                {
                }*/
                column(JXVZWithholdLedgerEntry_JXVZTaxCode; JXVZWithholdLedgerEntry.JXVZTaxCode)
                {
                }
                column(Acumulado; accumulated)
                {
                }
                column(VendorLedgerEntry_ExternalDocumentNo; VendorLedgerEntry."External Document No.")
                {
                }
                column(JXVZHistPaymVoucherLine_JXVZVoucherNo; JXVZHistPaymVoucherLine.JXVZVoucherNo)
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
                                end;
                            end;
                        end;

                end;
            }

            trigger OnAfterGetRecord()
            begin
                JXVZWithholdDetailEntry.Reset();
                JXVZWithholdDetailEntry.SetCurrentKey(JXVZWitholdingNo, JXVZTaxCode, JXVZRegime);
                JXVZWithholdDetailEntry.SetRange(JXVZWithholdDetailEntry.JXVZWitholdingNo, JXVZWithholdLedgerEntry.JXVZWitholdingNo);
                if JXVZWithholdDetailEntry.FindFirst() then
                    Description := JXVZWithholdDetailEntry.JXVZDescription;

                aliquot := JXVZWithholdLedgerEntry."JXVZWitholding%";
                minimum := JXVZWithholdLedgerEntry.JXVZMinimumWitholding;

                Vendor.Reset();
                Vendor.SetCurrentKey("No.");
                Vendor.SetRange("No.", JXVZVendorCode);
                if Vendor.FindFirst() then;
            end;

            trigger OnPreDataItem()
            begin
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
}

