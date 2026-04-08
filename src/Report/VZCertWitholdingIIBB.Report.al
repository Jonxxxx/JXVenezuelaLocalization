report 84109 JXVZCertWitholdingIIBB
{
    Caption = 'IIBB withholding certificate', Comment = 'ESP=Certificado de retenciones IIBB';
    //UsageCategory = None;

    DefaultLayout = RDLC;
    RDLCLayout = 'ReportLayout/VZCertWitholdingIIBB.rdl';

    dataset
    {
        dataitem(JXVZWithholdLedgerEntry; JXVZWithholdLedgerEntry)
        {
            DataItemTableView = SORTING(JXVZNo);
            RequestFilterFields = JXVZNo;

            column(JXVZWithholdLedgerEntry_JXVZWitholdingNo; JXVZWithholdLedgerEntry.JXVZWitholdingNo)
            {
            }
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
            column(CompanyInformation_WithholdingAgentNo; '')
            {
            }
            column(JXVZWithholdLedgerEntry_JXVZProvinceCode; JXVZWithholdLedgerEntry.JXVZProvinceCode)
            {
            }
            column(Vendor_Address; Vendor.Address)
            {
            }
            column(Vendor_Name; Vendor.Name)
            {
            }
            column(Vendor_VATRegistrationNo; Vendor."VAT Registration No.")
            {
            }
            column(Vendor_JXVZWitholdsNo; '')
            {
            }
            column(JXVZWithholdLedgerEntry_JXVZWitholdingCertificateNo; JXVZWithholdLedgerEntry.JXVZWitholdingCertificateNo)
            {
            }
            column(JXVZWithholdLedgerEntry_JXVZWitholdingDate; JXVZWithholdLedgerEntry.JXVZWitholdingDate)
            {
            }
            column(CompanyInformation_Province; CompanyInformation.JXVZProvince)
            {
            }
            column(CompanyInformation_JXVZProvince; CompanyInformation.JXVZProvince)
            {
            }
            column(Description; Description)
            {
            }
            column(JXVZWithholdLedgerEntry_JXVZBase; JXVZWithholdLedgerEntry.JXVZBase)
            {
            }
            column(JXVZWithholdLedgerEntry_JXVZWitholdingAmount; JXVZWithholdLedgerEntry.JXVZWitholdingAmount)
            {
            }
            column(JXVZWithholdLedgerEntry_JXVZWitholdingPercentage; JXVZWithholdLedgerEntry."JXVZWitholding%")
            {
            }
            column(JXVZWithholdLedgerEntry_JXVZMinimumWitholding; JXVZWithholdLedgerEntry.JXVZMinimumWitholding)
            {
            }
            column(gblProvincia; gblProvincia)
            {
            }
            column(Jurisdiction; Jurisdiction)
            {
            }
            dataitem(JXVZHistPaymVoucherLine; JXVZHistPaymVoucherLine)
            {
                DataItemLink = JXVZPaymentOrderNo = FIELD(JXVZVoucherNo);
                DataItemTableView = SORTING(JXVZPaymentOrderNo, JXVZVoucherNo) ORDER(Ascending);
                column(JXVZWithholdLedgerEntry_JXVZTaxCode; JXVZWithholdLedgerEntry.JXVZTaxCode)
                {
                }
                column(Acumulado; Acumulado)
                {
                }
                column(VendorLedgerEntry_ExternalDocumentNo; VendorLedgerEntry."External Document No.")
                {
                }

                column(JXVZHistPaymVoucherLine_JXVZVoucherNo; JXVZHistPaymVoucherLine.JXVZVoucherNo)
                {
                }
                column(JXVZHistPaymVoucherLine_JXVZPaymentOrderNo; JXVZHistPaymVoucherLine.JXVZPaymentOrderNo)
                {
                }
                trigger OnAfterGetRecord()
                var
                    JXVZWithholdLedgerEntryByDoc: Record JXVZWithholdLedgerEntryByDoc;
                begin
                    Acumulado := 0;
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
                                Acumulado += JXVZWithholdLedgerEntryByDoc.JXVZBase;
                            until JXVZWithholdLedgerEntryByDoc.Next() = 0;
                        end else begin
                            PurchInvHeader.Reset();
                            PurchInvHeader.SetRange("No.", VendorLedgerEntry."Document No.");
                            if PurchInvHeader.FindFirst() then begin
                                PurchInvHeader.CalcFields(Amount);
                                Acumulado := PurchInvHeader.Amount;
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
                                    Acumulado += abs(JXVZWithholdLedgerEntryByDoc.JXVZBase) * -1;
                                until JXVZWithholdLedgerEntryByDoc.Next() = 0;
                            end else begin
                                PurchCrMemoHdr.Reset();
                                PurchCrMemoHdr.SetRange("No.", VendorLedgerEntry."Document No.");
                                if PurchCrMemoHdr.FindSet() then begin
                                    PurchCrMemoHdr.CalcFields(Amount);
                                    Acumulado := abs(PurchCrMemoHdr.Amount) * -1; //Siempre en negativo
                                end;
                            end;
                        end;
                end;
            }

            trigger OnAfterGetRecord()
            var
                JXVZWithholdingTax: Record JXVZWithholdingTax;
            begin
                CompanyInformation.Reset();
                CompanyInformation.Get();

                JXVZWithholdDetailEntry.Reset();
                JXVZWithholdDetailEntry.SetCurrentKey(JXVZWitholdingNo, JXVZTaxCode, JXVZRegime);
                JXVZWithholdDetailEntry.SetRange(JXVZWithholdDetailEntry.JXVZWitholdingNo, JXVZWithholdLedgerEntry.JXVZWitholdingNo);
                if JXVZWithholdDetailEntry.FindFirst() then
                    Description := JXVZWithholdDetailEntry.JXVZDescription;

                Jurisdiction := '';
                /*
                JXVZProvince.Reset();
                JXVZProvince.SetCurrentKey(JXVZProvince.JXVZCode);
                JXVZProvince.SetRange(JXVZProvince.JXVZCode, JXVZWithholdLedgerEntry.JXVZProvinceCode);
                if JXVZProvince.FindFirst() then
                    Jurisdiction := JXVZProvince.JXVZAfipCode
                else begin
                    JXVZWithholdingTax.Reset();
                    JXVZWithholdingTax.SetRange(JXVZTaxCode, JXVZWithholdDetailEntry.JXVZTaxCode);
                    if JXVZWithholdingTax.FindFirst() then
                        case JXVZWithholdingTax.JXVZTaxType of
                            JXVZWithholdingTax.JXVZTaxType::"IB-Municipal":
                                Jurisdiction := '901';
                            JXVZWithholdingTax.JXVZTaxType::"IB-ISLR":
                                Jurisdiction := '902';
                            JXVZWithholdingTax.JXVZTaxType::Otros:
                                case JXVZWithholdingTax.JXVZTaxCode of
                                    'IB-CAT':
                                        Jurisdiction := '903';
                                    'IB-CBA':
                                        Jurisdiction := '904';
                                    'IB-CHA':
                                        Jurisdiction := '906';
                                    'IB-CHU':
                                        Jurisdiction := '907';
                                    'IB-COR':
                                        Jurisdiction := '905';
                                    'IB-ERIO':
                                        Jurisdiction := '908';
                                    'IB-FOR':
                                        Jurisdiction := '909';
                                    'IB-JUJ':
                                        Jurisdiction := '910';
                                    'IB-LP':
                                        Jurisdiction := '911';
                                    'IB-LR':
                                        Jurisdiction := '912';
                                    'IB-MEN':
                                        Jurisdiction := '913';
                                    'IB-MIS':
                                        Jurisdiction := '914';
                                    'IB-NQN':
                                        Jurisdiction := '915';
                                    'IB-RN':
                                        Jurisdiction := '916';
                                    'IB-SAL':
                                        Jurisdiction := '917';
                                    'IB-SC':
                                        Jurisdiction := '920';
                                    'IB-SDE':
                                        Jurisdiction := '922';
                                    'IB-SFE':
                                        Jurisdiction := '921';
                                    'IB-SJ':
                                        Jurisdiction := '918';
                                    'IB-SL':
                                        Jurisdiction := '919';
                                    'IB-TDF':
                                        Jurisdiction := '923';
                                    'IB-TUC':
                                        Jurisdiction := '924';
                                end;
                            else
                                Jurisdiction := '';
                        end;
                end;
                */

                gblProvincia := Jurisdiction;

                Vendor.Reset();
                Vendor.SetCurrentKey("No.");
                Vendor.SetRange("No.", JXVZVendorCode);
                if Vendor.FindFirst() then;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInformation.Reset();
                CompanyInformation.Get();
                ok := CompanyInformation.FindFirst();
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        CompanyInformation: Record "Company Information";
        Vendor: Record Vendor;
        JXVZWithholdDetailEntry: Record JXVZWithholdDetailEntry;
        JXVZProvince: Record JXVZProvince;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        ok: Boolean;
        Description: Text[100];
        Acumulado: Decimal;
        gblProvincia: Text[50];
        Jurisdiction: Text[10];
}