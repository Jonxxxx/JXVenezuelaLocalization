codeunit 84103 JXVZSubscriberHandlerFactory
{
    Permissions = tabledata "G/L Entry" = rm, tabledata "Purch. Inv. Line" = rm;

    trigger OnRun()
    begin

    end;

    //Check post receipt or payment order Venezuela
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnBeforePostGenJnlLine', '', false, false)]
    local procedure OnBeforePostGenJnlLine(VAR GenJournalLine: Record "Gen. Journal Line"; CommitIsSuppressed: Boolean; VAR Posted: Boolean)
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        CompanyInformation: Record "Company Information";
        JXVZLogicalFactory: Codeunit JXVZLogicalFactory;
    begin
        //License code validation
        JXVZLogicalFactory.LicenseCodeValidationsDate();

        if ((CompanyInformation.JXIsVenezuela())) then begin
            //Post Venezuela customer receipt
            GenJnlBatch.Reset();
            GenJnlBatch.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
            GenJnlBatch.SetRange(Name, GenJournalLine."Journal Batch Name");
            GenJnlBatch.SetRange(JXVZReceipt, true);//Receipt Gestion
            if (GenJnlBatch.FindFirst()) then
                JXVZLogicalFactory.GenerateReceiptRecord(GenJournalLine);
            //Post Venezuela customer receipt END

            //Post Venezuela vendor payment order
            GenJnlBatch.Reset();
            GenJnlBatch.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
            GenJnlBatch.SetRange(Name, GenJournalLine."Journal Batch Name");
            GenJnlBatch.SetRange(JXVZPaymOrder, true);//PaymentOrder Gestion        
            if not GenJnlBatch.IsEmpty() then
                JXVZLogicalFactory.GeneratePaymentOrderRecord(GenJournalLine);

            //Post Venezuela vendor payment order END
        end;
    end;
    //Check post receipt or payment order Venezuela END

    //Reverse third party check & Cancel history receipt
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnBeforeReverse', '', false, false)]
    local procedure OnBeforeReverse(VAR ReversalEntry: Record "Reversal Entry"; VAR ReversalEntry2: Record "Reversal Entry"; VAR IsHandled: Boolean)
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        CompanyInformation: Record "Company Information";
        JXVZLogicalFactory: Codeunit JXVZLogicalFactory;
    begin
        JXVZLogicalFactory.LicenseCodeValidationsDate();

        if ((CompanyInformation.JXIsVenezuela())) then begin
            GenJnlBatch.Reset();
            GenJnlBatch.SetRange(GenJnlBatch.Name, ReversalEntry."Journal Batch Name");
            if GenJnlBatch.FindFirst() then
                if GenJnlBatch.JXVZReceipt then begin
                    JXVZLogicalFactory.CancelHistoryReceipt(ReversalEntry."Document No.", ReversalEntry."Posting Date");
                end;

            if GenJnlBatch.JXVZPaymOrder then begin
                JXVZLogicalFactory.CancelHistoryPayment(ReversalEntry."Document No.", ReversalEntry."Posting Date");
            end;
        end;

    end;
    //Reverse third party check & Cancel history receipt END    

    //Control for credit memos in cash receipt journal Venezuela
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnBeforeErrorIfPositiveAmt', '', false, false)]
    local procedure OnBeforeErrorIfPositiveAmt(GenJnlLine: Record "Gen. Journal Line"; VAR RaiseError: Boolean)
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        CompanyInformation: Record "Company Information";
    begin
        if ((CompanyInformation.JXIsVenezuela())) then begin
            GenJnlBatch.Reset();
            GenJnlBatch.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
            GenJnlBatch.SetRange(Name, GenJnlLine."Journal Batch Name");
            GenJnlBatch.SetRange(JXVZReceipt, true);//Receipt Gestion
            if (not GenJnlBatch.IsEmpty()) then
                if GenJnlLine."Applies-to Doc. Type" = GenJnlLine."Applies-to Doc. Type"::"Credit Memo" then
                    if RaiseError then
                        RaiseError := false;
        end;
    end;
    //Control for credit memos in cash receipt journal Venezuela END


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostLines', '', false, false)]
    local procedure OnBeforePostLines(VAR PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean)
    var
        CompanyInformation: Record "Company Information";
    begin
        if (CompanyInformation.JXIsVenezuela()) then
            if not PreviewMode then begin
                PurchHeader.TestField(JXVZFiscalType);
                PurchHeader.TestField(JXVZProvince);
                if (PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice) or (PurchHeader."Document Type" = PurchHeader."Document Type"::Order) then
                    PurchHeader.TestField(JXVZInvoiceType);
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseGLEntryOnBeforeInsertGLEntry', '', false, false)]
    local procedure OnReverseGLEntryOnBeforeInsertGLEntry(VAR GLEntry: Record "G/L Entry"; GenJnlLine: Record "Gen. Journal Line"; GLEntry2: Record "G/L Entry")
    var
        JXVZTempTable: Record JXVZTempTable;
        CompanyInformation: Record "Company Information";
    begin
        if ((CompanyInformation.JXIsVenezuela())) then begin
            JXVZTempTable.Reset();
            JXVZTempTable.SetRange(JXVZTempTable.User, UserId);
            JXVZTempTable.SetRange(JXVZTempTable.Revert, true);
            if JXVZTempTable.FindFirst() then
                GLEntry."Posting Date" := JXVZTempTable.PostingDate;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnAfterDateNoAllowed', '', false, false)]
    local procedure OnAfterDateNoAllowed(PostingDate: Date; var DateIsNotAllowed: Boolean)
    var
        JXVZTempTable: Record JXVZTempTable;
        CompanyInformation: Record "Company Information";
        UserSetupManagement: Codeunit "User Setup Management";
    begin
        if ((CompanyInformation.JXIsVenezuela())) then begin
            JXVZTempTable.Reset();
            JXVZTempTable.SetRange(User, UserId);
            JXVZTempTable.SetRange(Revert, true);
            if JXVZTempTable.FindFirst() then
                DateIsNotAllowed := NOT UserSetupManagement.IsPostingDateValid(JXVZTempTable.PostingDate);
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Tax Calculate", 'OnBeforeCalculateTaxProcedure', '', true, true)]
    local procedure "Sales Tax Calculate_OnBeforeCalculateTaxProcedure"
    (
        TaxAreaCode: Code[20];
        TaxGroupCode: Code[20];
        TaxLiable: Boolean;
        Date: Date;
        Amount: Decimal;
        Quantity: Decimal;
        ExchangeRate: Decimal;
        var TaxAmount: Decimal;
        var IsHandled: Boolean
    )
    var
        CompanyInformation: Record "Company Information";
        GenLedgerSetup: Record "General Ledger Setup";
        MaxAmount: Decimal;
        TaxBaseAmount: Decimal;
        Text000: Label '%1 in %2 %3 must be filled in with unique values when %4 is %5.';
        Text001: Label 'The sales tax amount for the %1 %2 and the %3 %4 is incorrect. ';
        Text003: Label 'Lines is not initialized';
        Text004: Label 'The calculated sales tax amount is %5, but was supposed to be %6.';
        TaxArea: Record "Tax Area";
        TaxAreaLine: Record "Tax Area Line";
        TaxDetail: Record "Tax Detail";
        TMPTaxDetail: Record "Tax Detail" temporary;
        ExchangeFactor: Decimal;
        TotalTaxAmountRounding: Decimal;
        TotalForAllocation: Decimal;
        RemainingTaxDetails: Integer;
        LastCalculationOrder: Integer;
        Initialised: Boolean;
        FirstLine: Boolean;
        TaxOnTaxCalculated: Boolean;
        CalculationOrderViolation: Boolean;
    begin
        CompanyInformation.get();
        if ((CompanyInformation.JXIsVenezuela())) then begin
            if (CompanyInformation.JXVZMaxDiferenceIVA > 0) then begin
                IsHandled := true;

                TaxAmount := 0;
                if not TaxLiable or (TaxAreaCode = '') or (TaxGroupCode = '') or
                   ((Amount = 0) and (Quantity = 0))
                then
                    exit;

                if ExchangeRate = 0 then
                    ExchangeFactor := 1
                else
                    ExchangeFactor := ExchangeRate;

                Amount := Amount / ExchangeFactor;

                TaxAreaLine.SetCurrentKey("Tax Area", "Calculation Order");
                TaxAreaLine.SetRange("Tax Area", TaxAreaCode);
                if TaxAreaLine.Find('+') then begin
                    LastCalculationOrder := TaxAreaLine."Calculation Order" + 1;
                    TaxOnTaxCalculated := false;
                    CalculationOrderViolation := false;
                    repeat
                        if TaxAreaLine."Calculation Order" >= LastCalculationOrder then
                            CalculationOrderViolation := true
                        else
                            LastCalculationOrder := TaxAreaLine."Calculation Order";
                        TaxDetail.Reset();
                        TaxDetail.SetRange("Tax Jurisdiction Code", TaxAreaLine."Tax Jurisdiction Code");
                        if TaxGroupCode = '' then
                            TaxDetail.SetFilter("Tax Group Code", '%1', TaxGroupCode)
                        else
                            TaxDetail.SetFilter("Tax Group Code", '%1|%2', '', TaxGroupCode);
                        if Date = 0D then
                            TaxDetail.SetFilter("Effective Date", '<=%1', WorkDate)
                        else
                            TaxDetail.SetFilter("Effective Date", '<=%1', Date);
                        //Comment when implement for US or MX version    
                        TaxDetail.SetRange("Tax Type", TaxDetail."Tax Type"::"Sales Tax");
                        if TaxDetail.FindLast then begin
                            TaxOnTaxCalculated := TaxOnTaxCalculated or TaxDetail."Calculate Tax on Tax";
                            if TaxDetail."Calculate Tax on Tax" then
                                TaxBaseAmount := Amount + TaxAmount
                            else
                                TaxBaseAmount := Amount;
                            if (Abs(TaxBaseAmount) <= TaxDetail."Maximum Amount/Qty.") or
                               (TaxDetail."Maximum Amount/Qty." = 0)
                            then
                                TaxAmount := TaxAmount + TaxBaseAmount * TaxDetail."Tax Below Maximum" / 100
                            else begin
                                //JXLOCARG
                                TaxAmount := TaxAmount + TaxBaseAmount * TaxDetail."Tax Above Maximum" / 100

                                /*
                                MaxAmount := TaxBaseAmount / Abs(TaxBaseAmount) * TaxDetail."Maximum Amount/Qty.";
                                TaxAmount :=
                                  TaxAmount + ((MaxAmount * TaxDetail."Tax Below Maximum") +
                                               ((TaxBaseAmount - MaxAmount) * TaxDetail."Tax Above Maximum")) / 100;
                                */
                                //JXLOCARG END
                            end;
                        end;
                        TaxDetail.SetRange("Tax Type", TaxDetail."Tax Type"::"Excise Tax");
                        if TaxDetail.FindLast then
                            if (Abs(Quantity) <= TaxDetail."Maximum Amount/Qty.") or
                               (TaxDetail."Maximum Amount/Qty." = 0)
                            then
                                TaxAmount := TaxAmount + Quantity * TaxDetail."Tax Below Maximum"
                            else begin
                                MaxAmount := Quantity / Abs(Quantity) * TaxDetail."Maximum Amount/Qty.";
                                TaxAmount :=
                                  TaxAmount + (MaxAmount * TaxDetail."Tax Below Maximum") +
                                  ((Quantity - MaxAmount) * TaxDetail."Tax Above Maximum");
                            end;
                    until TaxAreaLine.Next(-1) = 0;
                    TaxAmount := TaxAmount * ExchangeFactor;

                    GenLedgerSetup.get();
                    if GenLedgerSetup.JXVZRoundIVA <> 0 then
                        TaxAmount := Round(TaxAmount, GenLedgerSetup.JXVZRoundIVA);

                    if TaxOnTaxCalculated and CalculationOrderViolation then
                        Error(
                          Text000,
                          TaxAreaLine.FieldCaption("Calculation Order"), TaxArea.TableCaption, TaxAreaLine."Tax Area",
                          TaxDetail.FieldCaption("Calculate Tax on Tax"), CalculationOrderViolation);
                end;
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Tax Calculate", 'OnBeforeInitSalesTaxLines', '', true, true)]
    local procedure "Sales Tax Calculate_OnBeforeInitSalesTaxLines"
    (
        TaxAreaCode: Code[20];
        TaxGroupCode: Code[20];
        TaxLiable: Boolean;
        Amount: Decimal;
        Quantity: Decimal;
        Date: Date;
        DesiredTaxAmount: Decimal;
        var TMPTaxDetail: Record "Tax Detail";
        var IsHandled: Boolean;
        var Initialised: Boolean;
        var FirstLine: Boolean
    )
    var
        CompanyInformation: Record "Company Information";
        GenJnlLine: Record "Gen. Journal Line";
        GenLedgerSetup: Record "General ledger setup";
        JXVZPaymentSetup: Record JXVZPaymentSetup;
        MaxAmount: Decimal;
        TaxAmount: Decimal;
        AddedTaxAmount: Decimal;
        TaxBaseAmount: Decimal;
        Text000: Label '%1 in %2 %3 must be filled in with unique values when %4 is %5.';
        Text001: Label 'The sales tax amount for the %1 %2 and the %3 %4 is incorrect. ';
        Text003: Label 'Lines is not initialized';
        Text004: Label 'The calculated sales tax amount is %5, but was supposed to be %6.';
        TaxArea: Record "Tax Area";
        TaxAreaLine: Record "Tax Area Line";
        TaxDetail: Record "Tax Detail";
        ExchangeFactor: Decimal;
        TotalTaxAmountRounding: Decimal;
        TotalForAllocation: Decimal;
        RemainingTaxDetails: Integer;
        LastCalculationOrder: Integer;
        TaxOnTaxCalculated: Boolean;
        CalculationOrderViolation: Boolean;
    begin
        CompanyInformation.get();
        if ((CompanyInformation.JXIsVenezuela())) then begin
            if (CompanyInformation.JXVZMaxDiferenceIVA > 0) then begin
                GenLedgerSetup.get();
                TaxAmount := 0;

                Initialised := true;
                FirstLine := true;
                TMPTaxDetail.DeleteAll();

                RemainingTaxDetails := 0;

                if (TaxAreaCode = '') or (TaxGroupCode = '') then
                    exit;

                TaxAreaLine.SetCurrentKey("Tax Area", "Calculation Order");
                TaxAreaLine.SetRange("Tax Area", TaxAreaCode);
                if TaxAreaLine.Find('+') then begin
                    LastCalculationOrder := TaxAreaLine."Calculation Order" + 1;
                    TaxOnTaxCalculated := false;
                    CalculationOrderViolation := false;
                    repeat
                        if TaxAreaLine."Calculation Order" >= LastCalculationOrder then
                            CalculationOrderViolation := true
                        else
                            LastCalculationOrder := TaxAreaLine."Calculation Order";
                        TaxDetail.Reset();
                        TaxDetail.SetRange("Tax Jurisdiction Code", TaxAreaLine."Tax Jurisdiction Code");
                        if TaxGroupCode = '' then
                            TaxDetail.SetFilter("Tax Group Code", '%1', TaxGroupCode)
                        else
                            TaxDetail.SetFilter("Tax Group Code", '%1|%2', '', TaxGroupCode);
                        if Date = 0D then
                            TaxDetail.SetFilter("Effective Date", '<=%1', WorkDate)
                        else
                            TaxDetail.SetFilter("Effective Date", '<=%1', Date);
                        //Comment when implement for US or MX version
                        TaxDetail.SetRange("Tax Type", TaxDetail."Tax Type"::"Sales Tax");
                        if TaxDetail.FindLast and ((TaxDetail."Tax Below Maximum" <> 0) or (TaxDetail."Tax Above Maximum" <> 0)) then begin
                            TaxOnTaxCalculated := TaxOnTaxCalculated or TaxDetail."Calculate Tax on Tax";
                            if TaxDetail."Calculate Tax on Tax" then
                                TaxBaseAmount := Amount + TaxAmount
                            else
                                TaxBaseAmount := Amount;

                            if TaxLiable then begin
                                if (Abs(TaxBaseAmount) <= TaxDetail."Maximum Amount/Qty.") or
                                   (TaxDetail."Maximum Amount/Qty." = 0)
                                then
                                    AddedTaxAmount := TaxBaseAmount * TaxDetail."Tax Below Maximum" / 100
                                else begin
                                    //JXLOCARG
                                    AddedTaxAmount := TaxBaseAmount * TaxDetail."Tax Above Maximum" / 100;
                                    /*
                                    MaxAmount := TaxBaseAmount / Abs(TaxBaseAmount) * TaxDetail."Maximum Amount/Qty.";
                                    AddedTaxAmount :=
                                      ((MaxAmount * TaxDetail."Tax Below Maximum") +
                                       ((TaxBaseAmount - MaxAmount) * TaxDetail."Tax Above Maximum")) / 100;
                                    */
                                    //JXLOCARG END
                                end;
                            end else
                                AddedTaxAmount := 0;

                            //Round VAT Venezuela
                            if GenLedgerSetup.JXVZRoundIVA <> 0 then
                                AddedTaxAmount := Round(AddedTaxAmount, GenLedgerSetup.JXVZRoundIVA);

                            TaxAmount := TaxAmount + AddedTaxAmount;
                            TMPTaxDetail := TaxDetail;
                            TMPTaxDetail."Tax Below Maximum" := AddedTaxAmount;
                            TMPTaxDetail."Tax Above Maximum" := TaxBaseAmount;
                            TMPTaxDetail.Insert();
                            RemainingTaxDetails := RemainingTaxDetails + 1;
                        end;
                        TaxDetail.SetRange("Tax Type", TaxDetail."Tax Type"::"Excise Tax");
                        if TaxDetail.FindLast and ((TaxDetail."Tax Below Maximum" <> 0) or (TaxDetail."Tax Above Maximum" <> 0)) then begin
                            if TaxLiable then begin
                                if (Abs(Quantity) <= TaxDetail."Maximum Amount/Qty.") or
                                   (TaxDetail."Maximum Amount/Qty." = 0)
                                then
                                    AddedTaxAmount := Quantity * TaxDetail."Tax Below Maximum"
                                else begin
                                    MaxAmount := Quantity / Abs(Quantity) * TaxDetail."Maximum Amount/Qty.";
                                    AddedTaxAmount :=
                                      (MaxAmount * TaxDetail."Tax Below Maximum") +
                                      ((Quantity - MaxAmount) * TaxDetail."Tax Above Maximum");
                                end;
                            end else
                                AddedTaxAmount := 0;

                            //Round VAT Venezuela
                            if GenLedgerSetup.JXVZRoundIVA <> 0 then
                                AddedTaxAmount := Round(AddedTaxAmount, GenLedgerSetup.JXVZRoundIVA);

                            TaxAmount := TaxAmount + AddedTaxAmount;
                            TMPTaxDetail := TaxDetail;
                            TMPTaxDetail."Tax Below Maximum" := AddedTaxAmount;
                            TMPTaxDetail."Tax Above Maximum" := TaxBaseAmount;
                            TMPTaxDetail.Insert();
                            RemainingTaxDetails := RemainingTaxDetails + 1;
                        end;
                    until TaxAreaLine.Next(-1) = 0;

                    TaxAmount := Round(TaxAmount);

                    //if (TaxAmount <> DesiredTaxAmount) and (Abs(TaxAmount - DesiredTaxAmount) <= 0.01) then
                    if (TaxAmount <> DesiredTaxAmount) and (Abs(TaxAmount - DesiredTaxAmount) <= CompanyInformation.JXVZMaxDiferenceIVA) then
                        if TMPTaxDetail.Find('-') then begin
                            TMPTaxDetail."Tax Below Maximum" :=
                              TMPTaxDetail."Tax Below Maximum" - TaxAmount + DesiredTaxAmount;
                            TMPTaxDetail.Modify();
                            TaxAmount := DesiredTaxAmount;
                        end;

                    if TaxOnTaxCalculated and CalculationOrderViolation then
                        Error(
                          Text000,
                          TaxAreaLine.FieldCaption("Calculation Order"), TaxArea.TableCaption, TaxAreaLine."Tax Area",
                          TaxDetail.FieldCaption("Calculate Tax on Tax"), CalculationOrderViolation);
                end;

                //Improvment for allow differents tax area codes in Invoices
                //JXVZPaymentSetup.Get();
                //if not JXVZPaymentSetup.JXVZAllowDiffTaxAreaCode then
                if TaxAmount <> DesiredTaxAmount then
                    Error(
                      Text001 +
                      Text004,
                      TaxAreaCode, GenJnlLine.FieldCaption("Tax Area Code"),
                      TaxGroupCode, GenJnlLine.FieldCaption("Tax Group Code"),
                      TaxAmount, DesiredTaxAmount);

                TotalForAllocation := DesiredTaxAmount;

                IsHandled := true;
            end;
        end;
    end;


    // check this code
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeUpdateWithWarehouseReceive', '', true, true)]
    local procedure "Purchase Line_OnBeforeUpdateWithWarehouseReceive"
    (
        var PurchaseLine: Record "Purchase Line";
        var InHandled: Boolean
    )
    var
        CompanyInformation: Record "Company Information";
    begin
        if (CompanyInformation.JXIsVenezuela()) then
            if (PurchaseLine."Document Type" = PurchaseLine."Document Type"::Order) then
                if (PurchaseLine.type = PurchaseLine.type::Item) and (PurchaseLine."Location Code" = '') then
                    InHandled := true;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnBeforeErrorIfPositiveAmt', '', true, true)]
    local procedure "Gen. Jnl.-Check Line_OnBeforeErrorIfPositiveAmt"
    (
        GenJnlLine: Record "Gen. Journal Line";
        var RaiseError: Boolean
    )
    var
        CompanyInformation: Record "Company Information";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        if (CompanyInformation.JXIsVenezuela()) then begin
            GeneralLedgerSetup.Get();
            if (GeneralLedgerSetup.JXVZOmmitJournalPosValidation) then
                RaiseError := false;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnBeforeErrorIfNegativeAmt', '', true, true)]
    local procedure "Gen. Jnl.-Check Line_OnBeforeErrorIfNegativeAmt"
    (
        GenJnlLine: Record "Gen. Journal Line";
        var RaiseError: Boolean
    )
    var
        CompanyInformation: Record "Company Information";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        if (CompanyInformation.JXIsVenezuela()) then begin
            GeneralLedgerSetup.Get();
            if (GeneralLedgerSetup.JXVZOmmitJournalNegValidation) then
                RaiseError := false;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostLines', '', true, true)]
    local procedure "Sales-Post_OnBeforePostLines"
    (
        var SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        CommitIsSuppressed: Boolean;
        PreviewMode: Boolean
    )
    var
        CompanyInformation: Record "Company Information";
    begin
        if (CompanyInformation.JXIsVenezuela()) then begin
            SalesHeader.TestField(JXVZFiscalType);
            SalesHeader.TestField(JXVZProvinceCode);
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Correct Posted Sales Invoice", 'OnAfterCreateCopyDocument', '', true, true)]
    local procedure "Correct Posted Sales Invoice_OnAfterCreateCopyDocument"
    (
        var SalesHeader: Record "Sales Header";
        var SalesInvoiceHeader: Record "Sales Invoice Header"
    )
    var
        CompanyInformation: Record "Company Information";
    begin
        if (CompanyInformation.JXIsVenezuela()) then begin
            SalesHeader.Validate(JXVZPointOfSale, SalesHeader.JXVZPointOfSale);
            SalesHeader.modify(true);
        end;
    end;

    /*
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeCheckExternalDocumentNumber', '', true, true)]
    local procedure "Purch.-Post_OnBeforeCheckExternalDocumentNumber"
    (
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PurchaseHeader: Record "Purchase Header";
        var Handled: Boolean;
        DocType: Option;
        ExtDocNo: Text[35]
    )
    var
        CompanyInformation: Record "Company Information";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchaseAlreadyExistsErr: Label 'Purchase %1 %2 already exists for this vendor.', Comment = '%1 = Document Type, %2 = Document No.';
    begin
        if (CompanyInformation.JXIsVenezuela())  then begin
            if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) or (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) then begin
                Handled := true;

                PurchInvHeader.Reset();
                PurchInvHeader.SetRange("Vendor Invoice No.", PurchaseHeader."Vendor Invoice No.");
                PurchInvHeader.SetRange("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                PurchInvHeader.SetRange(JXVZInvoiceType, PurchaseHeader.JXVZInvoiceType);
                if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then
                    PurchInvHeader.SetRange("Pre-Assigned No.", '<>%1', PurchaseHeader."No.")
                else
                    PurchInvHeader.SetRange("Order No.", '<>%1', PurchaseHeader."No.");
                if PurchInvHeader.FindFirst() then
                    Error(PurchaseAlreadyExistsErr, Format(PurchInvHeader.JXVZInvoiceType), PurchInvHeader."Vendor Invoice No.");
            end;
        end;
    end;
    */

    //JX  -  2022 10 07
    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnBeforeShowDoc', '', true, true)]
    local procedure "Cust. Ledger Entry_OnBeforeShowDoc"
    (
        CustLedgerEntry: Record "Cust. Ledger Entry";
        var IsPageOpened: Boolean;
        var IsHandled: Boolean
    )
    var
        CompanyInformation: Record "Company Information";
        JXVZHistoryReceiptHeader: Record JXVZHistoryReceiptHeader;
        JXVZPostedReceipt: page JXVZPostedReceipt;
        IsVenezuela: Boolean;


    begin
        IsVenezuela := CompanyInformation.JXIsVenezuela();



        if (IsVenezuela) then
            if (CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Payment) then begin
                IsHandled := true;
                IsPageOpened := true;

                clear(JXVZPostedReceipt);
                JXVZHistoryReceiptHeader.Reset();
                JXVZHistoryReceiptHeader.SetRange(JXVZReceiptNo, CustLedgerEntry."Document No.");
                JXVZPostedReceipt.SetTableView(JXVZHistoryReceiptHeader);
                JXVZPostedReceipt.Run();
            end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnBeforeShowDoc', '', true, true)]
    local procedure "Vendor Ledger Entry_OnBeforeShowDoc"
    (
        var VendorLedgerEntry: Record "Vendor Ledger Entry";
        var Result: Boolean;
        var IsHandled: Boolean
    )
    var
        CompanyInformation: Record "Company Information";
        JXVZHistoryPaymOrder: Record JXVZHistoryPaymOrder;
        JXVZHistoryPaymOrderPage: page JXVZHistoryPaymOrder;
        IsVenezuela: Boolean;


    begin
        IsVenezuela := CompanyInformation.JXIsVenezuela();



        if (IsVenezuela) then
            if (VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::Payment) then begin
                IsHandled := true;
                Result := true;

                clear(JXVZHistoryPaymOrderPage);
                JXVZHistoryPaymOrder.Reset();
                JXVZHistoryPaymOrder.SetRange(JXVZNo, VendorLedgerEntry."Document No.");
                JXVZHistoryPaymOrderPage.SetTableView(JXVZHistoryPaymOrder);
                JXVZHistoryPaymOrderPage.Run();
            end;
    end;
    //JX  -  2022 10 07 END    

    //JX  -  09-2024  -  Delete withhold when revert  
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reversal-Post", 'OnRunOnBeforeDeleteAll', '', false, false)]
    local procedure OnRunOnBeforeDeleteAll
    (
        var ReversalEntry: Record "Reversal Entry";
        Number: Integer
    )
    var
        JXVZWithholdLedgerEntry: Record JXVZWithholdLedgerEntry;
        GLEntry: Record "G/L Entry";
        JXVZPaymentSetup: Record JXVZPaymentSetup;
        CompanyInformation: Record "Company Information";
        JXVZLogicalFactory: Codeunit JXVZLogicalFactory;
        IsVenezuela: Boolean;


    begin
        IsVenezuela := CompanyInformation.JXIsVenezuela();



        if (IsVenezuela) then begin
            JXVZPaymentSetup.Reset();
            if JXVZPaymentSetup.FindFirst() then
                if JXVZPaymentSetup.JXVZDeleteWithholdToRevert then
                    if (ReversalEntry."Document Type" = ReversalEntry."Document Type"::Payment) then begin
                        GLEntry.Reset();
                        GLEntry.SetRange("Document Type", GLEntry."Document Type"::Payment);
                        GLEntry.SetRange("Document No.", ReversalEntry."Document No.");
                        GLEntry.SetRange("Source Type", GLEntry."Source Type"::Vendor);
                        if GLEntry.FindFirst() then begin
                            JXVZLogicalFactory.CancelHistoryPayment(GLEntry."Document No.", GLEntry."Document Date");

                            JXVZWithholdLedgerEntry.Reset();
                            JXVZWithholdLedgerEntry.SetRange(JXVZVoucherNo, GLEntry."Document No.");
                            if JXVZWithholdLedgerEntry.FindSet() then
                                repeat
                                    JXVZWithholdLedgerEntry.Delete(false);
                                until JXVZWithholdLedgerEntry.Next() = 0;
                        end;
                    end;
        end;
    end;
    //JX  -  09-2024  -  Delete withhold when revert END

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnAfterCheckDocumentNo', '', false, false)]
    local procedure OnAfterCheckDocumentNo(var GenJournalLine: Record "Gen. Journal Line"; LastDocNo: code[20]; LastPostedDocNo: code[20])
    var
        JXVZWithholdLedgerEntryByDoc: Record JXVZWithholdLedgerEntryByDoc;
        CompanyInformation: Record "Company Information";
        IsVenezuela: Boolean;
    begin
        IsVenezuela := CompanyInformation.JXIsVenezuela();

        if (IsVenezuela) then
            if LastPostedDocNo <> LastDocNo then begin
                JXVZWithholdLedgerEntryByDoc.Reset();
                JXVZWithholdLedgerEntryByDoc.SetRange(JXVZPaymentJournal, LastDocNo);
                if JXVZWithholdLedgerEntryByDoc.FindSet() then
                    repeat
                        JXVZWithholdLedgerEntryByDoc.JXVZPostedPaymentJournal := LastPostedDocNo;
                        JXVZWithholdLedgerEntryByDoc.Modify(false);
                    until JXVZWithholdLedgerEntryByDoc.Next() = 0;
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purchase-Post Prepayments", 'OnAfterPurchInvLineInsert', '', false, false)]
    local procedure OnAfterPurchInvLineInsert(var PurchInvLine: Record "Purch. Inv. Line"; PurchInvHeader: Record "Purch. Inv. Header"; PrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; CommitIsSupressed: Boolean)
    var
        CompanyInformation: Record "Company Information";
    begin
        if ((CompanyInformation.JXIsVenezuela())) then
            if PurchInvHeader.JXVZWithholdingCode <> '' then
                if PurchInvLine.JXVZWithholdingCode = '' then begin
                    PurchInvLine.JXVZWithholdingCode := PurchInvHeader.JXVZWithholdingCode;
                    PurchInvLine.Modify(false);
                end;
    end;

    /* Comment send to job queue
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterInsertShipmentHeader', '', false, false)]
    local procedure OnAfterInsertShipmentHeader(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header")
    var
        JXVZCotSetup: Record JXVZCotSetup;
        JXVZCot: Codeunit JXVZCot;
    begin
        JXVZCotSetup.Reset();
        if JXVZCotSetup.FindFirst() then
            if JXVZCotSetup.JXCOTAutomaticSend then begin
                Clear(JXVZCot);
                JXVZCot.SendCOTLogicByCode(SalesShipmentHeader);
            end;
    end;
    */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchInvHeaderInsert', '', false, false)]
    local procedure PurchPost_OnAfterPurchInvHeaderInsert(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchHeader: Record "Purchase Header"; PreviewMode: Boolean)
    var
        CompanyInfo: Record "Company Information";
        JXVZWithholdings: Codeunit JXVZWithholdings;
    begin
        if CompanyInfo.JXIsVenezuela() then begin
            if PreviewMode then
                exit;

            JXVZWithholdings.PostPurchaseInvoiceWithholdings(PurchHeader, PurchInvHeader);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterCheckAndUpdate', '', false, false)]
    local procedure OnAfterCheckAndUpdate(var PurchaseHeader: Record "Purchase Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchCrMemoHeaderInsert', '', false, false)]
    local procedure PurchPost_OnAfterPurchCrMemoHeaderInsert(var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean; PreviewMode: Boolean)
    var
        CompanyInfo: Record "Company Information";
        JXVZWithholdings: Codeunit JXVZWithholdings;
    begin
        if CompanyInfo.JXIsVenezuela() then begin
            if PreviewMode or CommitIsSupressed then
                exit;

            JXVZWithholdings.PostPurchaseCrMemoWithholdings(PurchHeader, PurchCrMemoHdr);
        end;
    end;
}