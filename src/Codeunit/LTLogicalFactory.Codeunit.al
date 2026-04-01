codeunit 84102 JXVZLogicalFactory
{
    trigger OnRun()
    begin

    end;

    //Generate receipt record
    procedure GenerateReceiptRecord(_GenJnlLine: Record "Gen. Journal Line")
    var
        JXVZHistoryReceiptHeader: Record JXVZHistoryReceiptHeader;
        JXVZPostedReceiptDocuments: Record "JXVZHistReceiptVoucherLine";
        JXVZPostedReceiptValues: Record JXVZHistReceiptValueLine;
        GenJnlBatch: Record "Gen. Journal Batch";
        Customer: Record Customer;
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCRMemoHeader: Record "Sales Cr.Memo Header";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        JXVZPaymentSetup: Record JXVZPaymentSetup;
        JXVZLogicalFactory: Codeunit JXVZLogicalFactory;
        LineVoucher: Integer;
        CheckNo: Integer;
        duplicatedCheckErr: Label 'The Check %1 already exists for the bank %2', Comment = 'Error for duplicated check';
    begin
        //Post Venezuela customer receipt
        GenJnlBatch.Reset();
        GenJnlBatch.SetRange("Journal Template Name", _GenJnlLine."Journal Template Name");
        GenJnlBatch.SetRange(Name, _GenJnlLine."Journal Batch Name");
        GenJnlBatch.SetRange(JXVZReceipt, true);//Receipt Gestion
        if not (GenJnlBatch.IsEmpty()) then begin
            if (_GenJnlLine."Account Type" = _GenJnlLine."Account Type"::Customer) and
               (_GenJnlLine.JXVZAccountPayment = false) then begin
                //Check bal. account no.
                _GenJnlLine.TestField("Bal. Account No.", '');

                //Insert header
                JXVZHistoryReceiptHeader.Reset();
                JXVZHistoryReceiptHeader.SetRange(JXVZReceiptNo, _GenJnlLine."Document No.");
                if not JXVZHistoryReceiptHeader.FindFirst() then begin
                    Customer.Reset();
                    Customer.SetRange("No.", _GenJnlLine."Account No.");
                    if (Customer.FindFirst()) then;

                    JXVZHistoryReceiptHeader.Init();
                    JXVZHistoryReceiptHeader.JXVZReceiptNo := _GenJnlLine."Document No.";
                    JXVZHistoryReceiptHeader.JXVZPostingDate := _GenJnlLine."Posting Date";
                    JXVZHistoryReceiptHeader.JXVZDocumentDate := _GenJnlLine."Document Date";
                    JXVZHistoryReceiptHeader.JXVZCustomerNo := _GenJnlLine."Account No.";
                    JXVZHistoryReceiptHeader.JXVZName := Customer.Name;
                    JXVZHistoryReceiptHeader.JXVZCuit := Customer."VAT Registration No.";
                    JXVZHistoryReceiptHeader.JXVZAddress := Customer.Address;
                    JXVZHistoryReceiptHeader.JXVZUserId := FORMAT(UserId());
                    JXVZHistoryReceiptHeader.JXVZStatus := JXVZHistoryReceiptHeader.JXVZStatus::Registered;
                    JXVZHistoryReceiptHeader.Insert();//Create receipt header

                    //Find and insert movement to applied
                    if _GenJnlLine."Applies-to ID" <> '' then begin
                        CustLedgerEntry.Reset();
                        CustLedgerEntry.SetRange("Applies-to ID", _GenJnlLine."Applies-to ID");
                        if CustLedgerEntry.FindSet() then
                            repeat
                                //if CustLedgerEntry."Customer No." = JXVZHistoryReceiptHeader.JXVZCustomerNo then begin
                                JXVZPostedReceiptDocuments.Init();
                                JXVZPostedReceiptDocuments.JXVZReceiptNo := _GenJnlLine."Document No.";
                                JXVZPostedReceiptDocuments.JXVZVoucherNo := CustLedgerEntry."Document No.";
                                JXVZPostedReceiptDocuments.JXVZAmount := abs(CustLedgerEntry."Amount to Apply");
                                JXVZPostedReceiptDocuments.JXVZCancelled := JXVZPostedReceiptDocuments.JXVZAmount;
                                JXVZPostedReceiptDocuments.JXVZCustomer := _GenJnlLine."Account No.";
                                JXVZPostedReceiptDocuments.JXVZDate := CustLedgerEntry."Posting Date";
                                if (JXVZLogicalFactory.IsDebitMemoSales(CustLedgerEntry."Document No.")) then
                                    JXVZPostedReceiptDocuments.JXVZDocumentType := JXVZPostedReceiptDocuments.JXVZDocumentType::"Nota Débito"
                                else
                                    JXVZPostedReceiptDocuments.JXVZDocumentType := CustLedgerEntry."Document Type";

                                JXVZPostedReceiptDocuments.JXVZCurrencyCode := CustLedgerEntry."Currency Code";
                                JXVZPostedReceiptDocuments.JXVZCurrencyFactor := _GenJnlLine."Currency Factor";
                                JXVZPostedReceiptDocuments.JXVZEntryNo := JXVZPostedReceiptDocuments.GetLastEntryNo();
                                JXVZPostedReceiptDocuments.Insert();
                            //end;
                            until CustLedgerEntry.Next() = 0;
                    end;
                    //Find and insert movement to applied end
                end;
                //Insert header end

                //Applies documents                
                if (_GenJnlLine."Applies-to Doc. No." <> '') then begin
                    JXVZPostedReceiptDocuments.Init();
                    JXVZPostedReceiptDocuments.JXVZReceiptNo := _GenJnlLine."Document No.";
                    JXVZPostedReceiptDocuments.JXVZVoucherNo := _GenJnlLine."Applies-to Doc. No.";
                    JXVZPostedReceiptDocuments.JXVZAmount := abs(_GenJnlLine.Amount);
                    JXVZPostedReceiptDocuments.JXVZCancelled := JXVZPostedReceiptDocuments.JXVZAmount;
                    JXVZPostedReceiptDocuments.JXVZCustomer := _GenJnlLine."Account No.";

                    case _GenJnlLine."Applies-to Doc. Type" of
                        _GenJnlLine."Applies-to Doc. Type"::Invoice:
                            begin
                                SalesInvHeader.Reset();
                                SalesInvHeader.SetRange("No.", _GenJnlLine."Applies-to Doc. No.");
                                if SalesInvHeader.FindFirst() then
                                    JXVZPostedReceiptDocuments.JXVZDate := SalesInvHeader."Posting Date"
                            end;

                        _GenJnlLine."Applies-to Doc. Type"::"Credit Memo":
                            begin
                                SalesCRMemoHeader.Reset();
                                SalesCRMemoHeader.SetRange("No.", _GenJnlLine."Applies-to Doc. No.");
                                if SalesCRMemoHeader.FindFirst() then
                                    JXVZPostedReceiptDocuments.JXVZDate := SalesCRMemoHeader."Posting Date"
                            end;

                        else
                            JXVZPostedReceiptDocuments.JXVZDate := _GenJnlLine."Posting Date";
                    end;

                    if (JXVZLogicalFactory.IsDebitMemoSales(_GenJnlLine."Applies-to Doc. No.")) then
                        JXVZPostedReceiptDocuments.JXVZDocumentType := JXVZPostedReceiptDocuments.JXVZDocumentType::"Nota Débito"
                    else
                        JXVZPostedReceiptDocuments.JXVZDocumentType := _GenJnlLine."Applies-to Doc. Type";

                    JXVZPostedReceiptDocuments.JXVZCurrencyCode := _GenJnlLine."Currency Code";
                    JXVZPostedReceiptDocuments.JXVZCurrencyFactor := _GenJnlLine."Currency Factor";
                    JXVZPostedReceiptDocuments.Insert();
                end;
                //Applies documents end
            end;

            //Values lines
            if ((_GenJnlLine."Account Type" = _GenJnlLine."Account Type"::"G/L Account") OR
                (_GenJnlLine."Account Type" = _GenJnlLine."Account Type"::"Bank Account") OR
                ((_GenJnlLine."Account Type" = _GenJnlLine."Account Type"::Customer) and
                (_GenJnlLine.JXVZAccountPayment = true))) then begin
                JXVZPostedReceiptValues.RESET();
                JXVZPostedReceiptValues.SETRANGE(JXVZReceiptNo, _GenJnlLine."Document No.");
                if (JXVZPostedReceiptValues.FindLast()) then
                    LineVoucher := JXVZPostedReceiptValues.JXVZLineNo + 1
                else
                    LineVoucher := 1;

                JXVZPostedReceiptValues.Init();
                JXVZPostedReceiptValues.JXVZReceiptNo := _GenJnlLine."Document No.";
                JXVZPostedReceiptValues.JXVZAccount := _GenJnlLine."Account No.";
                JXVZPostedReceiptValues.JXVZDescription := _GenJnlLine.Description;
                JXVZPostedReceiptValues.JXVZAmount := _GenJnlLine.Amount;
                JXVZPostedReceiptValues.JXVZCurrencyCode := _GenJnlLine."Currency Code";
                JXVZPostedReceiptValues.JXVZCurrencyFactor := _GenJnlLine."Currency Factor";
                JXVZPostedReceiptValues.JXVZLineNo := LineVoucher;
                JXVZPostedReceiptValues.JXVZValueNo := _GenJnlLine.JXVZValueNoValue;
                JXVZPostedReceiptValues.JXVZDocumentDate := _GenJnlLine.JXVZDocumentDateValue;
                JXVZPostedReceiptValues.JXVZToDate := _GenJnlLine.JXVZToDateValue;
                JXVZPostedReceiptValues.JXVZAcreditationDate := _GenJnlLine.JXVZAcreditationDateValue;
                JXVZPostedReceiptValues.JXVZEntity := _GenJnlLine.JXVZEntityValue;
                JXVZPostedReceiptValues.JXVZAccount := _GenJnlLine."Account No.";
                JXVZPostedReceiptValues.Insert();
            end;
            //Values lines end
        end;
        //Post Venezuela customer receipt end
    end;
    //Generate receipt record end

    //Check if FC or ND Sales
    procedure IsDebitMemoSales(_Code: code[20]): Boolean
    //True  = Debit memo
    //False = Invoice
    var
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        SalesInvHeader.Reset();
        SalesInvHeader.SetRange("No.", _Code);
        SalesInvHeader.SetRange(JXInvoiceType, SalesInvHeader.JXInvoiceType::DebitMemo);
        if not SalesInvHeader.IsEmpty() then
            exit(true)
        else
            exit(false);
    end;
    //Check if FC or ND Sales end    

    //Generate Payment order record
    procedure GeneratePaymentOrderRecord(_GenJnlLine: Record "Gen. Journal Line")
    var
        JXVZHistoryPaymentOrder: Record JXVZHistoryPaymOrder;
        JXVZHistoryPaymentDocument: Record JXVZHistPaymVoucherLine;
        JXVZHistoryPaymentValues: Record JXVZHistPaymValueLine;
        GenJnlBatch: Record "Gen. Journal Batch";
        Vendor: Record Vendor;
        JXVZWithholdLedgerEntry: Record JXVZWithholdLedgerEntry;
        JXVZWithholdDetailEntry: Record JXVZWithholdDetailEntry;
        JXVZWithholdScale: Record JXVZWithholdScale;
        JXVZWithholdingTax: Record JXVZWithholdingTax;
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        JXVZWithholdTaxCondition: Record JXVZWithholdTaxCondition;
        NoSeriesManagement: Codeunit "No. Series";
        LineVoucher: Integer;
        EntryNumber: Integer;
        "Witholding%": Decimal;
    begin
        GenJnlBatch.Reset();
        GenJnlBatch.SetRange("Journal Template Name", _GenJnlLine."Journal Template Name");
        GenJnlBatch.SetRange(Name, _GenJnlLine."Journal Batch Name");
        GenJnlBatch.SetRange(JXVZPaymOrder, true);//Payem order Gestion
        if not (GenJnlBatch.IsEmpty()) then begin
            if (_GenJnlLine."Account Type" = _GenJnlLine."Account Type"::Vendor) and
                (_GenJnlLine.JXVZAccountPayment = false) then begin
                //Check bal. account no.
                _GenJnlLine.TestField("Bal. Account No.", '');

                //Check History Order No. Sequence
                ControlPaymentControlSecuence(_GenJnlLine);

                //Insert header
                JXVZHistoryPaymentOrder.Reset();
                JXVZHistoryPaymentOrder.SetRange(JXVZHistoryPaymentOrder.JXVZNo, _GenJnlLine."Document No.");
                JXVZHistoryPaymentOrder.SetRange(JXVZHistoryPaymentOrder.JXVZPostingDate, _GenJnlLine."Posting Date");
                if not JXVZHistoryPaymentOrder.FindFirst() then begin
                    //Check Account No. (Vendor)
                    _GenJnlLine.TestField("Account No.");

                    Vendor.Reset();
                    Vendor.SetRange("No.", _GenJnlLine."Account No.");
                    if (Vendor.FindFirst()) then;

                    JXVZHistoryPaymentOrder.Init();
                    JXVZHistoryPaymentOrder.JXVZNo := _GenJnlLine."Document No.";
                    JXVZHistoryPaymentOrder.JXVZPostingDate := _GenJnlLine."Posting Date";
                    JXVZHistoryPaymentOrder.JXVZDocumentDate := _GenJnlLine."Document Date";
                    JXVZHistoryPaymentOrder.JXVZVendorNo := _GenJnlLine."Account No.";
                    JXVZHistoryPaymentOrder.JXVZName := Vendor.Name;
                    JXVZHistoryPaymentOrder.JXVZCuit := Vendor."VAT Registration No.";
                    JXVZHistoryPaymentOrder.JXVZAddress := Vendor.Address;
                    JXVZHistoryPaymentOrder.JXVZUserID := UserId;
                    JXVZHistoryPaymentOrder.JXVZStatus := JXVZHistoryPaymentOrder.JXVZStatus::Registered;
                    JXVZHistoryPaymentOrder.JXVZConcept := _GenJnlLine."Payment Reference";

                    OnBeforeInsertHistPaymentOrder(JXVZHistoryPaymentOrder, _GenJnlLine);

                    JXVZHistoryPaymentOrder.Insert();//Create payment header

                    if _GenJnlLine."Applies-to ID" <> '' then begin
                        VendLedgerEntry.Reset();
                        VendLedgerEntry.SetRange("Applies-to ID", _GenJnlLine."Applies-to ID");
                        if VendLedgerEntry.FindSet() then
                            repeat
                                if JXVZHistoryPaymentOrder.JXVZVendorNo = VendLedgerEntry."Vendor No." then begin
                                    JXVZHistoryPaymentDocument.Init();
                                    JXVZHistoryPaymentDocument.JXVZPaymentOrderNo := _GenJnlLine."Document No.";
                                    JXVZHistoryPaymentDocument.JXVZVoucherNo := VendLedgerEntry."Document No.";
                                    JXVZHistoryPaymentDocument.JXVZAmount := abs(VendLedgerEntry."Amount to Apply");
                                    JXVZHistoryPaymentDocument.JXVZCancelledAmount := JXVZHistoryPaymentDocument.JXVZAmount;
                                    JXVZHistoryPaymentDocument.JXVZVendor := _GenJnlLine."Account No.";
                                    JXVZHistoryPaymentDocument.JXVZDate := VendLedgerEntry."Posting Date";
                                    if (IsDebitMemoPurch(VendLedgerEntry."Document No.")) then
                                        JXVZHistoryPaymentDocument.JXVZDocumentType := JXVZHistoryPaymentDocument.JXVZDocumentType::"Nota Débito"
                                    else
                                        JXVZHistoryPaymentDocument.JXVZDocumentType := VendLedgerEntry."Document Type";

                                    if JXVZHistoryPaymentDocument.JXVZDocumentType = JXVZHistoryPaymentDocument.JXVZDocumentType::Pago then
                                        if IsVendorPaymentAccount(VendLedgerEntry."Document No.", VendLedgerEntry."Amount to Apply") then begin
                                            JXVZHistoryPaymentDocument.JXVZAmount := JXVZHistoryPaymentDocument.JXVZAmount * -1;
                                            JXVZHistoryPaymentDocument.JXVZCancelledAmount := JXVZHistoryPaymentDocument.JXVZAmount;
                                        end;

                                    JXVZHistoryPaymentDocument.JXVZCurrencyCode := VendLedgerEntry."Currency Code";
                                    JXVZHistoryPaymentDocument.JXVZCurrencyFactor := _GenJnlLine."Currency Factor";
                                    JXVZHistoryPaymentDocument.Insert();
                                end;
                            until VendLedgerEntry.Next() = 0;
                    end;
                end;
                //Insert header end

                //Applies documents                
                if (_GenJnlLine."Applies-to Doc. No." <> '') then begin
                    JXVZHistoryPaymentDocument.Init();
                    JXVZHistoryPaymentDocument.JXVZPaymentOrderNo := _GenJnlLine."Document No.";
                    JXVZHistoryPaymentDocument.JXVZVoucherNo := _GenJnlLine."Applies-to Doc. No.";
                    JXVZHistoryPaymentDocument.JXVZAmount := abs(_GenJnlLine.Amount);
                    JXVZHistoryPaymentDocument.JXVZCancelledAmount := JXVZHistoryPaymentDocument.JXVZAmount;
                    JXVZHistoryPaymentDocument.JXVZVendor := _GenJnlLine."Account No.";
                    case _GenJnlLine."Applies-to Doc. Type" of
                        _GenJnlLine."Applies-to Doc. Type"::Invoice:
                            begin
                                PurchInvHeader.Reset();
                                PurchInvHeader.SetRange("No.", _GenJnlLine."Applies-to Doc. No.");
                                if PurchInvHeader.FindFirst() then
                                    JXVZHistoryPaymentDocument.JXVZDate := PurchInvHeader."Posting Date"
                            end;

                        _GenJnlLine."Applies-to Doc. Type"::"Credit Memo":
                            begin
                                PurchCrMemoHdr.Reset();
                                PurchCrMemoHdr.SetRange("No.", _GenJnlLine."Applies-to Doc. No.");
                                if PurchCrMemoHdr.FindFirst() then
                                    JXVZHistoryPaymentDocument.JXVZDate := PurchCrMemoHdr."Posting Date"
                            end;

                        else
                            JXVZHistoryPaymentDocument.JXVZDate := _GenJnlLine."Posting Date";
                    end;

                    if (IsDebitMemoPurch(_GenJnlLine."Applies-to Doc. No.")) then
                        JXVZHistoryPaymentDocument.JXVZDocumentType := JXVZHistoryPaymentDocument.JXVZDocumentType::"Nota Débito"
                    else
                        JXVZHistoryPaymentDocument.JXVZDocumentType := _GenJnlLine."Applies-to Doc. Type";

                    JXVZHistoryPaymentDocument.JXVZCurrencyCode := _GenJnlLine."Currency Code";
                    JXVZHistoryPaymentDocument.JXVZCurrencyFactor := _GenJnlLine."Currency Factor";

                    JXVZHistoryPaymentDocument.Insert();
                end;
                //Applies documents end
            end;

            //Account payments vendors
            if ((_GenJnlLine."Account Type" = _GenJnlLine."Account Type"::Vendor) and
                (_GenJnlLine.JXVZAccountPayment = true)) then begin
                JXVZHistoryPaymentDocument.Init();
                JXVZHistoryPaymentDocument.JXVZPaymentOrderNo := _GenJnlLine."Document No.";
                JXVZHistoryPaymentDocument.JXVZVoucherNo := _GenJnlLine."Document No.";
                JXVZHistoryPaymentDocument.JXVZAmount := abs(_GenJnlLine.Amount);
                JXVZHistoryPaymentDocument.JXVZCancelledAmount := JXVZHistoryPaymentDocument.JXVZAmount;
                JXVZHistoryPaymentDocument.JXVZVendor := _GenJnlLine."Account No.";
                JXVZHistoryPaymentDocument.JXVZDate := _GenJnlLine."Posting Date";
                JXVZHistoryPaymentDocument.JXVZDocumentType := JXVZHistoryPaymentDocument.JXVZDocumentType::" ";
                JXVZHistoryPaymentDocument.JXVZCurrencyCode := _GenJnlLine."Currency Code";
                JXVZHistoryPaymentDocument.JXVZCurrencyFactor := _GenJnlLine."Currency Factor";
                JXVZHistoryPaymentDocument.Insert();
            end;

            //Values lines
            if ((_GenJnlLine."Account Type" = _GenJnlLine."Account Type"::"G/L Account") OR
                (_GenJnlLine."Account Type" = _GenJnlLine."Account Type"::"Bank Account")) then begin
                JXVZHistoryPaymentValues.reset();
                JXVZHistoryPaymentValues.SETRANGE(JXVZNo, _GenJnlLine."Document No.");
                if (JXVZHistoryPaymentValues.FindLast()) then
                    LineVoucher := JXVZHistoryPaymentValues.JXVZLineNo + 1
                else
                    LineVoucher := 1;

                JXVZHistoryPaymentValues.Init();
                JXVZHistoryPaymentValues.JXVZNo := _GenJnlLine."Document No.";
                JXVZHistoryPaymentValues.JXVZDescription := _GenJnlLine.Description;
                JXVZHistoryPaymentValues.JXVZAmount := abs(_GenJnlLine.Amount);
                JXVZHistoryPaymentValues.JXVZCurrencyCode := _GenJnlLine."Currency Code";
                JXVZHistoryPaymentValues.JXVZCurrencyFactor := _GenJnlLine."Currency Factor";
                JXVZHistoryPaymentValues.JXVZLineNo := LineVoucher;

                //Posting certificate number logic
                JXVZWithholdDetailEntry.Reset();
                JXVZWithholdDetailEntry.SetRange(JXVZWithholdDetailEntry.JXVZWitholdingNo, _GenJnlLine.JXVZWitholdingNo);
                JXVZWithholdDetailEntry.SetFilter(JXVZPostingSeriesCode, '<>%1', '');
                if JXVZWithholdDetailEntry.FindFirst() then
                    JXVZHistoryPaymentValues.JXVZValueNo := NoSeriesManagement.GetNextNo(JXVZWithholdDetailEntry.JXVZPostingSeriesCode, Today(), true)
                else
                    JXVZHistoryPaymentValues.JXVZValueNo := _GenJnlLine.JXVZValueNoValue;
                //Posting certificate number logic END

                JXVZHistoryPaymentValues.JXVZDocumentDate := _GenJnlLine.JXVZDocumentDateValue;
                JXVZHistoryPaymentValues.JXVZToDate := _GenJnlLine.JXVZToDateValue;
                JXVZHistoryPaymentValues.JXVZAcreditationDate := _GenJnlLine.JXVZAcreditationDateValue;
                JXVZHistoryPaymentValues.JXVZEntity := _GenJnlLine.JXVZEntityValue;
                JXVZHistoryPaymentValues.JXVZAccountNo := _GenJnlLine."Account No.";
                JXVZHistoryPaymentValues.JXVZWitholdingNo := _GenJnlLine.JXVZWitholdingNo;
                JXVZHistoryPaymentValues.Insert();

                if (_GenJnlLine.JXVZIsWitholding = true) then begin
                    JXVZWithholdLedgerEntry.Reset();
                    if JXVZWithholdLedgerEntry.FindLast() then
                        EntryNumber := JXVZWithholdLedgerEntry.JXVZNo + 1
                    else
                        EntryNumber := 1;

                    JXVZWithholdLedgerEntry.Init();
                    JXVZWithholdLedgerEntry.JXVZNo := EntryNumber;

                    JXVZHistoryPaymentOrder.Reset();
                    JXVZHistoryPaymentOrder.SetRange(JXVZHistoryPaymentOrder.JXVZNo, _GenJnlLine."Document No.");
                    //GenJournalLineAux.SetRange("Account Type", GenJournalLineAux."Account Type"::Vendor);
                    //if GenJournalLineAux.FindFirst() then
                    if JXVZHistoryPaymentOrder.FindFirst() then
                        JXVZWithholdLedgerEntry.JXVZVendorCode := JXVZHistoryPaymentOrder.JXVZVendorNo;

                    JXVZWithholdingTax.Reset();
                    JXVZWithholdingTax.SetRange(JXVZWithholdingTax.JXVZTaxCode, JXVZWithholdDetailEntry.JXVZTaxCode);
                    if JXVZWithholdingTax.FindFirst() then;

                    JXVZWithholdLedgerEntry.JXVZWitholdingNo := _GenJnlLine.JXVZWitholdingNo;
                    JXVZWithholdLedgerEntry.JXVZVoucherCode := '';
                    JXVZWithholdLedgerEntry.JXVZVoucherDate := _GenJnlLine."Document Date";
                    JXVZWithholdLedgerEntry.JXVZVoucherNo := _GenJnlLine."Document No.";
                    JXVZWithholdLedgerEntry.JXVZVoucherAmount := Abs(_GenJnlLine.JXVZBase);
                    JXVZWithholdLedgerEntry.JXVZSicoreCode := JXVZWithholdingTax.JXVZSicoreCode;
                    JXVZWithholdLedgerEntry.JXVZOperationCode := 1;
                    JXVZWithholdLedgerEntry.JXVZCalculationBase := Abs(_GenJnlLine.JXVZBase);
                    JXVZWithholdLedgerEntry.JXVZWitholdingDate := _GenJnlLine."Posting Date";
                    JXVZWithholdLedgerEntry.JXVZWitholdingCertDate := _GenJnlLine.JXVZToDateValue;
                    JXVZWithholdLedgerEntry.JXVZWitholdingAmount := Abs(_GenJnlLine.Amount);
                    JXVZWithholdLedgerEntry."JXVZExemption%" := 0;
                    JXVZWithholdLedgerEntry.JXVZBoletinDate := 0D;
                    //JXVZWithholdLedgerEntry."Affected Document Type" := '';
                    //JXVZWithholdLedgerEntry."Affected Document No." := '';
                    JXVZWithholdLedgerEntry.JXVZWitholdingCertificateNo := _GenJnlLine.JXVZValueNoValue;
                    JXVZWithholdLedgerEntry.JXVZWitholdingSeriesNo := '';
                    JXVZWithholdLedgerEntry.JXVZBase := Abs(_GenJnlLine.JXVZBase);
                    JXVZWithholdLedgerEntry.JXVZWitholdingType := JXVZWithholdLedgerEntry.JXVZWitholdingType::Realizada;
                    JXVZWithholdLedgerEntry.JXVZDiscriminatePerDocument := false;
                    //JXVZWithholdLedgerEntry."Discriminated Witholding Calc." := 0;
                    //JXVZWithholdLedgerEntry.WitholdinMode := JXVZWithholdLedgerEntry.JXVZWitholdinMode::"Proporcional al pago";

                    "Witholding%" := Round(((_GenJnlLine.Amount * 100) / _GenJnlLine.JXVZBase), 0.01);
                    JXVZWithholdLedgerEntry."JXVZWitholding%" := "Witholding%";

                    JXVZWithholdDetailEntry.Reset();
                    JXVZWithholdDetailEntry.SetRange(JXVZWithholdDetailEntry.JXVZWitholdingNo, _GenJnlLine.JXVZWitholdingNo);
                    if JXVZWithholdDetailEntry.FindFirst() then begin
                        JXVZWithholdLedgerEntry.JXVZTaxCode := JXVZWithholdDetailEntry.JXVZTaxCode;
                        JXVZWithholdLedgerEntry.JXVZWitholdingBaseType := JXVZWithholdDetailEntry.JXVZWitholdingBaseType;
                        JXVZWithholdLedgerEntry.JXVZMinimumWitholding := JXVZWithholdDetailEntry.JXVZMinimumWitholding;
                        JXVZWithholdLedgerEntry.JXVZScaleCode := JXVZWithholdDetailEntry.JXVZScaleCode;
                        JXVZWithholdLedgerEntry.JXVZRegime := JXVZWithholdDetailEntry.JXVZRegime;

                        JXVZWithholdLedgerEntry.JXVZWitholdingCertificateNo := JXVZHistoryPaymentValues.JXVZValueNo;

                        JXVZWithholdingTax.Reset();
                        JXVZWithholdingTax.SetRange(JXVZWithholdingTax.JXVZTaxCode, JXVZWithholdDetailEntry.JXVZTaxCode);
                        if JXVZWithholdingTax.FindFirst() then
                            JXVZWithholdLedgerEntry.JXVZProvinceCode := JXVZWithholdingTax.JXVZProvince;

                        JXVZWithholdScale.Reset();
                        JXVZWithholdScale.SetRange(JXVZWithholdScale.JXVZScaleCode, JXVZWithholdDetailEntry.JXVZScaleCode);
                        JXVZWithholdScale.SetRange(JXVZWithholdScale.JXVZSurplus, "Witholding%");
                        if JXVZWithholdScale.FindFirst() then
                            JXVZWithholdLedgerEntry.JXVZConditionCode := JXVZWithholdScale.JXVZWitholdingCondition;

                        JXVZWithholdTaxCondition.Reset();
                        JXVZWithholdTaxCondition.SetRange(JXVZTaxCode, JXVZWithholdDetailEntry.JXVZTaxCode);
                        if (JXVZWithholdDetailEntry.JXVZConditionCode <> '') then
                            JXVZWithholdTaxCondition.SetRange(JXVZConditionCode, JXVZWithholdDetailEntry.JXVZConditionCode)
                        else
                            JXVZWithholdTaxCondition.SetRange(JXVZConditionCode, JXVZWithholdLedgerEntry.JXVZConditionCode);
                        if JXVZWithholdTaxCondition.FindFirst() then
                            JXVZWithholdLedgerEntry.JXVZSicoreConditionCode := JXVZWithholdTaxCondition.JXVZSicoreConditionCode;
                    end;
                    JXVZWithholdLedgerEntry.Insert();
                end;
            end;
            //Values lines end            
        end;
    end;
    //Generate Payment order record end

    //Check if FC or ND Purch
    procedure IsDebitMemoPurch(_Code: code[20]): Boolean
    //True  = Debit memo
    //False = Invoice
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        PurchInvHeader.Reset();
        PurchInvHeader.SetRange("No.", _Code);
        PurchInvHeader.SetRange(JXInvoiceType, PurchInvHeader.JXInvoiceType::DebitMemo);
        if not PurchInvHeader.IsEmpty() then
            exit(true)
        else
            exit(false);
    end;
    //Check if FC or ND Purch end            

    //Cancel history receipt
    procedure CancelHistoryReceipt(_CashReceipt: Code[20]; _CashReceiptDate: date)
    var
        JXVZHistoryReceiptHeader: Record JXVZHistoryReceiptHeader;
    begin
        JXVZHistoryReceiptHeader.Reset();
        JXVZHistoryReceiptHeader.SetRange(JXVZReceiptNo, _CashReceipt);
        JXVZHistoryReceiptHeader.SetRange(JXVZPostingDate, _CashReceiptDate);
        if JXVZHistoryReceiptHeader.FindFirst() then begin
            JXVZHistoryReceiptHeader.JXVZStatus := JXVZHistoryReceiptHeader.JXVZStatus::Cancelled;
            JXVZHistoryReceiptHeader.Modify(false);
        end;
    end;
    //Cancel history receipt end

    //Cancel history payment
    procedure CancelHistoryPayment(_PaymentJournal: Code[20]; _PaymentJournalDate: date)
    var
        JXVZHistoryPaymOrder: Record JXVZHistoryPaymOrder;
    begin
        JXVZHistoryPaymOrder.Reset();
        JXVZHistoryPaymOrder.SetRange(JXVZNo, _PaymentJournal);
        //JXVZHistoryPaymOrder.SetRange(JXVZPostingDate, _PaymentJournalDate); //fix not check posting date
        if JXVZHistoryPaymOrder.FindFirst() then begin
            JXVZHistoryPaymOrder.JXVZStatus := JXVZHistoryPaymOrder.JXVZStatus::Cancelled;
            JXVZHistoryPaymOrder.Modify(false);
        end;
    end;
    //Cancel history payment end

    //Convert to specific areas
    procedure ConvertToSpecificAreas()
    var
        Customer: Record Customer;
        TaxArea: Record "Tax Area";
        TaxAreaAux: Record "Tax Area";
        TaxAreaLine: Record "Tax Area Line";
        TaxAreaLineAux: Record "Tax Area Line";
        TotalUpdate: Integer;
    begin
        Clear(TotalUpdate);

        Customer.Reset();
        if Customer.FindSet() then
            repeat
                TaxArea.Reset();
                TaxArea.SetRange(Code, Customer."No.");
                TaxArea.SetRange(JXVZSpedificArea, true);
                if not TaxArea.FindFirst() then
                    if NeedSpecificArea(Customer."Tax Area Code") then begin
                        TaxArea.Reset();
                        TaxArea.SetRange(Code, Customer."Tax Area Code");
                        if TaxArea.FindFirst() then begin
                            //Insert new header
                            TaxAreaAux.Init();
                            TaxAreaAux.Code := Customer."No.";
                            TaxAreaAux.Description := Customer.Name;
                            TaxAreaAux.JXVZSpedificArea := true;
                            TaxAreaAux.Insert();
                            //Insert new header end

                            //Insert specifics VAT lines
                            TaxAreaLine.Reset();
                            TaxAreaLine.SetRange("Tax Area", TaxArea.Code);
                            if TaxAreaLine.FindSet() then
                                repeat
                                    TaxAreaLineAux.Init();
                                    TaxAreaLineAux.TransferFields(TaxAreaLine);
                                    TaxAreaLineAux."Tax Area" := TaxAreaAux.Code;
                                    TaxAreaLineAux.Insert(false);
                                until TaxAreaLine.Next() = 0;
                            //Insert specifics VAT lines end

                            //Update Customer
                            Customer."Tax Area Code" := TaxAreaAux.Code;
                            Customer.Modify(false);

                            TotalUpdate += 1;
                        end;
                    end;
            until Customer.Next() = 0;

        if (TotalUpdate > 0) then
            Message('%1 clientes actualizados', format(TotalUpdate));
    end;

    local procedure NeedSpecificArea(_TaxAreaCode: Code[20]): Boolean
    var
        TaxAreaLine: Record "Tax Area Line";
        TaxJurisdiction: Record "Tax Jurisdiction";
        TotalIIBB: Integer;
        SpecificArea: Boolean;
    begin
        clear(TotalIIBB);
        Clear(SpecificArea);

        TaxAreaLine.Reset();
        TaxAreaLine.SetRange("Tax Area", _TaxAreaCode);
        if TaxAreaLine.FindSet() then
            repeat
                TaxJurisdiction.Reset();
                TaxJurisdiction.SetRange(Code, TaxAreaLine."Tax Jurisdiction Code");
                if TaxJurisdiction.FindFirst() then
                    if TaxJurisdiction.JXTaxType = TaxJurisdiction.JXTaxType::GrossIncome then
                        TotalIIBB += 1;
            until TaxAreaLine.Next() = 0;

        if TotalIIBB > 1 then
            SpecificArea := true;

        exit(SpecificArea);
    end;

    procedure LicenseCodeValidations(_LicenseCode: code[38]; _Country: Enum JXVZCountry)
    var
        Ok: Boolean;
        JXErrorLbl: Label 'Invalid license code', Comment = 'Codigo de licencia invalido';
    begin

        /*Venezuela valids license codes
        2021 - F4EZDTEASVTGAGBYUWH3QZVRVTRNWLMY4QTP37
        2022 - VHFRQU02Z0TK4Y7DJZ17ARYL8IDUFUCA5R41NL
        2023 - OXTT55TJEZG1K7X8ATZQLLZHBCP7NPABJRRB8I
        2024 - 781SOAFSO9OGITQZBUXWXICOS3RFDTKY09Y1R3
        2025 - 7LF07JE7Y142W0A4YXBB54K4RB4VKBPJPPPMN4
        2026 - BHMA0D6OSBYULPGIETNGUCX57QO4ISVDYCBTB5
        2027 - I9WQZTABW1TB54KJPQ52WS7BQNTPWKNJW4VJIU
        2028 - CQXIVT3UE3W17IX28ZKWPFP5EFHXLAYBB5J6LF
        2029 - CFWK5PUHU8TBW01X23UJ14OET74U48PE1AX60X
        2030 - 9GFLFLO7ASS7HSEJPU58COY2XO8D08IHGELGGA
        2031 - JSIDDGZGHWT5XAIIFZ16882D6DGHIYTXV79WXQ
        */

        Ok := false;

        //Valid license codes        
        case _Country of
            JXVZCountry::Venezuela:
                if (_LicenseCode = 'F4EZDTEASVTGAGBYUWH3QZVRVTRNWLMY4QTP37') or
                   (_LicenseCode = 'VHFRQU02Z0TK4Y7DJZ17ARYL8IDUFUCA5R41NL') or
                   (_LicenseCode = 'OXTT55TJEZG1K7X8ATZQLLZHBCP7NPABJRRB8I') or
                   (_LicenseCode = '781SOAFSO9OGITQZBUXWXICOS3RFDTKY09Y1R3') or
                   (_LicenseCode = '7LF07JE7Y142W0A4YXBB54K4RB4VKBPJPPPMN4') or
                   (_LicenseCode = 'BHMA0D6OSBYULPGIETNGUCX57QO4ISVDYCBTB5') or
                   (_LicenseCode = 'I9WQZTABW1TB54KJPQ52WS7BQNTPWKNJW4VJIU') or
                   (_LicenseCode = 'CQXIVT3UE3W17IX28ZKWPFP5EFHXLAYBB5J6LF') or
                   (_LicenseCode = 'CFWK5PUHU8TBW01X23UJ14OET74U48PE1AX60X') or
                   (_LicenseCode = '9GFLFLO7ASS7HSEJPU58COY2XO8D08IHGELGGA') or
                   (_LicenseCode = 'JSIDDGZGHWT5XAIIFZ16882D6DGHIYTXV79WXQ') then
                    Ok := true;
        end;

        if ok = false then
            Error(JXErrorLbl);


    end;

    procedure LicenseCodeValidationsDate()
    var
        CompanyInfo: Record "Company Information";
        Ok: Boolean;
        JXErrorLbl: Label 'Venezuela license code %1 is expired', Comment = 'El codigo de licencia %1 de la Venezuela se encuentra vencido';
    begin
        Ok := false;

        CompanyInfo.Get();

        if CompanyInfo.JXVZCountry = CompanyInfo.JXVZCountry::Empty then
            exit;

        //Valid license codes dates       
        case CompanyInfo.JXVZCountry of
            JXVZCountry::Venezuela:
                if (Date2DMY(Today(), 3) = 2021) and (CompanyInfo.JXVZLicenseCode = 'F4EZDTEASVTGAGBYUWH3QZVRVTRNWLMY4QTP37') or
                   (Date2DMY(Today(), 3) = 2022) and (CompanyInfo.JXVZLicenseCode = 'VHFRQU02Z0TK4Y7DJZ17ARYL8IDUFUCA5R41NL') or
                   (Date2DMY(Today(), 3) = 2023) and (CompanyInfo.JXVZLicenseCode = 'OXTT55TJEZG1K7X8ATZQLLZHBCP7NPABJRRB8I') or
                   (Date2DMY(Today(), 3) = 2024) and (CompanyInfo.JXVZLicenseCode = '781SOAFSO9OGITQZBUXWXICOS3RFDTKY09Y1R3') or
                   (Date2DMY(Today(), 3) = 2025) and (CompanyInfo.JXVZLicenseCode = '7LF07JE7Y142W0A4YXBB54K4RB4VKBPJPPPMN4') or
                   (Date2DMY(Today(), 3) = 2026) and (CompanyInfo.JXVZLicenseCode = 'BHMA0D6OSBYULPGIETNGUCX57QO4ISVDYCBTB5') or
                   (Date2DMY(Today(), 3) = 2027) and (CompanyInfo.JXVZLicenseCode = 'I9WQZTABW1TB54KJPQ52WS7BQNTPWKNJW4VJIU') or
                   (Date2DMY(Today(), 3) = 2028) and (CompanyInfo.JXVZLicenseCode = 'CQXIVT3UE3W17IX28ZKWPFP5EFHXLAYBB5J6LF') or
                   (Date2DMY(Today(), 3) = 2029) and (CompanyInfo.JXVZLicenseCode = 'CFWK5PUHU8TBW01X23UJ14OET74U48PE1AX60X') or
                   (Date2DMY(Today(), 3) = 2030) and (CompanyInfo.JXVZLicenseCode = '9GFLFLO7ASS7HSEJPU58COY2XO8D08IHGELGGA') or
                   (Date2DMY(Today(), 3) >= 2031) and (CompanyInfo.JXVZLicenseCode = 'JSIDDGZGHWT5XAIIFZ16882D6DGHIYTXV79WXQ') then
                    Ok := true;
        end;

        if ok = false then
            Error(JXErrorLbl, CompanyInfo.JXVZLicenseCode);
    end;

    //JX  -  2023 04 24
    procedure ValidateCUITArgentina(pCUIT: Text[50]): Text[50]
    var
        vCuit: Text[50];
        vCuitOK: Text[50];
        vCuitNumeric: Text[50];
        ControlDigit: Integer;
        ret: Text[50];
    begin
        vCuit := DelChr(pCUIT, '=', '-/_');
        vCuitNumeric := vCuit;

        if StrLen(VCuit) > 11 then
            Error('El cuit no puede tener mas de 11 digitos');

        if StrLen(VCuit) < 11 then
            Error('El cuit no puede tener menos de 11 digitos');

        VCuit := CopyStr(VCuit, 1, 10);
        ControlDigit := CalcDigitCuitNumber(VCuit);

        vCuitOK := CopyStr(VCuit, 1, 2) + '-' + CopyStr(VCuit, 3, 8) + '-' + Format(ControlDigit);
        vCuitNumeric := CopyStr(vCuitNumeric, 1, 2) + '-' + CopyStr(vCuitNumeric, 3, 8) + '-' + CopyStr(vCuitNumeric, 11);

        if vCuitOK <> vCuitNumeric then
            Error('El cuit no es correcto')
        else
            ret := vCuitNumeric;

        exit(ret);
    end;

    local procedure CalcDigitCuitNumber(pCuit: Text[50]) Ret: Integer
    var
        "Key": Text[50];
        length: Integer;
        KeyN: array[20] of Text;
        i: Integer;
        j: Integer;
        cont: Integer;
        Total: Integer;
        Rest: Integer;
        NumberN: Integer;
        Subtotal: array[20] of Integer;
        CalcValue: Integer;
        FinalKey: array[20] of Text;
    begin
        "Key" := pCuit;
        length := STRLEN("Key");

        repeat
            i := i + 1;
            KeyN[i] := COPYSTR("Key", i, 1);
            if KeyN[i] in ['0' .. '9'] then begin
                j := j + 1;
                FinalKey[j] := KeyN[i];
            end;

        until i = length;

        length := j;
        i := length;
        j := 2;
        repeat
            cont := cont + 1;
            Evaluate(NumberN, FinalKey[i]);

            if cont <= 6 then begin
                Subtotal[i] := NumberN * j;
                j := j + 1;
            end else begin
                j := 2;
                Subtotal[i] := NumberN * j;
                cont := 1;
                j := j + 1;
            end;
            Total := Total + Subtotal[i];
            i := i - 1;
        until i = 0;

        Rest := Total Mod 11;

        if Rest = 0 then
            CalcValue := 0
        else
            if Rest = 1 then
                Error('El número es incompatible')
            else
                CalcValue := 11 - Rest;

        Ret := CalcValue;
    end;
    //JX  -  2023 04 24 end

    local procedure IsVendorPaymentAccount(_opNumber: Code[20]; _opAmount: Decimal): Boolean
    var
        PostedGenJnlLine: Record "Posted Gen. Journal Line";
        Ret: Boolean;
    begin
        Ret := false;

        PostedGenJnlLine.Reset();
        PostedGenJnlLine.SetRange("Document No.", _opNumber);
        PostedGenJnlLine.SetRange("Document Type", PostedGenJnlLine."Document Type"::Payment);
        PostedGenJnlLine.SetRange(Amount, _opAmount);
        PostedGenJnlLine.SetRange(JXVZAccountPayment, true);
        if not PostedGenJnlLine.IsEmpty() then
            ret := true;

        exit(ret);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertHistPaymentOrder(var _JXVZHistoryPaymOrder: Record JXVZHistoryPaymOrder; _GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    procedure ControlPaymentControlSecuence(_GenJnlLine: Record "Gen. Journal Line")
    var
        JXVZHistoryPaymOrder: Record JXVZHistoryPaymOrder;
        JXVZPaymentSetup: Record JXVZPaymentSetup;
        ErrorOPDocNoLbl: label 'Orden de pago %1 ya existe en historico ordenes de pago, ajuste la secuencia y registre nuevamente', comment = '%1 = Payment Order No.';
    begin
        JXVZPaymentSetup.Reset();
        if JXVZPaymentSetup.FindFirst() then
            if JXVZPaymentSetup.JXVZControlSecuencePaymorderNo then begin
                JXVZHistoryPaymOrder.Reset();
                JXVZHistoryPaymOrder.SetRange(JXVZNo, _GenJnlLine."Document No.");
                if JXVZHistoryPaymOrder.FindFirst() then
                    Error(StrSubstNo(ErrorOPDocNoLbl, JXVZHistoryPaymOrder.JXVZNo));
            end;
    end;
}