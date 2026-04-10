page 84143 JXVZDocumentsCorrection
{
    UsageCategory = None;
    //ApplicationArea = All;
    Caption = 'Documents correction', Comment = 'ESP=Corrección de documentos';
    PageType = Card;
    Permissions = TableData "G/L Entry" = rimd,
                  TableData "Cust. Ledger Entry" = rimd,
                  TableData Vendor = rimd,
                  TableData "Vendor Ledger Entry" = rimd,
                  TableData "Item Ledger Entry" = rimd,
                  TableData "G/L Register" = rimd,
                  TableData "Sales Shipment Header" = rimd,
                  TableData "Sales Shipment Line" = rimd,
                  TableData "Sales Invoice Header" = rimd,
                  TableData "Sales Invoice Line" = rimd,
                  TableData "Sales Cr.Memo Header" = rimd,
                  TableData "Sales Cr.Memo Line" = rimd,
                  TableData "Purch. Rcpt. Header" = rimd,
                  TableData "Purch. Rcpt. Line" = rimd,
                  TableData "Purch. Inv. Header" = rimd,
                  TableData "Purch. Inv. Line" = rimd,
                  TableData "Purch. Cr. Memo Hdr." = rimd,
                  TableData "Purch. Cr. Memo Line" = rimd,
                  TableData "Res. Ledger Entry" = rimd,
                  TableData "VAT Entry" = rimd,
                  //TableData TableData359=rimd,
                  TableData "Detailed Cust. Ledg. Entry" = rimd,
                  TableData "Detailed Vendor Ledg. Entry" = rimd,
                  TableData "FA Ledger Entry" = rimd,
                  TableData "Value Entry" = rimd,
                  TableData "Service Ledger Entry" = rimd,
                  TableData "Service Shipment Item Line" = rimd,
                  TableData "Service Shipment Header" = rimd,
                  TableData "Service Shipment Line" = rimd,
                  TableData "Service Invoice Header" = rimd,
                  TableData "Service Invoice Line" = rimd,
                  TableData "Service Cr.Memo Header" = rimd,
                  TableData "Service Cr.Memo Line" = rimd,
                  TableData "Item Entry Relation" = rimd,
                  TableData "Value Entry Relation" = rimd,
                  TableData "Warehouse Entry" = rimd,
                  tabledata "Posted Approval Entry" = rimd;

    layout
    {
        area(content)
        {
            group(Purchases)
            {
                Caption = 'Purchases', Comment = 'ESP=Compras';

                field(PurchVoucherType; PurchVoucherType)
                {
                    Caption = 'Document type', Comment = 'ESP=Tipo de documento';
                    Tooltip = 'Document type', Comment = 'ESP=Tipo de documento';
                    OptionCaption = 'Invoices,Credit Memos,Refer', Comment = 'ESP=Facturas,Notas Credito,Remitos';
                    ApplicationArea = All;
                    Enabled = PurchTypeEnable;

                    trigger OnValidate()
                    begin
                        Clear(PurchInvHeader);
                        PurchInvoiceRefresh();
                        Clear(PurchRcptHeader);
                        PurchReferRefresh();
                        Clear(PurchCrMemoHdr);
                        PurchCreditMemoRefresh();
                    end;
                }
                group(PurchaseCurrent)
                {
                    Caption = 'Current', Comment = 'ESP=Actual';

                    /*field(Control1000000018; '')
                    {
                        ApplicationArea = All;
                        CaptionClass = TextJXL0054Lbl;
                        ShowCaption = false;
                        Style = Strong;
                        StyleExpr = TRUE;
                    }*/
                    field(PurchDocumentNo; PurchDocumentNo)
                    {
                        Caption = 'Document no.', Comment = 'ESP=No. documento';
                        ToolTip = 'Document no.', Comment = 'ESP=No. documento';
                        ApplicationArea = All;
                        //Editable = false;
                        //Enabled = PurchNoEnable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            case PurchVoucherType of
                                PurchVoucherType::Facturas:
                                    if PAGE.RunModal(146, PurchInvHeader) = ACTION::LookupOK then
                                        PurchInvoiceRefresh();
                                PurchVoucherType::"Notas Credito":
                                    if PAGE.RunModal(147, PurchCrMemoHdr) = ACTION::LookupOK then
                                        PurchCreditMemoRefresh();
                                PurchVoucherType::Remitos:
                                    if PAGE.RunModal(145, PurchRcptHeader) = ACTION::LookupOK then
                                        PurchReferRefresh();
                            end;
                        end;
                    }
                    field(PurchExternalDocumentNo; PurchExternalDocumentNo)
                    {
                        Caption = 'External document no.', Comment = 'ESP=No. documento externo';
                        ToolTip = 'External document no.', Comment = 'ESP=No. documento externo';
                        ApplicationArea = All;
                        Editable = false;
                        Enabled = PurchExtDocNoEnable;
                    }
                    field(PurchPostingDate; PurchPostingDate)
                    {
                        Caption = 'Posting date', Comment = 'ESP=Fecha de registro';
                        ToolTip = 'Posting date', Comment = 'ESP=Fecha de registro';
                        ApplicationArea = All;
                        Editable = false;
                        Enabled = PurchPostingDateEnable;
                    }
                    field(PurchDocumentDate; PurchDocumentDate)
                    {
                        Caption = 'Document date', Comment = 'ESP=Fecha de documento';
                        ToolTip = 'Document date', Comment = 'ESP=Fecha de documento';
                        ApplicationArea = All;
                        Editable = false;
                        Enabled = PurchDocumentDateEnable;
                    }
                    field(PurchNotShowInBook; PurchNotShowInBook)
                    {
                        Caption = 'Not show in books', Comment = 'ESP=No mostrar en libro';
                        ToolTip = 'Not show in books', Comment = 'ESP=No mostrar en libro';
                        ApplicationArea = All;
                        Editable = false;
                    }

                    field(PurchWithholdingCodeActual; PurchWithholdingCodeActual)
                    {
                        Caption = 'Withhold code', Comment = 'ESP="Codigo retencion"';
                        ToolTip = 'Withhold code', Comment = 'ESP="Codigo retencion"';
                        ApplicationArea = All;
                        Editable = false;
                    }
                }
                group(PurchaseNew)
                {
                    Caption = 'New', Comment = 'ESP=Nuevo';
                    field(PurchNewExternalDocumentNo; PurchNewExternalDocumentNo)
                    {
                        Caption = 'New external document no.', Comment = 'ESP=Nuevo no. documento externo';
                        ToolTip = 'New external document no.', Comment = 'ESP=Nuevo no. documento externo';
                        ApplicationArea = All;
                        Enabled = PurchNewExtDocNoEnable;
                    }
                    field(PurchNewPostingDate; PurchNewPostingDate)
                    {
                        Caption = 'New posting date', Comment = 'ESP=Nueva fecha de registro';
                        ToolTip = 'New posting date', Comment = 'ESP=Nueva fecha de registro';
                        ApplicationArea = All;
                        Enabled = PurchNewPostingDateEnable;

                        trigger OnValidate()
                        begin
                            if PurchNewPostingDate = 0D then begin
                                Message(TextJXL0052Lbl, TextJXL0024Lbl);
                                PurchNewPostingDate := PurchPostingDate;
                            end;
                        end;
                    }
                    field(PurchNewDocumentDate; PurchNewDocumentDate)
                    {
                        Caption = 'New document date', Comment = 'ESP=Nueva fecha de documento';
                        ToolTip = 'New document date', Comment = 'ESP=Nueva fecha de documento';
                        ApplicationArea = All;
                        Enabled = PurchNewDocumentDateEnable;

                        trigger OnValidate()
                        begin
                            if PurchNewDocumentDate = 0D then begin
                                Message(TextJXL0052Lbl, TextJXL0025Lbl);
                                PurchNewDocumentDate := PurchDocumentDate;
                            end;
                        end;
                    }
                    field(PurchNewNotShowInBook; PurchNewNotShowInBook)
                    {
                        Caption = 'New not show si books', Comment = 'ESP=Nuevo no mostrar en libro';
                        ToolTip = 'New not show si books', Comment = 'ESP=Nuevo no mostrar en libro';
                        ApplicationArea = All;
                        Enabled = PurchNewDocumentDateEnable;
                    }

                    field(PurchDespachoNew; PurchDespachoNew)
                    {
                        Caption = 'New dispatch number', Comment = 'ESP=Nuevo numero despacho';
                        ToolTip = 'New dispatch number', Comment = 'ESP=Nuevo numero despacho';
                        ApplicationArea = All;
                        Enabled = PurchNewDocumentDateEnable;
                    }
                    field(PurchWithholdingCodeNew; PurchWithholdingCodeNew)
                    {
                        Caption = 'New withhold code', Comment = 'ESP="Nuevo codigo retencion"';
                        ToolTip = 'New withhold code', Comment = 'ESP="Nuevo codigo retencion"';
                        ApplicationArea = All;
                        Enabled = PurchWithholdingCodeNewEnabled;
                        TableRelation = JXVZWithholdArea.JXVZWithholdingCode;
                    }
                }


            }
            group(Sales)
            {
                Caption = 'Sales', Comment = 'ESP=Ventas';
                field(SalesVoucherType; SalesVoucherType)
                {
                    Caption = 'Document type', Comment = 'ESP=Tipo de documento';
                    ToolTip = 'Document type', Comment = 'ESP=Tipo de documento';
                    OptionCaption = 'Invoices,Credit Memos,Refer', Comment = 'ESP=Facturas,Notas Credito,Remitos';
                    ApplicationArea = All;
                    Enabled = SalesTypeEnable;

                    trigger OnValidate()
                    begin
                        Clear(SalesInvoiceHeader);
                        SalesInvoiceRefresh();
                        Clear(SalesShipmentHeader);
                        SalesReferRefresh();
                        Clear(SalesCrMemoHeader);
                        SalesCreditMemoRefresh();
                    end;
                }
                group(SalesCurrent)
                {
                    Caption = 'Current', Comment = 'ESP=Actual';
                    /*field(Control1000000021; '')
                    {
                        //
                        ApplicationArea = All;
                        CaptionClass = TextTextJXL0056Lbl;
                        ShowCaption = false;
                        Style = Strong;
                        StyleExpr = TRUE;
                    }*/
                    field(SalesDocumentNo; SalesDocumentNo)
                    {
                        Caption = 'Document no.', Comment = 'ESP=No. documento';
                        ToolTip = 'Document no.', Comment = 'ESP=No. documento';
                        ApplicationArea = All;
                        /*Editable = false;
                        Enabled = true;*/

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            case SalesVoucherType of
                                SalesVoucherType::Facturas:
                                    if PAGE.RunModal(143, SalesInvoiceHeader) = ACTION::LookupOK then
                                        SalesInvoiceRefresh();
                                SalesVoucherType::"Notas Credito":
                                    if PAGE.RunModal(144, SalesCrMemoHeader) = ACTION::LookupOK then
                                        SalesCreditMemoRefresh();
                                SalesVoucherType::Remitos:
                                    if PAGE.RunModal(142, SalesShipmentHeader) = ACTION::LookupOK then
                                        SalesReferRefresh();
                            end;
                        end;
                    }
                    field(SalesExternalDocumentNo; SalesExternalDocumentNo)
                    {
                        Caption = 'External document no.', Comment = 'ESP=No. documento externo';
                        ToolTip = 'External document no.', Comment = 'ESP=No. documento externo';
                        ApplicationArea = All;
                        Editable = false;
                        Enabled = SalesExtDocNoEnable;
                    }
                    field(SalesPostingDate; SalesPostingDate)
                    {
                        Caption = 'Posting date', Comment = 'ESP=Fecha de registro';
                        Tooltip = 'Posting date', Comment = 'ESP=Fecha de registro';
                        ApplicationArea = All;
                        Editable = false;
                        Enabled = SalesPostingDateEnable;
                    }
                    field(SalesDocumentDate; SalesDocumentDate)
                    {
                        Caption = 'Document date', Comment = 'ESP=Fecha de documento';
                        Tooltip = 'Document date', Comment = 'ESP=Fecha de documento';
                        ApplicationArea = All;
                        Editable = false;
                        Enabled = SalesDocumentDateEnable;
                    }
                    field(SalesNotShowInBook; SalesNotShowInBook)
                    {
                        Caption = 'Not show in books', Comment = 'ESP=No mostrar en libro';
                        ToolTip = 'Not show in books', Comment = 'ESP=No mostrar en libro';
                        ApplicationArea = All;
                        Editable = false;
                    }
                    /*field(SalesFiscalType; SalesFiscalType)
                    {
                        Caption = 'Fiscal type', Comment = 'ESP=Tipo fiscal';
                        Tooltip = 'Document date', Comment = 'ESP=Tipo fiscal';
                        ApplicationArea = All;
                        Editable = false;
                        Enabled = SalesFiscalTypeEnable;
                    }*/
                }
                group(SalesNew)
                {
                    Caption = 'New', Comment = 'ESP=Nuevo';
                    /*field(Control1000000037; '')
                    {
                        //
                        ApplicationArea = All;
                        CaptionClass = TextTextJXL0057Lbl;
                        ShowCaption = false;
                        Style = Strong;
                        StyleExpr = TRUE;
                    }*/
                    field(SalesNewDocumentNo; SalesNewDocumentNo)
                    {
                        Caption = 'New document no.', Comment = 'ESP=Nuevo no. documento';
                        ToolTip = 'New document no.', Comment = 'ESP=Nuevo no. documento';
                        ApplicationArea = All;
                        Enabled = SalesNewDocNoEnable;
                    }
                    field(SalesNewExternalDocumentNo; SalesNewExternalDocumentNo)
                    {
                        Caption = 'New external document no.', Comment = 'ESP=Nuevo no. documento externo';
                        ToolTip = 'New external document no.', Comment = 'ESP=Nuevo no. documento externo';
                        ApplicationArea = All;
                        Enabled = SalesNewExtDocNoEnable;
                    }
                    field(SalesNewPostingDate; SalesNewPostingDate)
                    {
                        Caption = 'New posting date', Comment = 'ESP=Nueva fecha de registro';
                        Tooltip = 'New posting date', Comment = 'ESP=Nueva fecha de registro';
                        ApplicationArea = All;
                        Enabled = SalesNewPostingDateEnable;

                        trigger OnValidate()
                        begin
                            if SalesNewPostingDate = 0D then begin
                                Message(TextJXL0052Lbl, TextJXL0024Lbl);
                                SalesNewPostingDate := SalesPostingDate;
                            end;
                        end;
                    }
                    field(SalesNewDocumentDate; SalesNewDocumentDate)
                    {
                        Caption = 'New document date', Comment = 'ESP=Nueva fecha de documento';
                        Tooltip = 'New document date', Comment = 'ESP=Nueva fecha de documento';
                        ApplicationArea = All;
                        Enabled = SalesNewDocumentDateEnable;

                        trigger OnValidate()
                        begin
                            if SalesNewDocumentDate = 0D then begin
                                Message(TextJXL0052Lbl, TextJXL0024Lbl);
                                SalesNewDocumentDate := SalesDocumentDate;
                            end;
                        end;
                    }
                    field(SalesNewNotShowInBook; SalesNewNotShowInBook)
                    {
                        Caption = 'New not show si books', Comment = 'ESP=Nuevo no mostrar en libro';
                        ToolTip = 'New not show si books', Comment = 'ESP=Nuevo no mostrar en libro';
                        ApplicationArea = All;
                    }
                    /*field(SalesNewFiscalType; SalesNewFiscalType)
                    {
                        //
                        ApplicationArea = All;
                        Editable = false;
                        Enabled = gVTSNewFiscaltypeEnable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if PAGE.RunModal(0, gFiscalType) = ACTION::LookupOK then SalesNewFiscalType := gFiscalType.Code;
                        end;
                    }*/
                }
            }
            /*group(Service)
            {
                Caption = 'Service', Comment = 'ESP=Servicio';
                field(ServTip; gServVoucherType)
                {
                    Caption = 'Document type', Comment = 'ESP=Tipo de documento';
                    ToolTip = 'Document type', Comment = 'ESP=Tipo de documento';
                    ApplicationArea = All;
                    Enabled = true;

                    trigger OnValidate()
                    begin
                        Clear(SalesInvoiceHeader);
                        SalesInvoiceRefresh();
                        Clear(SalesShipmentHeader);
                        SalesReferRefresh();
                        Clear(SalesCrMemoHeader);
                        SalesCreditMemoRefresh();
                    end;
                }
                field(Control1100227012; '')
                {
                    //
                    ApplicationArea = All;
                    CaptionClass = TextTextJXL0056;
                    ShowCaption = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(gServDocNo; gServDocNo)
                {
                    Caption = 'Document no.', Comment = 'ESP=No. documento';
                    ToolTip = 'Document no.', Comment = 'ESP=No. documento';
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = true;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        case gServVoucherType of
                            gServVoucherType::Facturas:
                                if PAGE.RunModal(5977, gServSalesHeader) = ACTION::LookupOK then
                                    ServiceInvoiceRefresh();
                            gServVoucherType::"Notas Credito":
                                if PAGE.RunModal(5971, gServCreditNoteHeader) = ACTION::LookupOK then
                                    ServiceCreditMemoRefresh();
                        end;
                    end;
                }
                field(gServDocNoExt; gServDocNoExt)
                {
                    Caption = 'External document no.', Comment = 'ESP=No. documento externo';
                    ToolTip = 'External document no.', Comment = 'ESP=No. documento externo';
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = SalesExtDocNoEnable;
                }
                field(gServPostingDate; gServPostingDate)
                {
                    Caption = 'Posting date', Comment = 'ESP=No. documento externo';
                    ToolTip = 'Posting date', Comment = 'ESP=No. documento externo';
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = SalesPostingDateEnable;
                }
                field(gServDacDate; gServDacDate)
                {
                    Caption = 'Document date', Comment = 'ESP=Fecha de documento';
                    Tooltip = 'Document date', Comment = 'ESP=Fecha de documento';
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = SalesDocumentDateEnable;
                }
                field(gServFiscalType; gServFiscalType)
                {
                    Caption = 'Fiscal type', Comment = 'ESP=Tipo fiscal';
                    Tooltip = 'Fiscal type', Comment = 'ESP=Tipo fiscal';
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = SalesFiscalTypeEnable;
                }
                field(Control1100227006; '')
                {
                    //
                    ApplicationArea = All;
                    CaptionClass = TextTextJXL0057;
                    ShowCaption = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(gServNewDocNo; gServNewDocNo)
                {
                    //
                    ApplicationArea = All;
                    Enabled = gServNewDocNoEnable;
                }
                field(gServNewExtDocNo; gServNewExtDocNo)
                {
                    //
                    ApplicationArea = All;
                    Enabled = gServNewextdocnoEnable;
                }
                field(gServNewPostingDate; gServNewPostingDate)
                {
                    //
                    ApplicationArea = All;
                    Enabled = gServNewPostingDateEnable;

                    trigger OnValidate()
                    begin
                        if gServNewPostingDate = 0D then begin
                            Message(TextJXL0052, TextJXL0024);
                            gServNewPostingDate := gServPostingDate;
                        end;
                    end;
                }
                field(gServNewDocDate; gServNewDocDate)
                {
                    //
                    ApplicationArea = All;
                    Enabled = gServNewDocDateEnable;

                    trigger OnValidate()
                    begin
                        if gServNewDocDate = 0D then begin
                            Message(TextJXL0052, TextJXL0024);
                            gServNewDocDate := gServDacDate;
                        end;
                    end;
                }
                field(gServNewFiscalType; gServNewFiscalType)
                {
                    //
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = gServNewFiscaltypeEnable;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if PAGE.RunModal(0, gFiscalType) = ACTION::LookupOK then
                            gServNewFiscalType := gFiscalType.Code;
                    end;
                }
            }*/
        }
    }

    actions
    {
        area(processing)
        {
            action(SalesNavigate)
            {
                Caption = 'Sales navigate', Comment = 'ESP=Ventas navegar';
                ToolTip = 'Sales navigate', Comment = 'ESP=Ventas navegar';
                ApplicationArea = All;
                Enabled = SalesNavigateEnable;
                Promoted = true;
                PromotedCategory = Process;
                Image = Navigate;

                trigger OnAction()
                begin
                    gNavigate.SetDoc(SalesPostingDate, SalesDocumentNo);
                    gNavigate.Run();
                end;
            }
            action(PurchNavigate)
            {
                Caption = 'Purchase navigate', Comment = 'ESP=Compras navegar';
                ToolTip = 'Purchase navigate', Comment = 'ESP=Compras navegar';
                ApplicationArea = All;
                Enabled = NavigateEnable;
                Promoted = true;
                PromotedCategory = Process;
                Image = Navigate;

                trigger OnAction()
                begin
                    gNavigate.SetDoc(PurchPostingDate, PurchDocumentNo);
                    gNavigate.Run();
                end;
            }
            action(PurchaseModify)
            {
                Caption = 'Purchase modify', Comment = 'ESP=Modificar compra';
                ToolTip = 'Purchase modify', Comment = 'ESP=Modificar compra';
                ApplicationArea = All;
                Enabled = PurchModifyEnable;
                Promoted = true;
                PromotedCategory = Process;
                Image = Edit;

                trigger OnAction()
                var
                    PurchInvLineLocal: Record "Purch. Inv. Line";
                    PurchCrMemoLineLocal: Record "Purch. Cr. Memo Line";
                begin
                    case PurchVoucherType of
                        PurchVoucherType::Facturas:
                            begin
                                //External doc no
                                if PurchExternalDocumentNo <> PurchNewExternalDocumentNo then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VendorLedgerEntry.Reset();
                                    DetailedVendorLedgEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", PurchInvHeader."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    GLEntry.SetRange(GLEntry."Document No.", PurchInvHeader."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", PurchInvHeader."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", PurchInvHeader."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    ValueEntry.SetRange(ValueEntry."Document No.", PurchInvHeader."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", PurchInvHeader."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    VendorLedgerEntry.SetRange(VendorLedgerEntry."Document No.", PurchInvHeader."No.");
                                    if VendorLedgerEntry.FindFirst() then
                                        VendorLedgerEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    PurchInvHeader."Vendor Invoice No." := PurchNewExternalDocumentNo;

                                    PurchInvHeader.Modify();

                                end;

                                //Posting date
                                if PurchPostingDate <> PurchNewPostingDate then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VendorLedgerEntry.Reset();
                                    DetailedVendorLedgEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", PurchInvHeader."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    /*////////-----Esta version de Nav no tiene postindate en G/L REGISTER
                                    gglentry.SETRANGE(gglentry."Document No.",PurchInvHeader."No.");
                                    IF gglentry.FIND('-') THEN
                                        REPEAT
                                         gGlRegister.RESET;
                                         gGlRegister.SETRANGE(gGlRegister."From Entry No.",
                                                                      gglentry."Entry No.");
                                         IF gGlRegister.FIND('-') THEN
                                            BEGIN
                                             gGlRegister."Posting Date":=PurchNewPostingDate;
                                             gGlRegister.MODIFY
                                            END;
                                        UNTIL gglentry.NEXT=0;*/
                                    GLEntry.Reset();
                                    GLEntry.SetRange(GLEntry."Document No.", PurchInvHeader."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", PurchInvHeader."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", PurchInvHeader."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    ValueEntry.SetRange(ValueEntry."Document No.", PurchInvHeader."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", PurchInvHeader."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    VendorLedgerEntry.SetRange(VendorLedgerEntry."Document No.", PurchInvHeader."No.");
                                    if VendorLedgerEntry.FindFirst() then
                                        VendorLedgerEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    DetailedVendorLedgEntry.SetRange(DetailedVendorLedgEntry."Document No.", PurchInvHeader."No.");
                                    if DetailedVendorLedgEntry.FindFirst() then
                                        DetailedVendorLedgEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    PurchInvHeader."Posting Date" := PurchNewPostingDate;

                                    PurchInvHeader.Modify();
                                end;
                                //Document date
                                if PurchDocumentDate <> PurchNewDocumentDate then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VendorLedgerEntry.Reset();
                                    DetailedVendorLedgEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", PurchInvHeader."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    GLEntry.SetRange(GLEntry."Document No.", PurchInvHeader."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", PurchInvHeader."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", PurchInvHeader."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    ValueEntry.SetRange(ValueEntry."Document No.", PurchInvHeader."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", PurchInvHeader."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    VendorLedgerEntry.SetRange(VendorLedgerEntry."Document No.", PurchInvHeader."No.");
                                    if VendorLedgerEntry.FindFirst() then
                                        VendorLedgerEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    PurchInvHeader."Document Date" := PurchNewDocumentDate;

                                    PurchInvHeader.Modify();
                                end;
                                //Tipo fiscal
                                /*if PurchFiscalType <> PurchNewFiscalType then begin
                                    PurchInvHeader."Fiscal Type" := PurchNewFiscalType;
                                    PurchInvHeader.Modify();
                                end;*/

                                //new withhold code
                                if (PurchWithholdingCodeNew <> '') then begin
                                    PurchInvHeader.JXVZWithholdingCode := PurchWithholdingCodeNew;
                                    PurchInvHeader.Modify(false);

                                    PurchInvLineLocal.Reset();
                                    PurchInvLineLocal.SetRange("Document No.", PurchInvHeader."No.");
                                    if PurchInvLineLocal.FindSet() then
                                        repeat
                                            PurchInvLineLocal.JXVZWithholdingCode := PurchWithholdingCodeNew;
                                            PurchInvLineLocal.Modify(false);
                                        until PurchInvLineLocal.Next() = 0;
                                end;

                                PurchInvoiceRefresh();

                            end;

                        PurchVoucherType::"Notas Credito":
                            begin
                                //External doc no.
                                if PurchExternalDocumentNo <> PurchNewExternalDocumentNo then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VendorLedgerEntry.Reset();
                                    DetailedVendorLedgEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", PurchCrMemoHdr."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    GLEntry.SetRange(GLEntry."Document No.", PurchCrMemoHdr."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", PurchCrMemoHdr."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", PurchCrMemoHdr."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    ValueEntry.SetRange(ValueEntry."Document No.", PurchCrMemoHdr."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", PurchCrMemoHdr."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    VendorLedgerEntry.SetRange(VendorLedgerEntry."Document No.", PurchCrMemoHdr."No.");
                                    if VendorLedgerEntry.FindFirst() then
                                        VendorLedgerEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    PurchCrMemoHdr."Vendor Cr. Memo No." := PurchNewExternalDocumentNo;

                                    PurchCrMemoHdr.Modify();

                                end;


                                //Posting date
                                if PurchPostingDate <> PurchNewPostingDate then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VendorLedgerEntry.Reset();
                                    DetailedVendorLedgEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", PurchCrMemoHdr."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    /*////////-----Esta version de Nav no tiene postindate en G/L REGISTER
                                    gglentry.SETRANGE(gglentry."Document No.",PurchCrMemoHdr."No.");
                                    IF gglentry.FIND('-') THEN
                                        REPEAT
                                         gGlRegister.RESET;
                                         gGlRegister.SETRANGE(gGlRegister."From Entry No.",
                                                                      gglentry."Entry No.");
                                         IF gGlRegister.FIND('-') THEN
                                            BEGIN
                                             gGlRegister."Posting Date":=PurchNewPostingDate;
                                             gGlRegister.MODIFY
                                            END;
                                        UNTIL gglentry.NEXT=0;   */
                                    GLEntry.Reset();
                                    GLEntry.SetRange(GLEntry."Document No.", PurchCrMemoHdr."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", PurchCrMemoHdr."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", PurchCrMemoHdr."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    ValueEntry.SetRange(ValueEntry."Document No.", PurchCrMemoHdr."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", PurchCrMemoHdr."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    VendorLedgerEntry.SetRange(VendorLedgerEntry."Document No.", PurchCrMemoHdr."No.");
                                    if VendorLedgerEntry.FindFirst() then
                                        VendorLedgerEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    DetailedVendorLedgEntry.SetRange(DetailedVendorLedgEntry."Document No.", PurchCrMemoHdr."No.");
                                    if DetailedVendorLedgEntry.FindFirst() then
                                        DetailedVendorLedgEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    PurchCrMemoHdr."Posting Date" := PurchNewPostingDate;

                                    PurchCrMemoHdr.Modify();
                                end;
                                // Doc Date
                                if PurchDocumentDate <> PurchNewDocumentDate then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VendorLedgerEntry.Reset();
                                    DetailedVendorLedgEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", PurchCrMemoHdr."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    GLEntry.SetRange(GLEntry."Document No.", PurchCrMemoHdr."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", PurchCrMemoHdr."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", PurchCrMemoHdr."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    ValueEntry.SetRange(ValueEntry."Document No.", PurchCrMemoHdr."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", PurchCrMemoHdr."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    VendorLedgerEntry.SetRange(VendorLedgerEntry."Document No.", PurchCrMemoHdr."No.");
                                    if VendorLedgerEntry.FindFirst() then
                                        VendorLedgerEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    PurchCrMemoHdr."Document Date" := PurchNewDocumentDate;

                                    PurchCrMemoHdr.Modify();
                                end;
                                // Fiscal Type
                                /*if PurchFiscalType <> PurchNewFiscalType then begin
                                    PurchCrMemoHdr."Behaviour Code" := PurchNewFiscalType;
                                    PurchCrMemoHdr.Modify()
                                end;*/

                                //new withhold code
                                if (PurchWithholdingCodeNew <> '') then begin
                                    PurchCrMemoHdr.JXVZWithholdingCode := PurchWithholdingCodeNew;
                                    PurchCrMemoHdr.Modify(false);

                                    PurchCrMemoLineLocal.Reset();
                                    PurchCrMemoLineLocal.SetRange("Document No.", PurchCrMemoHdr."No.");
                                    if PurchCrMemoLineLocal.FindSet() then
                                        repeat
                                            PurchCrMemoLineLocal.JXVZWithholdingCode := PurchWithholdingCodeNew;
                                            PurchCrMemoLineLocal.Modify(false);
                                        until PurchCrMemoLineLocal.Next() = 0;
                                end;

                                PurchCreditMemoRefresh();

                            end;

                        PurchVoucherType::Remitos:
                            begin
                                // External doc no.
                                if PurchExternalDocumentNo <> PurchNewExternalDocumentNo then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VendorLedgerEntry.Reset();
                                    DetailedVendorLedgEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", PurchRcptHeader."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    GLEntry.SetRange(GLEntry."Document No.", PurchRcptHeader."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", PurchRcptHeader."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", PurchRcptHeader."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    ValueEntry.SetRange(ValueEntry."Document No.", PurchRcptHeader."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", PurchRcptHeader."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    VendorLedgerEntry.SetRange(VendorLedgerEntry."Document No.", PurchRcptHeader."No.");
                                    if VendorLedgerEntry.FindFirst() then
                                        VendorLedgerEntry.ModifyAll("External Document No.", PurchNewExternalDocumentNo);
                                    PurchRcptHeader."Vendor Order No." := PurchNewExternalDocumentNo;

                                    PurchRcptHeader.Modify();

                                end;

                                // Posting date
                                if PurchPostingDate <> PurchNewPostingDate then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VendorLedgerEntry.Reset();
                                    DetailedVendorLedgEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", PurchRcptHeader."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    /*////////-----Esta version de Nav no tiene postindate en G/L REGISTER
                                        gglentry.SETRANGE(gglentry."Document No.",PurchRcptHeader."No.");
                                        IF gglentry.FIND('-') THEN
                                            REPEAT
                                             gGlRegister.RESET;
                                             gGlRegister.SETRANGE(gGlRegister."From Entry No.",
                                                                          gglentry."Entry No.");
                                             IF gGlRegister.FIND('-') THEN
                                                BEGIN
                                                 gGlRegister."Posting Date":=PurchNewPostingDate;
                                                 gGlRegister.MODIFY
                                                END;
                                            UNTIL gglentry.NEXT=0;   */
                                    GLEntry.Reset();
                                    GLEntry.SetRange(GLEntry."Document No.", PurchRcptHeader."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", PurchRcptHeader."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", PurchRcptHeader."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    ValueEntry.SetRange(ValueEntry."Document No.", PurchRcptHeader."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", PurchRcptHeader."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    VendorLedgerEntry.SetRange(VendorLedgerEntry."Document No.", PurchRcptHeader."No.");
                                    if VendorLedgerEntry.FindFirst() then
                                        VendorLedgerEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    DetailedVendorLedgEntry.SetRange(DetailedVendorLedgEntry."Document No.", PurchRcptHeader."No.");
                                    if DetailedVendorLedgEntry.FindFirst() then
                                        DetailedVendorLedgEntry.ModifyAll("Posting Date", PurchNewPostingDate);
                                    PurchRcptHeader."Posting Date" := PurchNewPostingDate;

                                    PurchRcptHeader.Modify();
                                end;
                                // Doc date
                                if PurchDocumentDate <> PurchNewDocumentDate then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VendorLedgerEntry.Reset();
                                    DetailedVendorLedgEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", PurchRcptHeader."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    GLEntry.SetRange(GLEntry."Document No.", PurchRcptHeader."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", PurchRcptHeader."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", PurchRcptHeader."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    ValueEntry.SetRange(ValueEntry."Document No.", PurchRcptHeader."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", PurchRcptHeader."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    VendorLedgerEntry.SetRange(VendorLedgerEntry."Document No.", PurchRcptHeader."No.");
                                    if VendorLedgerEntry.FindFirst() then
                                        VendorLedgerEntry.ModifyAll("Document Date", PurchNewDocumentDate);
                                    PurchRcptHeader."Document Date" := PurchNewDocumentDate;

                                    PurchRcptHeader.Modify();
                                end;
                                // Fiscal type
                                /*IF PurchFiscalType<>PurchNewFiscalType THEN
                                BEGIN
                                PurchRcptHeader."Tipo Fiscal":=PurchNewFiscalType;
                                PurchRcptHeader.MODIFY
                                END;*/
                                PurchReferRefresh();


                            end;
                    end;
                    Message(TextJXL0053Lbl);

                end;
            }
            action(SalesModify)
            {
                Caption = 'Sales modify', Comment = 'ESP=Modificar venta';
                ToolTip = 'Sales modify', Comment = 'ESP=Modificar venta';
                ApplicationArea = All;
                Enabled = SalesModifyEnable;
                Promoted = true;
                PromotedCategory = Process;
                Image = Edit;

                trigger OnAction()
                var
                    lclPostedApprov: Record "Posted Approval Entry";
                    lclPostedApprov1: Record "Posted Approval Entry";
                    lclLineCommentLines: Record "Sales Comment Line";
                    lclLineCommentLines1: Record "Sales Comment Line";
                begin
                    case SalesVoucherType of
                        SalesVoucherType::Facturas:
                            begin
                                //External doc no
                                if SalesExternalDocumentNo <> SalesNewExternalDocumentNo then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    CustLedgerEntry.Reset();
                                    DetailedCustLedgEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", SalesInvoiceHeader."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                                    GLEntry.SetRange(GLEntry."Document No.", SalesInvoiceHeader."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                                    CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                                    if CustLedgerEntry.FindFirst() then
                                        CustLedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                                    ValueEntry.SetRange(ValueEntry."Document No.", SalesInvoiceHeader."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesInvoiceHeader."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);

                                    SalesInvoiceHeader."External Document No." := SalesNewExternalDocumentNo;
                                    SalesInvoiceHeader.Modify();

                                end;

                                // Posting date
                                if SalesPostingDate <> SalesNewPostingDate then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    CustLedgerEntry.Reset();
                                    DetailedCustLedgEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", SalesInvoiceHeader."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    /*////////-----Esta version de Nav no tiene postindate en G/L REGISTER
                                         gglentry.SETRANGE(gglentry."Document No.",SalesInvoiceHeader."No.");
                                         IF gglentry.FIND('-') THEN
                                             REPEAT
                                              gGlRegister.RESET;
                                              gGlRegister.SETRANGE(gGlRegister."From Entry No.",
                                                                           gglentry."Entry No.");
                                              IF gGlRegister.FIND('-') THEN
                                                 BEGIN
                                                  gGlRegister."Posting Date":=SalesNewPostingDate;
                                                  gGlRegister.MODIFY
                                                 END;
                                             UNTIL gglentry.NEXT=0; */
                                    GLEntry.Reset();
                                    GLEntry.SetRange(GLEntry."Document No.", SalesInvoiceHeader."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    ValueEntry.SetRange(ValueEntry."Document No.", SalesInvoiceHeader."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesInvoiceHeader."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                                    if CustLedgerEntry.FindFirst() then
                                        CustLedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Document No.", SalesInvoiceHeader."No.");
                                    if DetailedCustLedgEntry.FindFirst() then
                                        DetailedCustLedgEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    SalesInvoiceHeader."Posting Date" := SalesNewPostingDate;
                                    SalesInvoiceHeader.Modify();
                                end;
                                //Doc date
                                if SalesDocumentDate <> SalesNewDocumentDate then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    CustLedgerEntry.Reset();
                                    DetailedCustLedgEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", SalesInvoiceHeader."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    GLEntry.SetRange(GLEntry."Document No.", SalesInvoiceHeader."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    ValueEntry.SetRange(ValueEntry."Document No.", SalesInvoiceHeader."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesInvoiceHeader."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                                    if CustLedgerEntry.FindFirst() then
                                        CustLedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    SalesInvoiceHeader."Document Date" := SalesNewDocumentDate;

                                    SalesInvoiceHeader.Modify();
                                end;

                                //Fiscal date
                                /*if SalesFiscalType <> SalesNewFiscalType then begin
                                    SalesInvoiceHeader."Fiscal Type" := SalesNewFiscalType;
                                    SalesInvoiceHeader.Modify()
                                end;*/
                                //Actual doc no
                                if SalesDocumentNo <> SalesNewDocumentNo then begin
                                    SalesInvoiceHeader2.Reset();
                                    SalesInvoiceHeader2.SetRange(SalesInvoiceHeader2."No.", SalesNewDocumentNo);
                                    if SalesInvoiceHeader2.FindFirst() then
                                        Message(TextJXL00002Lbl, SalesNewExternalDocumentNo)
                                    else begin
                                        lclLineCommentLines.Reset();
                                        lclLineCommentLines1.Reset();
                                        lclPostedApprov.Reset();
                                        lclPostedApprov1.Reset();

                                        VatEntry.Reset();
                                        GLEntry.Reset();
                                        CustLedgerEntry.Reset();
                                        DetailedCustLedgEntry.Reset();
                                        ResLedgerEntry.Reset();
                                        ItemLedgerEntry.Reset();
                                        ValueEntry.Reset();
                                        ValueEntry2.Reset();
                                        FALedgerEntry.Reset();
                                        JXVZHistReceiptVoucherLine.Reset();
                                        SalesInvoiceLine.Reset();
                                        ItemEntryRelation.Reset();
                                        ValueEntryRelation.Reset();

                                        lclLineCommentLines.SetRange(lclLineCommentLines."No.", SalesDocumentNo);
                                        lclLineCommentLines.SetRange(lclLineCommentLines."Document Type",
                                        lclLineCommentLines."Document Type"::"Posted Invoice");
                                        if lclLineCommentLines.FindFirst() then
                                            repeat
                                                lclLineCommentLines1.SetCurrentKey("Document Type", "No.", "Document Line No.", "Line No.");
                                                lclLineCommentLines1.Get(lclLineCommentLines."Document Type",
                                                 lclLineCommentLines."No.", lclLineCommentLines."Document Line No.",
                                                 lclLineCommentLines."Line No.");
                                                lclLineCommentLines1.Rename(lclLineCommentLines."Document Type",
                                                 SalesNewDocumentNo, lclLineCommentLines."Document Line No.",
                                                 lclLineCommentLines."Line No.");
                                            until lclLineCommentLines.Next() = 0;

                                        lclPostedApprov.SetRange(lclPostedApprov."Document No.", SalesDocumentNo);
                                        lclPostedApprov.SetRange(lclPostedApprov."Table ID", 112);
                                        if lclPostedApprov.FindFirst() then
                                            repeat
                                                lclPostedApprov1.SetCurrentKey("Table ID", "Document No.", "Sequence No.");
                                                lclPostedApprov1.SetRange("Table ID", lclPostedApprov."Table ID");
                                                lclPostedApprov1.SetRange("Document No.", lclPostedApprov."Document No.");
                                                lclPostedApprov1.SetRange("Sequence No.", lclPostedApprov."Sequence No.");
                                                if lclPostedApprov1.FindFirst() then begin
                                                    lclPostedApprov1."Document No." := SalesNewDocumentNo;
                                                    lclPostedApprov1.Modify(false);
                                                end;
                                            /*Old Code
                                            lclPostedApprov1.Get(lclPostedApprov."Table ID",
                                             lclPostedApprov."Document No.", lclPostedApprov."Sequence No.");

                                            lclPostedApprov1.Rename(lclPostedApprov."Table ID",
                                             SalesNewDocumentNo, lclPostedApprov."Sequence No.");
                                             */
                                            until lclPostedApprov.Next() = 0;

                                        SalesInvoiceLine.SetRange(SalesInvoiceLine."Document No.", SalesInvoiceHeader."No.");
                                        if SalesInvoiceLine.FindFirst() then
                                            repeat
                                                SalesInvoiceLine2.SetCurrentKey("Document No.", "Line No.");
                                                SalesInvoiceLine2.Get(SalesInvoiceLine."Document No.", SalesInvoiceLine."Line No.");
                                                SalesInvoiceLine2.Rename(SalesNewDocumentNo, SalesInvoiceLine."Line No.");
                                            until SalesInvoiceLine.Next() = 0;
                                        VatEntry.SetRange(VatEntry."Document No.", SalesInvoiceHeader."No.");
                                        if VatEntry.FindFirst() then
                                            VatEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        GLEntry.SetRange(GLEntry."Document No.", SalesInvoiceHeader."No.");
                                        if GLEntry.FindFirst() then
                                            GLEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                                        if ResLedgerEntry.FindFirst() then
                                            ResLedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                                        if ItemLedgerEntry.FindFirst() then
                                            ItemLedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        ValueEntry.SetRange(ValueEntry."Document No.", SalesInvoiceHeader."No.");
                                        ValueEntry2.SetRange(ValueEntry2."Document No.", SalesInvoiceHeader."No.");
                                        if ValueEntry2.FindFirst() then
                                            repeat
                                                OK := ValueEntryRelation.Get(ValueEntry2."Entry No.");
                                                if OK then begin
                                                    Clear(Pos);
                                                    Pos := StrPos(ValueEntryRelation."Source RowId", SalesDocumentNo);
                                                    if Pos <> 0 then begin
                                                        ValueEntryRelation."Source RowId" :=
                                                         DelStr(ValueEntryRelation."Source RowId", Pos, StrLen(SalesDocumentNo));

                                                        ValueEntryRelation."Source RowId" :=
                                                         InsStr(ValueEntryRelation."Source RowId", SalesNewDocumentNo, Pos);
                                                        ValueEntryRelation.Modify();
                                                    end;
                                                end;
                                            until ValueEntry2.Next() = 0;
                                        if ValueEntry.FindFirst() then
                                            ValueEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesInvoiceHeader."No.");
                                        if FALedgerEntry.FindFirst() then
                                            FALedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                                        if CustLedgerEntry.FindFirst() then
                                            CustLedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Document No.", SalesInvoiceHeader."No.");
                                        if DetailedCustLedgEntry.FindFirst() then
                                            DetailedCustLedgEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        ItemEntryRelation.SetRange(ItemEntryRelation."Source ID", SalesInvoiceHeader."No.");
                                        if ItemEntryRelation.FindFirst() then
                                            ItemEntryRelation.ModifyAll(ItemEntryRelation."Source ID", SalesNewDocumentNo);
                                        JXVZHistReceiptVoucherLine.SetRange(JXVZHistReceiptVoucherLine.JXVZVoucherNo, SalesInvoiceHeader."No.");
                                        if JXVZHistReceiptVoucherLine.FindFirst() then
                                            repeat
                                                JXVZHistReceiptVoucherLine2.Get(
                                                                          JXVZHistReceiptVoucherLine.JXVZReceiptNo,
                                                                          JXVZHistReceiptVoucherLine.JXVZVoucherNo,
                                                                          JXVZHistReceiptVoucherLine.JXVZEntryNo);
                                                JXVZHistReceiptVoucherLine.Rename(JXVZHistReceiptVoucherLine2.JXVZReceiptNo,
                                                                            SalesNewDocumentNo, JXVZHistReceiptVoucherLine2.JXVZEntryNo);

                                            until JXVZHistReceiptVoucherLine.Next() = 0;


                                        SalesInvoiceHeader.Rename(SalesNewDocumentNo);
                                    end;
                                end;

                                SalesInvoiceRefresh();

                            end;

                        SalesVoucherType::"Notas Credito":
                            begin
                                //  External doc no
                                if SalesExternalDocumentNo <> SalesNewExternalDocumentNo then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    CustLedgerEntry.Reset();
                                    DetailedCustLedgEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", SalesCrMemoHeader."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                                    GLEntry.SetRange(GLEntry."Document No.", SalesCrMemoHeader."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                                    CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                                    if CustLedgerEntry.FindFirst() then
                                        CustLedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                                    ValueEntry.SetRange(ValueEntry."Document No.", SalesCrMemoHeader."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesCrMemoHeader."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);

                                    SalesCrMemoHeader."External Document No." := SalesNewExternalDocumentNo;
                                    SalesCrMemoHeader.Modify();

                                end;

                                //Posting date
                                if SalesPostingDate <> SalesNewPostingDate then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    CustLedgerEntry.Reset();
                                    DetailedCustLedgEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", SalesCrMemoHeader."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    /*////////-----Esta version de Nav no tiene postindate en G/L REGISTER
                                       gglentry.SETRANGE(gglentry."Document No.",SalesCrMemoHeader."No.");
                                       IF gglentry.FIND('-') THEN
                                           REPEAT
                                            gGlRegister.RESET;
                                            gGlRegister.SETRANGE(gGlRegister."From Entry No.",
                                                                         gglentry."Entry No.");
                                            IF gGlRegister.FIND('-') THEN
                                               BEGIN
                                                gGlRegister."Posting Date":=SalesNewPostingDate;
                                                gGlRegister.MODIFY
                                               END;
                                           UNTIL gglentry.NEXT=0; */
                                    GLEntry.Reset();
                                    GLEntry.SetRange(GLEntry."Document No.", SalesCrMemoHeader."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    ValueEntry.SetRange(ValueEntry."Document No.", SalesCrMemoHeader."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesCrMemoHeader."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                                    if CustLedgerEntry.FindFirst() then
                                        CustLedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Document No.", SalesCrMemoHeader."No.");
                                    if DetailedCustLedgEntry.FindFirst() then
                                        DetailedCustLedgEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    SalesCrMemoHeader."Posting Date" := SalesNewPostingDate;

                                    SalesCrMemoHeader.Modify();
                                end;
                                //Doc date
                                if SalesDocumentDate <> SalesNewDocumentDate then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    CustLedgerEntry.Reset();
                                    DetailedCustLedgEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", SalesCrMemoHeader."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    GLEntry.SetRange(GLEntry."Document No.", SalesCrMemoHeader."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    ValueEntry.SetRange(ValueEntry."Document No.", SalesCrMemoHeader."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesCrMemoHeader."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                                    if CustLedgerEntry.FindFirst() then
                                        CustLedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    SalesCrMemoHeader."Document Date" := SalesNewDocumentDate;

                                    SalesCrMemoHeader.Modify();
                                end;
                                //Fiscal type
                                /*if SalesFiscalType <> SalesNewFiscalType then begin
                                    SalesCrMemoHeader."Fiscal Type" := SalesNewFiscalType;
                                    SalesCrMemoHeader.Modify()
                                end;*/

                                //Actual doc no
                                if SalesDocumentNo <> SalesNewDocumentNo then begin
                                    SalesCrMemoHeader2.Reset();
                                    SalesCrMemoHeader2.SetRange(SalesCrMemoHeader2."No.", SalesNewDocumentNo);
                                    if SalesCrMemoHeader2.FindFirst() then
                                        Message(TextJXL00002Lbl, SalesNewExternalDocumentNo)
                                    else begin
                                        lclLineCommentLines.Reset();
                                        lclLineCommentLines1.Reset();
                                        lclPostedApprov.Reset();
                                        lclPostedApprov1.Reset();

                                        VatEntry.Reset();
                                        GLEntry.Reset();
                                        CustLedgerEntry.Reset();
                                        DetailedCustLedgEntry.Reset();
                                        ResLedgerEntry.Reset();
                                        ItemLedgerEntry.Reset();
                                        ValueEntry.Reset();
                                        ValueEntry2.Reset();
                                        FALedgerEntry.Reset();
                                        ItemEntryRelation.Reset();
                                        ValueEntryRelation.Reset();
                                        JXVZHistReceiptVoucherLine.Reset();

                                        lclLineCommentLines.SetRange(lclLineCommentLines."No.", SalesDocumentNo);
                                        lclLineCommentLines.SetRange(lclLineCommentLines."Document Type",
                                        lclLineCommentLines."Document Type"::"Posted Credit Memo");
                                        if lclLineCommentLines.FindFirst() then
                                            repeat
                                                lclLineCommentLines1.SetCurrentKey("Document Type", "No.", "Document Line No.", "Line No.");
                                                lclLineCommentLines1.Get(lclLineCommentLines."Document Type",
                                                 lclLineCommentLines."No.", lclLineCommentLines."Document Line No.",
                                                 lclLineCommentLines."Line No.");
                                                lclLineCommentLines1.Rename(lclLineCommentLines."Document Type",
                                                 SalesNewDocumentNo, lclLineCommentLines."Document Line No.",
                                                 lclLineCommentLines."Line No.");
                                            until lclLineCommentLines.Next() = 0;

                                        lclPostedApprov.SetRange(lclPostedApprov."Document No.", SalesDocumentNo);
                                        lclPostedApprov.SetRange(lclPostedApprov."Table ID", 114);
                                        if lclPostedApprov.FindFirst() then
                                            repeat
                                                lclPostedApprov1.SetCurrentKey("Table ID", "Document No.", "Sequence No.");
                                                lclPostedApprov1.SetRange("Table ID", lclPostedApprov."Table ID");
                                                lclPostedApprov1.SetRange("Document No.", lclPostedApprov."Document No.");
                                                lclPostedApprov1.SetRange("Sequence No.", lclPostedApprov."Sequence No.");
                                                if lclPostedApprov1.FindFirst() then begin
                                                    lclPostedApprov1."Document No." := SalesNewDocumentNo;
                                                    lclPostedApprov1.Modify(false);
                                                end;
                                            /* Old Code
                                            lclPostedApprov1.SetCurrentKey("Table ID", "Document No.", "Sequence No.");
                                            lclPostedApprov1.Get(lclPostedApprov."Table ID",
                                             lclPostedApprov."Document No.", lclPostedApprov."Sequence No.");
                                            lclPostedApprov1.Rename(lclPostedApprov."Table ID",
                                             SalesNewDocumentNo, lclPostedApprov."Sequence No.");
                                             */
                                            until lclPostedApprov.Next() = 0;

                                        SalesCrMemoLine.Reset();
                                        SalesCrMemoLine.SetRange(SalesCrMemoLine."Document No.", SalesCrMemoHeader."No.");
                                        if SalesCrMemoLine.FindFirst() then
                                            repeat
                                                SalesCrMemoLine2.SetCurrentKey("Document No.", "Line No.");
                                                SalesCrMemoLine2.Get(SalesCrMemoLine."Document No.", SalesCrMemoLine."Line No.");
                                                SalesCrMemoLine2.Rename(SalesNewDocumentNo, SalesCrMemoLine."Line No.");
                                            until SalesCrMemoLine.Next() = 0;
                                        VatEntry.SetRange(VatEntry."Document No.", SalesCrMemoHeader."No.");
                                        if VatEntry.FindFirst() then
                                            VatEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        GLEntry.SetRange(GLEntry."Document No.", SalesCrMemoHeader."No.");
                                        if GLEntry.FindFirst() then
                                            GLEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                                        if ResLedgerEntry.FindFirst() then
                                            ResLedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                                        if ItemLedgerEntry.FindFirst() then
                                            ItemLedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        ValueEntry.SetRange(ValueEntry."Document No.", SalesCrMemoHeader."No.");
                                        ValueEntry2.SetRange(ValueEntry2."Document No.", SalesCrMemoHeader."No.");
                                        if ValueEntry2.FindFirst() then
                                            repeat
                                                OK := ValueEntryRelation.Get(ValueEntry2."Entry No.");
                                                if OK then begin
                                                    Clear(Pos);
                                                    Pos := StrPos(ValueEntryRelation."Source RowId", SalesDocumentNo);
                                                    if Pos <> 0 then begin
                                                        ValueEntryRelation."Source RowId" :=
                                                         DelStr(ValueEntryRelation."Source RowId", Pos, StrLen(SalesDocumentNo));

                                                        ValueEntryRelation."Source RowId" :=
                                                         InsStr(ValueEntryRelation."Source RowId", SalesNewDocumentNo, Pos);
                                                        ValueEntryRelation.Modify();
                                                    end;
                                                end;
                                            until ValueEntry2.Next() = 0;
                                        if ValueEntry.FindFirst() then
                                            ValueEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesCrMemoHeader."No.");
                                        if FALedgerEntry.FindFirst() then
                                            FALedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                                        if CustLedgerEntry.FindFirst() then
                                            CustLedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Document No.", SalesCrMemoHeader."No.");
                                        if DetailedCustLedgEntry.FindFirst() then
                                            DetailedCustLedgEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        ItemEntryRelation.SetRange(ItemEntryRelation."Source ID", SalesCrMemoHeader."No.");
                                        if ItemEntryRelation.FindFirst() then
                                            ItemEntryRelation.ModifyAll(ItemEntryRelation."Source ID", SalesNewDocumentNo);
                                        JXVZHistReceiptVoucherLine.SetRange(JXVZHistReceiptVoucherLine.JXVZVoucherNo, SalesCrMemoHeader."No.");
                                        if JXVZHistReceiptVoucherLine.FindFirst() then
                                            repeat
                                                JXVZHistReceiptVoucherLine2.Get(
                                                                          JXVZHistReceiptVoucherLine.JXVZReceiptNo,
                                                                          JXVZHistReceiptVoucherLine.JXVZVoucherNo,
                                                                          JXVZHistReceiptVoucherLine.JXVZEntryNo);
                                                JXVZHistReceiptVoucherLine.Rename(JXVZHistReceiptVoucherLine2.JXVZReceiptNo,
                                                                            SalesNewDocumentNo,
                                                                            JXVZHistReceiptVoucherLine2.JXVZEntryNo);
                                            until JXVZHistReceiptVoucherLine.Next() = 0;


                                        SalesCrMemoHeader.Rename(SalesNewDocumentNo);
                                    end;
                                end;

                                SalesCreditMemoRefresh();


                            end;

                        SalesVoucherType::Remitos:
                            begin
                                //Ext. doc. no
                                if SalesExternalDocumentNo <> SalesNewExternalDocumentNo then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    CustLedgerEntry.Reset();
                                    DetailedCustLedgEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", SalesShipmentHeader."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                                    GLEntry.SetRange(GLEntry."Document No.", SalesShipmentHeader."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                                    CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesShipmentHeader."No.");
                                    if CustLedgerEntry.FindFirst() then
                                        CustLedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesShipmentHeader."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesShipmentHeader."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                                    ValueEntry.SetRange(ValueEntry."Document No.", SalesShipmentHeader."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesShipmentHeader."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);

                                    SalesShipmentHeader."External Document No." := SalesNewExternalDocumentNo;
                                    SalesShipmentHeader.Modify();

                                end;

                                // Posting date
                                if SalesPostingDate <> SalesNewPostingDate then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    CustLedgerEntry.Reset();
                                    DetailedCustLedgEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", SalesShipmentHeader."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    /*////////-----Esta version de Nav no tiene postindate en G/L REGISTER
                                          gglentry.SETRANGE(gglentry."Document No.",SalesShipmentHeader."No.");
                                          IF gglentry.FIND('-') THEN
                                              REPEAT
                                               gGlRegister.RESET;
                                               gGlRegister.SETRANGE(gGlRegister."From Entry No.",
                                                                            gglentry."Entry No.");
                                               IF gGlRegister.FIND('-') THEN
                                                  BEGIN
                                                   gGlRegister."Posting Date":=SalesNewPostingDate;
                                                   gGlRegister.MODIFY
                                                  END;
                                              UNTIL gglentry.NEXT=0;        */
                                    GLEntry.Reset();
                                    GLEntry.SetRange(GLEntry."Document No.", SalesShipmentHeader."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesShipmentHeader."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesShipmentHeader."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    ValueEntry.SetRange(ValueEntry."Document No.", SalesShipmentHeader."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesShipmentHeader."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesShipmentHeader."No.");
                                    if CustLedgerEntry.FindFirst() then
                                        CustLedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Document No.", SalesShipmentHeader."No.");
                                    if DetailedCustLedgEntry.FindFirst() then
                                        DetailedCustLedgEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                                    SalesShipmentHeader."Posting Date" := SalesNewPostingDate;

                                    SalesShipmentHeader.Modify();
                                end;
                                //Doc. date
                                if SalesDocumentDate <> SalesNewDocumentDate then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    CustLedgerEntry.Reset();
                                    DetailedCustLedgEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", SalesShipmentHeader."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    GLEntry.SetRange(GLEntry."Document No.", SalesShipmentHeader."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesShipmentHeader."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesShipmentHeader."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    ValueEntry.SetRange(ValueEntry."Document No.", SalesShipmentHeader."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesShipmentHeader."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesShipmentHeader."No.");
                                    if CustLedgerEntry.FindFirst() then
                                        CustLedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                                    SalesShipmentHeader."Document Date" := SalesNewDocumentDate;

                                    SalesShipmentHeader.Modify();
                                end;

                                /*//-------------Nuevo Tipo fiscal-----------------------
                                IF SalesFiscalType<>SalesNewFiscalType THEN
                                BEGIN
                                SalesShipmentHeader."Tipo Fiscal":=SalesNewFiscalType;
                                SalesShipmentHeader.MODIFY
                                END;*/

                                //Actual doc. no.
                                if SalesDocumentNo <> SalesNewDocumentNo then begin
                                    SalesShipmentHeader2.Reset();
                                    SalesShipmentHeader2.SetRange(SalesShipmentHeader2."No.", SalesNewDocumentNo);
                                    if SalesShipmentHeader2.FindFirst() then
                                        Message(TextJXL00002Lbl, SalesNewExternalDocumentNo)
                                    else begin
                                        lclLineCommentLines.Reset();
                                        lclLineCommentLines1.Reset();
                                        lclPostedApprov.Reset();
                                        lclPostedApprov1.Reset();

                                        VatEntry.Reset();
                                        GLEntry.Reset();
                                        CustLedgerEntry.Reset();
                                        DetailedCustLedgEntry.Reset();
                                        ResLedgerEntry.Reset();
                                        ItemLedgerEntry.Reset();
                                        ValueEntry.Reset();
                                        ValueEntry2.Reset();
                                        FALedgerEntry.Reset();
                                        ItemEntryRelation.Reset();
                                        ValueEntryRelation.Reset();

                                        lclLineCommentLines.SetRange(lclLineCommentLines."No.", SalesDocumentNo);
                                        lclLineCommentLines.SetRange(lclLineCommentLines."Document Type",
                                        lclLineCommentLines."Document Type"::"Posted Return Receipt");
                                        if lclLineCommentLines.FindFirst() then
                                            repeat
                                                lclLineCommentLines1.SetCurrentKey("Document Type", "No.", "Document Line No.", "Line No.");
                                                lclLineCommentLines1.Get(lclLineCommentLines."Document Type",
                                                 lclLineCommentLines."No.", lclLineCommentLines."Document Line No.",
                                                 lclLineCommentLines."Line No.");
                                                lclLineCommentLines1.Rename(lclLineCommentLines."Document Type",
                                                 SalesNewDocumentNo, lclLineCommentLines."Document Line No.",
                                                 lclLineCommentLines."Line No.");
                                            until lclLineCommentLines.Next() = 0;

                                        lclPostedApprov.SetRange(lclPostedApprov."Document No.", SalesDocumentNo);
                                        lclPostedApprov.SetRange(lclPostedApprov."Table ID", 110);
                                        if lclPostedApprov.FindFirst() then
                                            repeat
                                                lclPostedApprov1.SetCurrentKey("Table ID", "Document No.", "Sequence No.");
                                                lclPostedApprov1.SetRange("Table ID", lclPostedApprov."Table ID");
                                                lclPostedApprov1.SetRange("Document No.", lclPostedApprov."Document No.");
                                                lclPostedApprov1.SetRange("Sequence No.", lclPostedApprov."Sequence No.");
                                                if lclPostedApprov1.FindFirst() then begin
                                                    lclPostedApprov1."Document No." := SalesNewDocumentNo;
                                                    lclPostedApprov1.Modify(false);
                                                end;
                                            /*Old Code
                                            lclPostedApprov1.SetCurrentKey("Table ID", "Document No.", "Sequence No.");
                                            lclPostedApprov1.Get(lclPostedApprov."Table ID",
                                             lclPostedApprov."Document No.", lclPostedApprov."Sequence No.");
                                            lclPostedApprov1.Rename(lclPostedApprov."Table ID",
                                             SalesNewDocumentNo, lclPostedApprov."Sequence No.");
                                             */
                                            until lclPostedApprov.Next() = 0;

                                        SalesShipmentLine.Reset();
                                        SalesShipmentLine.SetRange(SalesShipmentLine."Document No.", SalesShipmentHeader."No.");
                                        if SalesShipmentLine.FindFirst() then
                                            repeat
                                                SalesShipmentLine2.SetCurrentKey("Document No.", "Line No.");
                                                SalesShipmentLine2.Get(SalesShipmentLine."Document No.", SalesShipmentLine."Line No.");
                                                SalesShipmentLine2.Rename(SalesNewDocumentNo, SalesShipmentLine."Line No.");
                                            until SalesShipmentLine.Next() = 0;
                                        VatEntry.SetRange(VatEntry."Document No.", SalesShipmentHeader."No.");
                                        if VatEntry.FindFirst() then
                                            VatEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        GLEntry.SetRange(GLEntry."Document No.", SalesShipmentHeader."No.");
                                        if GLEntry.FindFirst() then
                                            GLEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesShipmentHeader."No.");
                                        if ResLedgerEntry.FindFirst() then
                                            ResLedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesShipmentHeader."No.");
                                        if ItemLedgerEntry.FindFirst() then
                                            ItemLedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        ValueEntry.SetRange(ValueEntry."Document No.", SalesShipmentHeader."No.");
                                        ValueEntry2.SetRange(ValueEntry2."Document No.", SalesShipmentHeader."No.");
                                        if ValueEntry2.FindFirst() then
                                            repeat
                                                OK := ValueEntryRelation.Get(ValueEntry2."Entry No.");
                                                if OK then begin
                                                    Clear(Pos);
                                                    Pos := StrPos(ValueEntryRelation."Source RowId", SalesDocumentNo);
                                                    if Pos <> 0 then begin
                                                        ValueEntryRelation."Source RowId" :=
                                                         DelStr(ValueEntryRelation."Source RowId", Pos, StrLen(SalesDocumentNo));

                                                        ValueEntryRelation."Source RowId" :=
                                                         InsStr(ValueEntryRelation."Source RowId", SalesNewDocumentNo, Pos);
                                                        ValueEntryRelation.Modify();
                                                    end;
                                                end;
                                            until ValueEntry2.Next() = 0;
                                        if ValueEntry.FindFirst() then
                                            ValueEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesShipmentHeader."No.");
                                        if FALedgerEntry.FindFirst() then
                                            FALedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesShipmentHeader."No.");
                                        if CustLedgerEntry.FindFirst() then
                                            CustLedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Document No.", SalesShipmentHeader."No.");
                                        if DetailedCustLedgEntry.FindFirst() then
                                            DetailedCustLedgEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                                        ItemEntryRelation.SetRange(ItemEntryRelation."Source ID", SalesShipmentHeader."No.");
                                        if ItemEntryRelation.FindFirst() then
                                            ItemEntryRelation.ModifyAll(ItemEntryRelation."Source ID", SalesNewDocumentNo);
                                        SalesShipmentHeader.Rename(SalesNewDocumentNo);
                                    end;
                                end;

                                SalesReferRefresh();

                            end;
                    end;
                    Message(TextJXL0053Lbl);


                end;
            }

            /****action(ServiceModify)
            {
                Caption = 'Service modify', Comment = 'ESP=Modificar servicio';
                ToolTip = 'Service modify', Comment = 'ESP=Modificar servicio';
                ApplicationArea = All;
                Enabled = ServiceModifyEnable;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    lclPostedApprov: Record "Posted Approval Entry";
                    lclPostedApprov1: Record "Posted Approval Entry";
                    lclLineCommentLines: Record "Service Comment Line";
                    lclLineCommentLines1: Record "Service Comment Line";
                begin
                    //Adaptacion para modulo de servicios
                    case gServVoucherType of
                        gServVoucherType::Facturas:
                            begin
                                //External doc no
                                if gServDocNoExt <> gServNewExtDocNo then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    CustLedgerEntry.Reset();
                                    DetailedCustLedgEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", gServSalesHeader."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("External Document No.", gServNewExtDocNo);
                                    GLEntry.SetRange(GLEntry."Document No.", gServSalesHeader."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("External Document No.", gServNewExtDocNo);
                                    CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", gServSalesHeader."No.");
                                    if CustLedgerEntry.FindFirst() then
                                        CustLedgerEntry.ModifyAll("External Document No.", gServNewExtDocNo);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", gServSalesHeader."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("External Document No.", gServNewExtDocNo);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", gServSalesHeader."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("External Document No.", gServNewExtDocNo);
                                    ValueEntry.SetRange(ValueEntry."Document No.", gServSalesHeader."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("External Document No.", gServNewExtDocNo);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", gServSalesHeader."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("External Document No.", gServNewExtDocNo);

                                    //gServSalesHeader."External Document No.":=gServNewExtDocNo;
                                    gServSalesHeader.Modify();

                                end;

                                // Posting date
                                if gServPostingDate <> gServNewPostingDate then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    CustLedgerEntry.Reset();
                                    DetailedCustLedgEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    gServServiceLedEntry.Reset();
                                    gServServiceLedEntry.SetRange("Document No.", gServSalesHeader."No.");
                                    if gServServiceLedEntry.FindFirst() then
                                        gServServiceLedEntry.ModifyAll("Posting Date", gServNewPostingDate);
                                    VatEntry.SetRange(VatEntry."Document No.", gServSalesHeader."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("Posting Date", gServNewPostingDate);
                                    GLEntry.Reset();
                                    GLEntry.SetRange(GLEntry."Document No.", gServSalesHeader."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("Posting Date", gServNewPostingDate);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", gServSalesHeader."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("Posting Date", gServNewPostingDate);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", gServSalesHeader."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("Posting Date", gServNewPostingDate);
                                    ValueEntry.SetRange(ValueEntry."Document No.", gServSalesHeader."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("Posting Date", gServNewPostingDate);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", gServSalesHeader."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("Posting Date", gServNewPostingDate);
                                    CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", gServSalesHeader."No.");
                                    if CustLedgerEntry.FindFirst() then
                                        CustLedgerEntry.ModifyAll("Posting Date", gServNewPostingDate);
                                    DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Document No.", gServSalesHeader."No.");
                                    if DetailedCustLedgEntry.FindFirst() then
                                        DetailedCustLedgEntry.ModifyAll("Posting Date", gServNewPostingDate);
                                    gServSalesHeader."Posting Date" := gServNewPostingDate;
                                    gServSalesHeader.Modify();
                                end;
                                //Doc date
                                if gServDacDate <> gServNewDocDate then begin
                                    VatEntry.Reset();
                                    GLEntry.Reset();
                                    CustLedgerEntry.Reset();
                                    DetailedCustLedgEntry.Reset();
                                    ResLedgerEntry.Reset();
                                    ItemLedgerEntry.Reset();
                                    ValueEntry.Reset();
                                    FALedgerEntry.Reset();
                                    VatEntry.SetRange(VatEntry."Document No.", gServSalesHeader."No.");
                                    if VatEntry.FindFirst() then
                                        VatEntry.ModifyAll("Document Date", gServNewDocDate);
                                    GLEntry.SetRange(GLEntry."Document No.", gServSalesHeader."No.");
                                    if GLEntry.FindFirst() then
                                        GLEntry.ModifyAll("Document Date", gServNewDocDate);
                                    ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", gServSalesHeader."No.");
                                    if ResLedgerEntry.FindFirst() then
                                        ResLedgerEntry.ModifyAll("Document Date", gServNewDocDate);
                                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", gServSalesHeader."No.");
                                    if ItemLedgerEntry.FindFirst() then
                                        ItemLedgerEntry.ModifyAll("Document Date", gServNewDocDate);
                                    ValueEntry.SetRange(ValueEntry."Document No.", gServSalesHeader."No.");
                                    if ValueEntry.FindFirst() then
                                        ValueEntry.ModifyAll("Document Date", gServNewDocDate);
                                    FALedgerEntry.SetRange(FALedgerEntry."Document No.", gServSalesHeader."No.");
                                    if FALedgerEntry.FindFirst() then
                                        FALedgerEntry.ModifyAll("Document Date", gServNewDocDate);
                                    CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", gServSalesHeader."No.");
                                    if CustLedgerEntry.FindFirst() then
                                        CustLedgerEntry.ModifyAll("Document Date", gServNewDocDate);
                                    gServSalesHeader."Document Date" := gServNewDocDate;

                                    gServSalesHeader.Modify();
                                end;
                                //Fiscal date
                                /*if gServFiscalType <> gServNewFiscalType then begin
                                    gServSalesHeader."Fiscal Type" := gServNewFiscalType;
                                    gServSalesHeader.Modify
                                end;*/
            //Actual doc no
            /****if gServDocNo <> gServNewDocNo then begin
                gServSalesheader2.Reset();
                gServSalesheader2.SetRange(gServSalesheader2."No.", gServNewDocNo);
                if gServSalesheader2.FindFirst() then
                    Message(TextJXL00002Lbl, gServNewExtDocNo)
                else begin
                    lclLineCommentLines.Reset();
                    lclLineCommentLines1.Reset();
                    lclPostedApprov.Reset();
                    lclPostedApprov1.Reset();

                    VatEntry.Reset();
                    GLEntry.Reset();
                    CustLedgerEntry.Reset();
                    DetailedCustLedgEntry.Reset();
                    ResLedgerEntry.Reset();
                    ItemLedgerEntry.Reset();
                    ValueEntry.Reset();
                    ValueEntry2.Reset();
                    FALedgerEntry.Reset();
                    gServPostedReceiptPurchLine.Reset();
                    gServSalesLine.Reset();
                    gServItemEntryRel.Reset();
                    gServValueEntryRel.Reset();
                    gServWarehouseEntry.Reset();

                    gServWarehouseEntry.Reset();
                    gServWarehouseEntry.SetRange("Reference No.", gServSalesHeader."No.");
                    if gServWarehouseEntry.FindFirst() then
                        gServWarehouseEntry.ModifyAll("Reference No.", gServNewDocNo);

                    gServServiceLedEntry.Reset();
                    gServServiceLedEntry.SetRange("Document No.", gServSalesHeader."No.");
                    if gServServiceLedEntry.FindFirst() then
                        gServServiceLedEntry.ModifyAll("Document No.", gServNewDocNo);

                    /*
                      lclLineCommentLines.SETRANGE(lclLineCommentLines."No.",gServDocNo);
                      lclLineCommentLines.SETRANGE(lclLineCommentLines."Document Type",
                      lclLineCommentLines."Document Type"::"Posted Invoice");
                      IF lclLineCommentLines.FINDFIRST THEN
                       REPEAT
                        lclLineCommentLines1.SETCURRENTKEY("Document Type","No.","Document Line No.","Line No.");
                        lclLineCommentLines1.GET(lclLineCommentLines."Document Type",
                         lclLineCommentLines."No.",lclLineCommentLines."Document Line No.",
                         lclLineCommentLines."Line No.");
                        lclLineCommentLines1.RENAME(lclLineCommentLines."Document Type",
                         gServNewDocNo,lclLineCommentLines."Document Line No.",
                         lclLineCommentLines."Line No.");
                       UNTIL lclLineCommentLines.NEXT = 0;
                    */
            /****lclPostedApprov.SetRange(lclPostedApprov."Document No.", gServDocNo);
            lclPostedApprov.SetRange(lclPostedApprov."Table ID", 5992);
            if lclPostedApprov.FindSet() then
                repeat
                    lclPostedApprov1.SetCurrentKey("Table ID", "Document No.", "Sequence No.");
                    lclPostedApprov1.Get(lclPostedApprov."Table ID",
                     lclPostedApprov."Document No.", lclPostedApprov."Sequence No.");
                    lclPostedApprov1.Rename(lclPostedApprov."Table ID",
                     gServNewDocNo, lclPostedApprov."Sequence No.");
                until lclPostedApprov.Next() = 0;

            gServSalesLine.SetRange(gServSalesLine."Document No.", gServSalesHeader."No.");
            if gServSalesLine.FindSet() then
                repeat
                    gServSalesLine2.SetCurrentKey("Document No.", "Line No.");
                    gServSalesLine2.Get(gServSalesLine."Document No.", gServSalesLine."Line No.");
                    gServSalesLine2.Rename(gServNewDocNo, gServSalesLine."Line No.");
                until gServSalesLine.Next() = 0;
            VatEntry.SetRange(VatEntry."Document No.", gServSalesHeader."No.");
            if VatEntry.FindFirst() then
                VatEntry.ModifyAll("Document No.", gServNewDocNo);
            GLEntry.SetRange(GLEntry."Document No.", gServSalesHeader."No.");
            if GLEntry.FindFirst() then
                GLEntry.ModifyAll("Document No.", gServNewDocNo);
            ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", gServSalesHeader."No.");
            if ResLedgerEntry.FindFirst() then
                ResLedgerEntry.ModifyAll("Document No.", gServNewDocNo);
            ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", gServSalesHeader."No.");
            if ItemLedgerEntry.FindFirst() then
                ItemLedgerEntry.ModifyAll("Document No.", gServNewDocNo);
            ValueEntry.SetRange(ValueEntry."Document No.", gServSalesHeader."No.");
            ValueEntry2.SetRange(ValueEntry2."Document No.", gServSalesHeader."No.");
            if ValueEntry2.FindSet() then
                repeat
                    OK := gServValueEntryRel.Get(ValueEntry2."Entry No.");
                    if OK then begin
                        Clear(Pos);
                        Pos := StrPos(gServValueEntryRel."Source RowId", gServDocNo);
                        if Pos <> 0 then begin
                            gServValueEntryRel."Source RowId" :=
                             DelStr(gServValueEntryRel."Source RowId", Pos, StrLen(gServDocNo));

                            gServValueEntryRel."Source RowId" :=
                             InsStr(gServValueEntryRel."Source RowId", gServNewDocNo, Pos);
                            gServValueEntryRel.Modify();
                        end;
                    end;
                until ValueEntry2.Next() = 0;
            if ValueEntry.FindFirst() then
                ValueEntry.ModifyAll("Document No.", gServNewDocNo);
            FALedgerEntry.SetRange(FALedgerEntry."Document No.", gServSalesHeader."No.");
            if FALedgerEntry.FindFirst() then
                FALedgerEntry.ModifyAll("Document No.", gServNewDocNo);
            CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", gServSalesHeader."No.");
            if CustLedgerEntry.FindFirst() then
                CustLedgerEntry.ModifyAll("Document No.", gServNewDocNo);
            DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Document No.", gServSalesHeader."No.");
            if DetailedCustLedgEntry.FindFirst() then
                DetailedCustLedgEntry.ModifyAll("Document No.", gServNewDocNo);
            gServItemEntryRel.SetRange(gServItemEntryRel."Source ID", gServSalesHeader."No.");
            if gServItemEntryRel.FindFirst() then
                gServItemEntryRel.ModifyAll(gServItemEntryRel."Source ID", gServNewDocNo);
            gServPostedReceiptPurchLine.SetRange(gServPostedReceiptPurchLine.JXVZVoucherNo, gServSalesHeader."No.");
            if gServPostedReceiptPurchLine.FindFirst() then
                repeat
                    gServPostedReceiptPurchLine2.Get(
                                              gServPostedReceiptPurchLine.JXVZReceiptNo,
                                              gServPostedReceiptPurchLine.JXVZVoucherNo,
                                              gServPostedReceiptPurchLine.JXVZEntryNo);
                    gServPostedReceiptPurchLine.Rename(gServPostedReceiptPurchLine2.JXVZReceiptNo,
                                                gServNewDocNo,
                                                gServPostedReceiptPurchLine2.JXVZEntryNo);
                until gServPostedReceiptPurchLine.Next() = 0;


            gServSalesHeader.Rename(gServNewDocNo);
        end;
    end;

    ServiceInvoiceRefresh();

end;

gServVoucherType::"Notas Credito":
begin
    //  External doc no
    if gServDocNoExt <> gServNewExtDocNo then begin
        VatEntry.Reset();
        GLEntry.Reset();
        CustLedgerEntry.Reset();
        DetailedCustLedgEntry.Reset();
        ResLedgerEntry.Reset();
        ItemLedgerEntry.Reset();
        ValueEntry.Reset();
        FALedgerEntry.Reset();
        VatEntry.SetRange(VatEntry."Document No.", gServCreditNoteHeader."No.");
        if VatEntry.FindFirst() then
            VatEntry.ModifyAll("External Document No.", gServNewExtDocNo);
        GLEntry.SetRange(GLEntry."Document No.", gServCreditNoteHeader."No.");
        if GLEntry.FindFirst() then
            GLEntry.ModifyAll("External Document No.", gServNewExtDocNo);
        CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", gServCreditNoteHeader."No.");
        if CustLedgerEntry.FindFirst() then
            CustLedgerEntry.ModifyAll("External Document No.", gServNewExtDocNo);
        ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", gServCreditNoteHeader."No.");
        if ResLedgerEntry.FindFirst() then
            ResLedgerEntry.ModifyAll("External Document No.", gServNewExtDocNo);
        ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", gServCreditNoteHeader."No.");
        if ItemLedgerEntry.FindFirst() then
            ItemLedgerEntry.ModifyAll("External Document No.", gServNewExtDocNo);
        ValueEntry.SetRange(ValueEntry."Document No.", gServCreditNoteHeader."No.");
        if ValueEntry.FindFirst() then
            ValueEntry.ModifyAll("External Document No.", gServNewExtDocNo);
        FALedgerEntry.SetRange(FALedgerEntry."Document No.", gServCreditNoteHeader."No.");
        if FALedgerEntry.FindFirst() then
            FALedgerEntry.ModifyAll("External Document No.", gServNewExtDocNo);

        //gServCreditNoteHeader."External Document No.":=gServNewExtDocNo;
        gServCreditNoteHeader.Modify();

    end;

    //Posting date
    if gServPostingDate <> gServNewPostingDate then begin
        VatEntry.Reset();
        GLEntry.Reset();
        CustLedgerEntry.Reset();
        DetailedCustLedgEntry.Reset();
        ResLedgerEntry.Reset();
        ItemLedgerEntry.Reset();
        ValueEntry.Reset();
        FALedgerEntry.Reset();
        gServServiceLedEntry.Reset();
        gServServiceLedEntry.SetRange("Document No.", gServCreditNoteHeader."No.");
        if gServServiceLedEntry.FindFirst() then
            gServServiceLedEntry.ModifyAll("Posting Date", gServNewPostingDate);

        VatEntry.SetRange(VatEntry."Document No.", gServCreditNoteHeader."No.");
        if VatEntry.FindFirst() then
            VatEntry.ModifyAll("Posting Date", gServNewPostingDate);
        /*////////-----Esta version de Nav no tiene postindate en G/L REGISTER
           /****gglentry.SETRANGE(gglentry."Document No.",gServCreditNoteHeader."No.");
           IF gglentry.FINDSET THEN
               REPEAT
                gGlRegister.RESET;
                gGlRegister.SETRANGE(gGlRegister."From Entry No.",
                                             gglentry."Entry No.");
                IF gGlRegister.FINDFIRST THEN
                   BEGIN
                    gGlRegister."Posting Date":=gServNewPostingDate;
                    gGlRegister.MODIFY
                   END;
               UNTIL gglentry.NEXT=0; */
           /****GLEntry.Reset();
           GLEntry.SetRange(GLEntry."Document No.", gServCreditNoteHeader."No.");
           if GLEntry.FindFirst() then
               GLEntry.ModifyAll("Posting Date", gServNewPostingDate);
           ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", gServCreditNoteHeader."No.");
           if ResLedgerEntry.FindFirst() then
               ResLedgerEntry.ModifyAll("Posting Date", gServNewPostingDate);
           ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", gServCreditNoteHeader."No.");
           if ItemLedgerEntry.FindFirst() then
               ItemLedgerEntry.ModifyAll("Posting Date", gServNewPostingDate);
           ValueEntry.SetRange(ValueEntry."Document No.", gServCreditNoteHeader."No.");
           if ValueEntry.FindFirst() then
               ValueEntry.ModifyAll("Posting Date", gServNewPostingDate);
           FALedgerEntry.SetRange(FALedgerEntry."Document No.", gServCreditNoteHeader."No.");
           if FALedgerEntry.FindFirst() then
               FALedgerEntry.ModifyAll("Posting Date", gServNewPostingDate);
           CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", gServCreditNoteHeader."No.");
           if CustLedgerEntry.FindFirst() then
               CustLedgerEntry.ModifyAll("Posting Date", gServNewPostingDate);
           DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Document No.", gServCreditNoteHeader."No.");
           if DetailedCustLedgEntry.FindFirst() then
               DetailedCustLedgEntry.ModifyAll("Posting Date", gServNewPostingDate);
           gServCreditNoteHeader."Posting Date" := gServNewPostingDate;

           gServCreditNoteHeader.Modify();
       end;
       //Doc date
       if gServDacDate <> gServNewDocDate then begin
           VatEntry.Reset();
           GLEntry.Reset();
           CustLedgerEntry.Reset();
           DetailedCustLedgEntry.Reset();
           ResLedgerEntry.Reset();
           ItemLedgerEntry.Reset();
           ValueEntry.Reset();
           FALedgerEntry.Reset();
           VatEntry.SetRange(VatEntry."Document No.", gServCreditNoteHeader."No.");
           if VatEntry.FindFirst() then
               VatEntry.ModifyAll("Document Date", gServNewDocDate);
           GLEntry.SetRange(GLEntry."Document No.", gServCreditNoteHeader."No.");
           if GLEntry.FindFirst() then
               GLEntry.ModifyAll("Document Date", gServNewDocDate);
           ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", gServCreditNoteHeader."No.");
           if ResLedgerEntry.FindFirst() then
               ResLedgerEntry.ModifyAll("Document Date", gServNewDocDate);
           ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", gServCreditNoteHeader."No.");
           if ItemLedgerEntry.FindFirst() then
               ItemLedgerEntry.ModifyAll("Document Date", gServNewDocDate);
           ValueEntry.SetRange(ValueEntry."Document No.", gServCreditNoteHeader."No.");
           if ValueEntry.FindFirst() then
               ValueEntry.ModifyAll("Document Date", gServNewDocDate);
           FALedgerEntry.SetRange(FALedgerEntry."Document No.", gServCreditNoteHeader."No.");
           if FALedgerEntry.FindFirst() then
               FALedgerEntry.ModifyAll("Document Date", gServNewDocDate);
           CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", gServCreditNoteHeader."No.");
           if CustLedgerEntry.FindFirst() then
               CustLedgerEntry.ModifyAll("Document Date", gServNewDocDate);
           gServCreditNoteHeader."Document Date" := gServNewDocDate;

           gServCreditNoteHeader.Modify();
       end;
       /*Fiscal type
       if gServFiscalType <> gServNewFiscalType then begin
           gServCreditNoteHeader."Fiscal Type" := gServNewFiscalType;
           gServCreditNoteHeader.Modify
       end;*/

            //Actual doc no
            /****if gServDocNo <> gServNewDocNo then begin
                gServCreditNoteHeader2.Reset();
                gServCreditNoteHeader2.SetRange(gServCreditNoteHeader2."No.", gServNewDocNo);
                if gServCreditNoteHeader2.FindFirst() then
                    Message(TextJXL00002Lbl, gServNewExtDocNo)
                else begin
                    lclLineCommentLines.Reset();
                    lclLineCommentLines1.Reset();
                    lclPostedApprov.Reset();
                    lclPostedApprov1.Reset();

                    VatEntry.Reset();
                    GLEntry.Reset();
                    CustLedgerEntry.Reset();
                    DetailedCustLedgEntry.Reset();
                    ResLedgerEntry.Reset();
                    ItemLedgerEntry.Reset();
                    ValueEntry.Reset();
                    ValueEntry2.Reset();
                    FALedgerEntry.Reset();
                    gServItemEntryRel.Reset();
                    gServValueEntryRel.Reset();
                    gServPostedReceiptPurchLine.Reset();
                    gServServiceLedEntry.Reset();
                    gServWarehouseEntry.Reset();

                    gServWarehouseEntry.Reset();
                    gServWarehouseEntry.SetRange("Reference No.", gServCreditNoteHeader."No.");
                    if gServWarehouseEntry.FindFirst() then
                        gServWarehouseEntry.ModifyAll("Reference No.", gServNewDocNo);

                    gServServiceLedEntry.SetRange("Document No.", gServCreditNoteHeader."No.");
                    if gServServiceLedEntry.FindFirst() then
                        gServServiceLedEntry.ModifyAll("Document No.", gServNewDocNo);
                    /*
                                                        lclLineCommentLines.SETRANGE(lclLineCommentLines."No.",gServDocNo);
                                                        lclLineCommentLines.SETRANGE(lclLineCommentLines."Document Type",
                                                        lclLineCommentLines."Document Type"::"Posted Credit Memo");
                                                        IF lclLineCommentLines.FINDFIRST THEN
                                                         REPEAT
                                                          lclLineCommentLines1.SETCURRENTKEY("Document Type","No.","Document Line No.","Line No.");
                                                          lclLineCommentLines1.GET(lclLineCommentLines."Document Type",
                                                           lclLineCommentLines."No.",lclLineCommentLines."Document Line No.",
                                                           lclLineCommentLines."Line No.");
                                                          lclLineCommentLines1.RENAME(lclLineCommentLines."Document Type",
                                                           gServNewDocNo,lclLineCommentLines."Document Line No.",
                                                           lclLineCommentLines."Line No.");
                                                         UNTIL lclLineCommentLines.NEXT = 0;
                     */
            /****       lclPostedApprov.SetRange(lclPostedApprov."Document No.", gServDocNo);
                   lclPostedApprov.SetRange(lclPostedApprov."Table ID", 5994);
                   if lclPostedApprov.FindFirst() then
                       repeat
                           lclPostedApprov1.SetCurrentKey("Table ID", "Document No.", "Sequence No.");
                           lclPostedApprov1.Get(lclPostedApprov."Table ID",
                            lclPostedApprov."Document No.", lclPostedApprov."Sequence No.");
                           lclPostedApprov1.Rename(lclPostedApprov."Table ID",
                            gServNewDocNo, lclPostedApprov."Sequence No.");
                       until lclPostedApprov.Next() = 0;

                   gServCreditNoteLine.Reset();
                   gServCreditNoteLine.SetRange(gServCreditNoteLine."Document No.", gServCreditNoteHeader."No.");
                   if gServCreditNoteLine.FindFirst() then
                       repeat
                           gServCreditNoteLine2.SetCurrentKey("Document No.", "Line No.");
                           gServCreditNoteLine2.Get(gServCreditNoteLine."Document No.", gServCreditNoteLine."Line No.");
                           gServCreditNoteLine2.Rename(gServNewDocNo, gServCreditNoteLine."Line No.");
                       until gServCreditNoteLine.Next() = 0;
                   VatEntry.SetRange(VatEntry."Document No.", gServCreditNoteHeader."No.");
                   if VatEntry.FindFirst() then
                       VatEntry.ModifyAll("Document No.", gServNewDocNo);
                   GLEntry.SetRange(GLEntry."Document No.", gServCreditNoteHeader."No.");
                   if GLEntry.FindFirst() then
                       GLEntry.ModifyAll("Document No.", gServNewDocNo);
                   ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", gServCreditNoteHeader."No.");
                   if ResLedgerEntry.FindFirst() then
                       ResLedgerEntry.ModifyAll("Document No.", gServNewDocNo);
                   ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", gServCreditNoteHeader."No.");
                   if ItemLedgerEntry.FindFirst() then
                       ItemLedgerEntry.ModifyAll("Document No.", gServNewDocNo);
                   ValueEntry.SetRange(ValueEntry."Document No.", gServCreditNoteHeader."No.");
                   ValueEntry2.SetRange(ValueEntry2."Document No.", gServCreditNoteHeader."No.");
                   if ValueEntry2.FindSet() then
                       repeat
                           OK := gServValueEntryRel.Get(ValueEntry2."Entry No.");
                           if OK then begin
                               Clear(Pos);
                               Pos := StrPos(gServValueEntryRel."Source RowId", gServDocNo);
                               if Pos <> 0 then begin
                                   gServValueEntryRel."Source RowId" :=
                                    DelStr(gServValueEntryRel."Source RowId", Pos, StrLen(gServDocNo));

                                   gServValueEntryRel."Source RowId" :=
                                    InsStr(gServValueEntryRel."Source RowId", gServNewDocNo, Pos);
                                   gServValueEntryRel.Modify();
                               end;
                           end;
                       until ValueEntry2.Next() = 0;
                   if ValueEntry.FindFirst() then
                       ValueEntry.ModifyAll("Document No.", gServNewDocNo);
                   FALedgerEntry.SetRange(FALedgerEntry."Document No.", gServCreditNoteHeader."No.");
                   if FALedgerEntry.FindFirst() then
                       FALedgerEntry.ModifyAll("Document No.", gServNewDocNo);
                   CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", gServCreditNoteHeader."No.");
                   if CustLedgerEntry.FindFirst() then
                       CustLedgerEntry.ModifyAll("Document No.", gServNewDocNo);
                   DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Document No.", gServCreditNoteHeader."No.");
                   if DetailedCustLedgEntry.FindFirst() then
                       DetailedCustLedgEntry.ModifyAll("Document No.", gServNewDocNo);
                   gServItemEntryRel.SetRange(gServItemEntryRel."Source ID", gServCreditNoteHeader."No.");
                   if gServItemEntryRel.FindFirst() then
                       gServItemEntryRel.ModifyAll(gServItemEntryRel."Source ID", gServNewDocNo);
                   gServPostedReceiptPurchLine.SetRange(gServPostedReceiptPurchLine.JXVZVoucherNo, gServCreditNoteHeader."No.");
                   if gServPostedReceiptPurchLine.FindFirst() then
                       repeat
                           gServPostedReceiptPurchLine2.Get(
                                                     gServPostedReceiptPurchLine.JXVZReceiptNo,
                                                     gServPostedReceiptPurchLine.JXVZVoucherNo,
                                                     gServPostedReceiptPurchLine.JXVZEntryNo);
                           gServPostedReceiptPurchLine.Rename(gServPostedReceiptPurchLine2.JXVZReceiptNo,
                                                       gServNewDocNo,
                                                       gServPostedReceiptPurchLine2.JXVZEntryNo);
                       until gServPostedReceiptPurchLine.Next() = 0;


                   gServCreditNoteHeader.Rename(gServNewDocNo);
               end;
           end;

           ServiceCreditMemoRefresh();


       end;
end;
Message(TextJXL0053Lbl);

end;
}*/
        }
    }

    trigger OnInit()
    begin
        PurchNoEnable := true;
        PurchTypeEnable := true;
        SalesTypeEnable := true;
        SalesModifyEnable := true;
        //ServiceModifyEnable := true;
        SalesNavigateEnable := true;
    end;

    trigger OnOpenPage()
    begin
        //Purchase tables
        PurchInvHeader.Reset();
        PurchRcptHeader.Reset();
        PurchCrMemoHdr.Reset();

        if SalesDocumentNo = '' then begin
            SalesNavigateEnable := false;
            SalesModifyEnable := false;
            //ServiceModifyEnable := false;
        end;
    end;

    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceHeader2: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesInvoiceLine2: Record "Sales Invoice Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentHeader2: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesShipmentLine2: Record "Sales Shipment Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoHeader2: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesCrMemoLine2: Record "Sales Cr.Memo Line";
        ItemEntryRelation: Record "Item Entry Relation";
        ValueEntryRelation: Record "Value Entry Relation";
        JXVZHistReceiptVoucherLine: Record JXVZHistReceiptVoucherLine;
        JXVZHistReceiptVoucherLine2: Record JXVZHistReceiptVoucherLine;
        VatEntry: Record "VAT Entry";
        GLEntry: Record "G/L Entry";
        //gGlRegister: Record "G/L Register";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        ResLedgerEntry: Record "Res. Ledger Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        FALedgerEntry: Record "FA Ledger Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        ValueEntry2: Record "Value Entry";
        //gFiscalType: Record "Fiscal Type";
        gNavigate: Page Navigate;
        PurchDocumentNo: Code[20];
        PurchExternalDocumentNo: Code[35];
        PurchPostingDate: Date;
        PurchDocumentDate: Date;
        PurchFiscalType: Code[20];
        PurchVoucherType: Option Facturas,"Notas Credito",Remitos;
        PurchNewExternalDocumentNo: Code[35];
        PurchNewPostingDate: Date;
        PurchNewDocumentDate: Date;
        PurchNewFiscalType: Code[20];
        PurchNotShowInBook: Boolean;
        PurchNewNotShowInBook: Boolean;
        SalesDocumentNo: Code[20];
        SalesExternalDocumentNo: Code[30];
        SalesPostingDate: Date;
        SalesDocumentDate: Date;
        SalesFiscalType: Code[20];
        SalesVoucherType: Option Facturas,"Notas Credito",Remitos;
        SalesNewExternalDocumentNo: Code[30];
        SalesNewPostingDate: Date;
        SalesNewDocumentDate: Date;
        SalesNewFiscalType: Code[20];
        SalesNewDocumentNo: Code[20];
        SalesNotShowInBook: Boolean;
        SalesNewNotShowInBook: Boolean;
        OK: Boolean;
        Pos: Integer;
        [InDataSet]
        SalesNavigateEnable: Boolean;
        [InDataSet]
        SalesModifyEnable: Boolean;
        [InDataSet]
        PurchExtDocNoEnable: Boolean;
        [InDataSet]
        PurchPostingDateEnable: Boolean;
        [InDataSet]
        PurchDocumentDateEnable: Boolean;
        [InDataSet]
        PurchFiscalTypeEnable: Boolean;
        [InDataSet]
        PurchNewExtDocNoEnable: Boolean;
        [InDataSet]
        PurchNewPostingDateEnable: Boolean;
        [InDataSet]
        PurchNewDocumentDateEnable: Boolean;
        [InDataSet]
        PurchNewFiscalTypeEnable: Boolean;
        [InDataSet]
        NavigateEnable: Boolean;
        [InDataSet]
        PurchModifyEnable: Boolean;
        [InDataSet]
        SalesExtDocNoEnable: Boolean;
        [InDataSet]
        SalesPostingDateEnable: Boolean;
        [InDataSet]
        SalesDocumentDateEnable: Boolean;
        [InDataSet]
        SalesFiscalTypeEnable: Boolean;
        [InDataSet]
        SalesNewDocNoEnable: Boolean;
        [InDataSet]
        SalesNewExtDocNoEnable: Boolean;
        [InDataSet]
        SalesNewPostingDateEnable: Boolean;
        [InDataSet]
        SalesNewDocumentDateEnable: Boolean;
        [InDataSet]
        SalesNewFiscalTypeEnable: Boolean;
        [InDataSet]
        SalesTypeEnable: Boolean;
        [InDataSet]
        PurchTypeEnable: Boolean;
        [InDataSet]
        PurchNoEnable: Boolean;
        PurchDespachoNew: Text[30];
        TextJXL0024Lbl: Label 'Posting date', Comment = 'ESP=Fecha de registro';
        TextJXL0025Lbl: Label 'Document date', Comment = 'ESP=Fecha documento';
        TextJXL00002Lbl: Label 'The document number %1 already exists. The change does not take place', Comment = 'ESP=El numero de documento %1 ya existe. El cambio no se realizará';
        TextJXL0052Lbl: Label 'The field  %1 value can not be empty', Comment = 'ESP=El campo %1 no puede ser vacio';
        TextJXL0053Lbl: Label 'End process', Comment = 'ESP=Proceso finalizado';
        PurchWithholdingCodeNew: code[20];
        PurchWithholdingCodeActual: Code[20];
        PurchWithholdingCodeNewEnabled: Boolean;
    /*TextJXL0054Lbl: Label 'Current', Comment = 'ESP=Actual';
    TextTextJXL0056Lbl: Label 'Current', Comment = 'ESP=Actual';
    TextTextJXL0055Lbl: Label 'New', Comment = 'ESP=Nuevo';
    TextTextJXL0057Lbl: Label 'New', Comment = 'ESP=Nuevo';*/
    //----------------Service-----------------------
    /*gServDocNo: Code[20];
    gServDocNoExt: Code[20];
    gServPostingDate: Date;
    gServDacDate: Date;
    gServFiscalType: Code[20];
    gServVoucherType: Option Facturas,"Notas Credito";
    gServNewExtDocNo: Code[20];
    gServNewPostingDate: Date;
    gServNewDocDate: Date;
    gServNewFiscalType: Code[20];
    gServNewDocNo: Code[20];
    gServSalesHeader: Record "Service Invoice Header";
    gServSalesheader2: Record "Service Invoice Header";
    gServSalesLine: Record "Service Invoice Line";
    gServSalesLine2: Record "Service Invoice Line";*/
    /*gServRecepHeader: Record "Service Shipment Header";
    gServRecepHeader2: Record "Service Shipment Header";
    gServRecepLine: Record "Service Shipment Line";
    gServRecepLine2: Record "Service Shipment Line";*/
    /*gServCreditNoteHeader: Record "Service Cr.Memo Header";
    gServCreditNoteHeader2: Record "Service Cr.Memo Header";
    gServCreditNoteLine: Record "Service Cr.Memo Line";
    gServCreditNoteLine2: Record "Service Cr.Memo Line";
    gServItemEntryRel: Record "Item Entry Relation";
    gServValueEntryRel: Record "Value Entry Relation";
    gServPostedReceiptPurchLine: Record JXVZHistReceiptVoucherLine;
    gServWarehouseEntry: Record "Warehouse Entry";
    gServServiceLedEntry: Record "Service Ledger Entry";
    gServPostedReceiptPurchLine2: Record JXVZHistReceiptVoucherLine;
    [InDataSet]
    gServExtDocNoEnable: Boolean;
    [InDataSet]
    gServPostingDateEnable: Boolean;
    [InDataSet]
    gServDocDateEnable: Boolean;
    [InDataSet]
    gServFiscalTypeEnable: Boolean;
    [InDataSet]
    gServNewDocNoEnable: Boolean;
    [InDataSet]
    gServNewExtDocNoEnable: Boolean;
    [InDataSet]
    gServNewPostingDateEnable: Boolean;
    [InDataSet]
    gServNewDocDateEnable: Boolean;
    [InDataSet]
    gServNewFiscalTypeEnable: Boolean;
    [InDataSet]
    gServTypeEnable: Boolean;
    [InDataSet]
    gServNavigateEnable: Boolean;
    [InDataSet]
    ServiceModifyEnable: Boolean;*/

    procedure PurchInvoiceRefresh()
    begin
        if PurchInvHeader."No." <> '' then begin
            PurchDocumentNo := PurchInvHeader."No.";
            PurchExternalDocumentNo := PurchInvHeader."Vendor Invoice No.";
            PurchPostingDate := PurchInvHeader."Posting Date";
            PurchDocumentDate := PurchInvHeader."Document Date";

            PurchWithholdingCodeActual := PurchInvHeader.JXVZWithholdingCode;
            //PurchFiscalType := PurchInvHeader."Fiscal Type";            

            PurchNewExternalDocumentNo := PurchInvHeader."Vendor Invoice No.";
            PurchNewPostingDate := PurchInvHeader."Posting Date";
            PurchNewDocumentDate := PurchInvHeader."Document Date";
            PurchWithholdingCodeNew := PurchInvHeader.JXVZWithholdingCode;
            //PurchNewFiscalType := PurchInvHeader."Fiscal Type";

            PurchExtDocNoEnable := true;
            PurchPostingDateEnable := true;
            PurchDocumentDateEnable := true;
            PurchFiscalTypeEnable := true;


            PurchNewExtDocNoEnable := true;
            PurchNewPostingDateEnable := true;
            PurchNewDocumentDateEnable := true;
            PurchNewFiscalTypeEnable := true;

            NavigateEnable := true;
            PurchModifyEnable := true;
            PurchWithholdingCodeNewEnabled := true;
        end
        else begin
            PurchDocumentNo := '';
            PurchExternalDocumentNo := '';
            PurchPostingDate := 0D;
            PurchDocumentDate := 0D;
            PurchFiscalType := '';
            PurchNewFiscalType := '';
            PurchNewExternalDocumentNo := '';
            PurchNewPostingDate := 0D;
            PurchNewDocumentDate := 0D;
            PurchNewFiscalType := '';
            PurchWithholdingCodeNew := '';
            PurchWithholdingCodeActual := '';

            PurchExtDocNoEnable := false;
            PurchPostingDateEnable := false;
            PurchDocumentDateEnable := false;
            PurchFiscalTypeEnable := false;

            PurchNewExtDocNoEnable := false;
            PurchNewPostingDateEnable := false;
            PurchNewDocumentDateEnable := false;
            PurchNewFiscalTypeEnable := false;

            NavigateEnable := false;
            PurchModifyEnable := false;
            PurchWithholdingCodeNewEnabled := false;
        end;
    end;

    procedure PurchCreditMemoRefresh()
    begin
        if PurchCrMemoHdr."No." <> '' then begin
            PurchDocumentNo := PurchCrMemoHdr."No.";
            PurchExternalDocumentNo := PurchCrMemoHdr."Vendor Cr. Memo No.";
            PurchPostingDate := PurchCrMemoHdr."Posting Date";
            PurchDocumentDate := PurchCrMemoHdr."Document Date";

            PurchWithholdingCodeActual := PurchCrMemoHdr.JXVZWithholdingCode;
            //PurchFiscalType := PurchCrMemoHdr."Behaviour Code";

            PurchNewExternalDocumentNo := PurchCrMemoHdr."Vendor Cr. Memo No.";
            PurchNewPostingDate := PurchCrMemoHdr."Posting Date";
            PurchNewDocumentDate := PurchCrMemoHdr."Document Date";

            PurchWithholdingCodeNew := PurchCrMemoHdr.JXVZWithholdingCode;
            //PurchNewFiscalType := PurchCrMemoHdr."Behaviour Code";

            PurchExtDocNoEnable := true;
            PurchPostingDateEnable := true;
            PurchDocumentDateEnable := true;
            PurchFiscalTypeEnable := true;


            PurchNewExtDocNoEnable := true;
            PurchNewPostingDateEnable := true;
            PurchNewDocumentDateEnable := true;
            PurchNewFiscalTypeEnable := true;

            NavigateEnable := true;
            PurchModifyEnable := true;
            PurchWithholdingCodeNewEnabled := true;
        end
        else begin
            PurchDocumentNo := '';
            PurchExternalDocumentNo := '';
            PurchPostingDate := 0D;
            PurchDocumentDate := 0D;
            PurchFiscalType := '';
            PurchNewFiscalType := '';
            PurchNewExternalDocumentNo := '';
            PurchNewPostingDate := 0D;
            PurchNewDocumentDate := 0D;
            PurchNewFiscalType := '';
            PurchWithholdingCodeNew := '';
            PurchWithholdingCodeActual := '';

            PurchExtDocNoEnable := false;
            PurchPostingDateEnable := false;
            PurchDocumentDateEnable := false;
            PurchFiscalTypeEnable := false;

            PurchNewExtDocNoEnable := false;
            PurchNewPostingDateEnable := false;
            PurchNewDocumentDateEnable := false;
            PurchNewFiscalTypeEnable := false;

            NavigateEnable := false;
            PurchModifyEnable := false;
            PurchWithholdingCodeNewEnabled := false;
        end;
    end;

    procedure PurchReferRefresh()
    begin

        if PurchRcptHeader."No." <> '' then begin
            PurchDocumentNo := PurchRcptHeader."No.";
            PurchExternalDocumentNo := PurchRcptHeader."Order No.";
            PurchPostingDate := PurchRcptHeader."Posting Date";
            PurchDocumentDate := PurchRcptHeader."Document Date";
            //PurchNewFiscalType:=PurchRcptHeader."Tipo Fiscal";

            PurchExternalDocumentNo := PurchRcptHeader."Order No.";
            PurchNewPostingDate := PurchRcptHeader."Posting Date";
            PurchNewDocumentDate := PurchRcptHeader."Document Date";
            //PurchNewFiscalType:=PurchRcptHeader."Tipo Fiscal";

            PurchExtDocNoEnable := true;
            PurchPostingDateEnable := true;
            PurchDocumentDateEnable := true;
            //CurrForm.PurchFiscalType.ENABLED:=TRUE;


            //CurrForm.PurchNewExternalDocumentNo.ENABLED:=TRUE;
            PurchNewPostingDateEnable := true;
            PurchNewDocumentDateEnable := true;
            //CurrForm.PurchNewFiscalType.ENABLED:=TRUE;

            NavigateEnable := true;
            PurchModifyEnable := true;
        end
        else begin
            PurchDocumentNo := '';
            PurchExternalDocumentNo := '';
            PurchPostingDate := 0D;
            PurchDocumentDate := 0D;
            PurchNewFiscalType := '';
            PurchNewExternalDocumentNo := '';
            PurchNewPostingDate := 0D;
            PurchNewDocumentDate := 0D;
            PurchNewFiscalType := '';

            PurchExtDocNoEnable := false;
            PurchPostingDateEnable := false;
            PurchDocumentDateEnable := false;
            PurchFiscalTypeEnable := false;

            PurchNewExtDocNoEnable := false;
            PurchNewPostingDateEnable := false;
            PurchNewDocumentDateEnable := false;
            PurchNewFiscalTypeEnable := false;

            NavigateEnable := false;
            PurchModifyEnable := false;
        end;
    end;

    procedure SalesInvoiceRefresh()
    begin
        if SalesInvoiceHeader."No." <> '' then begin
            SalesDocumentNo := SalesInvoiceHeader."No.";
            SalesExternalDocumentNo := SalesInvoiceHeader."External Document No.";
            SalesPostingDate := SalesInvoiceHeader."Posting Date";
            SalesDocumentDate := SalesInvoiceHeader."Document Date";

            //SalesFiscalType := SalesInvoiceHeader."Fiscal Type";

            SalesNewDocumentNo := SalesInvoiceHeader."No.";
            SalesNewExternalDocumentNo := SalesInvoiceHeader."External Document No.";
            SalesNewPostingDate := SalesInvoiceHeader."Posting Date";
            SalesNewDocumentDate := SalesInvoiceHeader."Document Date";

            //SalesNewFiscalType := SalesInvoiceHeader."Fiscal Type";


            SalesExtDocNoEnable := true;
            SalesPostingDateEnable := true;
            SalesDocumentDateEnable := true;
            SalesFiscalTypeEnable := true;

            SalesNewDocNoEnable := true;
            SalesNewExtDocNoEnable := true;
            SalesNewPostingDateEnable := true;
            SalesNewDocumentDateEnable := true;
            SalesNewFiscalTypeEnable := true;

            SalesNavigateEnable := true;
            SalesModifyEnable := true;
        end
        else begin
            SalesDocumentNo := '';
            SalesExternalDocumentNo := '';
            SalesPostingDate := 0D;
            SalesDocumentDate := 0D;
            SalesFiscalType := '';
            SalesNewFiscalType := '';
            SalesNewDocumentNo := '';
            SalesNewExternalDocumentNo := '';
            SalesNewPostingDate := 0D;
            SalesNewDocumentDate := 0D;
            SalesNewFiscalType := '';

            SalesExtDocNoEnable := false;
            SalesPostingDateEnable := false;
            SalesDocumentDateEnable := false;
            SalesFiscalTypeEnable := false;

            SalesNewExtDocNoEnable := false;
            SalesNewPostingDateEnable := false;
            SalesNewDocumentDateEnable := false;
            SalesNewFiscalTypeEnable := false;

            SalesNavigateEnable := false;
            SalesModifyEnable := false;
        end;

    end;

    procedure SalesCreditMemoRefresh()
    begin
        if SalesCrMemoHeader."No." <> '' then begin
            SalesDocumentNo := SalesCrMemoHeader."No.";
            SalesExternalDocumentNo := SalesCrMemoHeader."External Document No.";
            SalesPostingDate := SalesCrMemoHeader."Posting Date";
            SalesDocumentDate := SalesCrMemoHeader."Document Date";

            //SalesFiscalType := SalesCrMemoHeader."Fiscal Type";

            SalesNewDocumentNo := SalesCrMemoHeader."No.";
            SalesNewExternalDocumentNo := SalesCrMemoHeader."External Document No.";
            SalesNewPostingDate := SalesCrMemoHeader."Posting Date";
            SalesNewDocumentDate := SalesCrMemoHeader."Document Date";

            //SalesNewFiscalType := SalesCrMemoHeader."Fiscal Type";

            SalesExtDocNoEnable := true;
            SalesPostingDateEnable := true;
            SalesDocumentDateEnable := true;
            SalesFiscalTypeEnable := true;

            SalesNewDocNoEnable := true;
            SalesNewExtDocNoEnable := true;
            SalesNewPostingDateEnable := true;
            SalesNewDocumentDateEnable := true;
            SalesNewFiscalTypeEnable := true;

            SalesNavigateEnable := true;
            SalesModifyEnable := true;
        end
        else begin
            SalesDocumentNo := '';
            SalesExternalDocumentNo := '';
            SalesPostingDate := 0D;
            SalesDocumentDate := 0D;
            SalesFiscalType := '';
            SalesNewFiscalType := '';
            SalesNewDocumentNo := '';
            SalesNewExternalDocumentNo := '';
            SalesNewPostingDate := 0D;
            SalesNewDocumentDate := 0D;
            SalesNewFiscalType := '';

            SalesExtDocNoEnable := false;
            SalesPostingDateEnable := false;
            SalesDocumentDateEnable := false;
            SalesFiscalTypeEnable := false;

            SalesNewDocNoEnable := false;
            SalesNewExtDocNoEnable := false;
            SalesNewPostingDateEnable := false;
            SalesNewDocumentDateEnable := false;
            SalesNewFiscalTypeEnable := false;

            SalesNavigateEnable := false;
            SalesModifyEnable := false;
        end;

    end;

    procedure SalesReferRefresh()
    begin

        if SalesShipmentHeader."No." <> '' then begin
            SalesDocumentNo := SalesShipmentHeader."No.";
            SalesExternalDocumentNo := SalesShipmentHeader."External Document No.";
            SalesPostingDate := SalesShipmentHeader."Posting Date";
            SalesDocumentDate := SalesShipmentHeader."Document Date";
            //SalesFiscalType:=SalesShipmentHeader."Tipo Fiscal";            

            SalesNewDocumentNo := SalesShipmentHeader."No.";
            SalesNewExternalDocumentNo := SalesShipmentHeader."External Document No.";
            SalesNewPostingDate := SalesShipmentHeader."Posting Date";
            SalesNewDocumentDate := SalesShipmentHeader."Document Date";
            //SalesNewFiscalType:=SalesShipmentHeader."Tipo Fiscal";

            SalesExtDocNoEnable := true;
            SalesPostingDateEnable := true;
            SalesDocumentDateEnable := true;
            //CurrForm.SalesFiscalType.ENABLED:=TRUE;

            SalesNewDocNoEnable := true;
            SalesNewExtDocNoEnable := true;
            SalesNewPostingDateEnable := true;
            SalesNewDocumentDateEnable := true;
            //CurrForm.SalesNewFiscalType.ENABLED:=TRUE;

            SalesNavigateEnable := true;
            SalesModifyEnable := true;
        end
        else begin
            SalesDocumentNo := '';
            SalesExternalDocumentNo := '';
            SalesPostingDate := 0D;
            SalesDocumentDate := 0D;
            SalesNewFiscalType := '';
            SalesNewDocumentNo := '';
            SalesNewExternalDocumentNo := '';
            SalesNewPostingDate := 0D;
            SalesNewDocumentDate := 0D;
            SalesNewFiscalType := '';

            SalesExtDocNoEnable := false;
            SalesPostingDateEnable := false;
            SalesDocumentDateEnable := false;
            SalesFiscalTypeEnable := false;

            SalesNewDocNoEnable := false;
            SalesNewExtDocNoEnable := false;
            SalesNewPostingDateEnable := false;
            SalesNewDocumentDateEnable := false;
            SalesNewFiscalTypeEnable := false;

            SalesNavigateEnable := false;
            SalesModifyEnable := false;
        end;

    end;

    procedure DocumentNoValidate(Original: Code[35]; Nuevo: Code[35])
    var
        i: Integer;
        Char1: Char;
        Char2: Char;
        Text50000Lbl: Label 'The new Document No. must maintain the same structure as the original', Comment = 'ESP=El nuevo Nro. del Documento debe mantener la misma estructura que el original.';
        Text50001Lbl: Label 'It is only allowed to change Numbers for other Numbers', Comment = 'ESP=Solo se permiten cambiar Números por otros Números';
        Text50002Lbl: Label 'The document identified already exists as: %1', Comment = 'ESP=Ya existe un documento identificado como: %1';
        Text50003Lbl: Label 'This field does not allow empty value.', Comment = 'ESP=Este campo no permite valor vacio.';
    begin

        if Nuevo = '' then Error(Text50003Lbl);

        SalesInvoiceHeader2.Reset();
        SalesInvoiceHeader2.SetRange(SalesInvoiceHeader2."No.", Nuevo);
        if SalesInvoiceHeader2.FindFirst() then
            Error(Text50002Lbl, Nuevo);

        if StrLen(Original) = StrLen(Nuevo) then
            for i := 1 to StrLen(Original) do begin
                Evaluate(Char2, CopyStr(Nuevo, i, 1));
                Evaluate(Char1, CopyStr(Original, i, 1));
                if Char1 <> Char2 then
                    if (Char1 > 47) and (Char1 < 58) then
                        if not ((Char2 > 47) and (Char2 < 58)) then begin
                            Nuevo := Original;
                            Error(Text50001Lbl);
                        end
                        else begin
                            Nuevo := Original;
                            Error(Text50001Lbl);
                        end

            end
        else begin
            Nuevo := Original;
            Error(Text50000Lbl);
        end;

    end;

    procedure SalesSalmsonRefresh(CodSerie: Code[20])
    var
        NumSerieLine: Record "No. Series Line";
    begin

        NumSerieLine.SetRange(NumSerieLine."Series Code", CodSerie);
        if NumSerieLine.FindFirst() then begin
            SalesInvoiceHeader.SetRange(SalesInvoiceHeader."No.", NumSerieLine."Last No. Used");
            if SalesInvoiceHeader.FindFirst() then begin
                SalesInvoiceRefresh();
                SalesVoucherType := SalesVoucherType::Facturas;
            end;
            SalesShipmentHeader.SetRange(SalesShipmentHeader."No.", NumSerieLine."Last No. Used");
            if SalesShipmentHeader.FindFirst() then begin
                SalesReferRefresh();
                SalesVoucherType := SalesVoucherType::Remitos;
            end;
            SalesCrMemoHeader.SetRange(SalesCrMemoHeader."No.", NumSerieLine."Last No. Used");
            if SalesCrMemoHeader.FindFirst() then begin
                SalesCreditMemoRefresh();
                SalesVoucherType := SalesVoucherType::"Notas Credito";
            end;
            // CurrForm.SalesNavigate.ENABLED:=TRUE;
            // CurrForm.SalesModify.ENABLED:=TRUE;
            SalesTypeEnable := false;
            PurchTypeEnable := false;
            PurchNoEnable := false;
            //SalesVoucherType:=SalesVoucherType::Facturas;
        end;

    end;

    /*    procedure ServiceInvoiceRefresh()
        begin        
            if gServSalesHeader."No." <> '' then begin
                gServDocNo := gServSalesHeader."No.";
                //gServDocNoExt:=gServSalesHeader."External Document No.";
                gServPostingDate := gServSalesHeader."Posting Date";
                gServDacDate := gServSalesHeader."Document Date";
                //gServFiscalType := gServSalesHeader."Fiscal Type";

                gServNewDocNo := gServSalesHeader."No.";
                //gServNewExtDocNo:=gServSalesHeader."External Document No.";
                gServNewPostingDate := gServSalesHeader."Posting Date";
                gServNewDocDate := gServSalesHeader."Document Date";
                //gServNewFiscalType := gServSalesHeader."Fiscal Type";


                gServExtDocNoEnable := true;
                gServPostingDateEnable := true;
                gServDocDateEnable := true;
                gServFiscalTypeEnable := true;

                gServNewDocNoEnable := true;
                gServNewExtDocNoEnable := true;
                gServNewPostingDateEnable := true;
                gServNewDocDateEnable := true;
                gServNewFiscalTypeEnable := true;

                gServNavigateEnable := true;
                ServiceModifyEnable := true;
            end
            else begin
                gServDocNo := '';
                gServDocNoExt := '';
                gServPostingDate := 0D;
                gServDacDate := 0D;
                gServFiscalType := '';
                gServNewFiscalType := '';
                gServNewDocNo := '';
                gServNewExtDocNo := '';
                gServNewPostingDate := 0D;
                gServNewDocDate := 0D;
                gServNewFiscalType := '';

                gServExtDocNoEnable := false;
                gServPostingDateEnable := false;
                gServDocDateEnable := false;
                gServFiscalTypeEnable := false;

                gServNewExtDocNoEnable := false;
                gServNewPostingDateEnable := false;
                gServNewDocDateEnable := false;
                gServNewFiscalTypeEnable := false;

                gServNavigateEnable := false;
                ServiceModifyEnable := false;
            end;        
        end;

        procedure ServiceCreditMemoRefresh()
        begin        
            if gServCreditNoteHeader."No." <> '' then begin
                gServDocNo := gServCreditNoteHeader."No.";
                //gServDocNoExt:=gServCreditNoteHeader."External Document No.";
                gServPostingDate := gServCreditNoteHeader."Posting Date";
                gServDacDate := gServCreditNoteHeader."Document Date";
                //gServFiscalType := gServCreditNoteHeader."Fiscal Type";

                gServNewDocNo := gServCreditNoteHeader."No.";
                //gServNewExtDocNo:=gServCreditNoteHeader."External Document No.";
                gServNewPostingDate := gServCreditNoteHeader."Posting Date";
                gServNewDocDate := gServCreditNoteHeader."Document Date";
                //gServNewFiscalType := gServCreditNoteHeader."Fiscal Type";

                gServExtDocNoEnable := true;
                gServPostingDateEnable := true;
                gServDocDateEnable := true;
                gServFiscalTypeEnable := true;

                gServNewDocNoEnable := true;
                gServNewExtDocNoEnable := true;
                gServNewPostingDateEnable := true;
                gServNewDocDateEnable := true;
                gServNewFiscalTypeEnable := true;

                gServNavigateEnable := true;
                ServiceModifyEnable := true;
            end
            else begin
                gServDocNo := '';
                gServDocNoExt := '';
                gServPostingDate := 0D;
                gServDacDate := 0D;
                gServFiscalType := '';
                gServNewFiscalType := '';
                gServNewDocNo := '';
                gServNewExtDocNo := '';
                gServNewPostingDate := 0D;
                gServNewDocDate := 0D;
                gServNewFiscalType := '';

                gServExtDocNoEnable := false;
                gServPostingDateEnable := false;
                gServDocDateEnable := false;
                gServFiscalTypeEnable := false;

                gServNewDocNoEnable := false;
                gServNewExtDocNoEnable := false;
                gServNewPostingDateEnable := false;
                gServNewDocDateEnable := false;
                gServNewFiscalTypeEnable := false;

                gServNavigateEnable := false;
                ServiceModifyEnable := false;
            end;
        end;*/

    procedure SetSalesVars(_SalesVoucherType: Option Facturas,"Notas Credito",Remitos;
                            _SalesNewDocumentNo: Code[20];
                            _SalesInvHeader: Record "Sales Invoice Header")
    begin
        SalesInvoiceHeader := _SalesInvHeader;
        SalesVoucherType := _SalesVoucherType;
        SalesInvoiceRefresh();
        //New
        SalesNewDocumentNo := _SalesNewDocumentNo;

    end;

    procedure SetSalesVarsNC(_SalesVoucherType: Option Facturas,"Notas Credito",Remitos;
                             _SalesNewDocumentNo: Code[20];
                             _SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        SalesCrMemoHeader := _SalesCrMemoHeader;
        SalesVoucherType := _SalesVoucherType;
        SalesCreditMemoRefresh();
        //New
        SalesNewDocumentNo := _SalesNewDocumentNo;

    end;

    procedure ModifySalesByCode()
    var
        lclPostedApprov: Record "Posted Approval Entry";
        lclPostedApprov1: Record "Posted Approval Entry";
        lclLineCommentLines: Record "Sales Comment Line";
        lclLineCommentLines1: Record "Sales Comment Line";
    begin
        case SalesVoucherType of
            SalesVoucherType::Facturas:
                begin
                    //External doc no
                    if SalesExternalDocumentNo <> SalesNewExternalDocumentNo then begin
                        VatEntry.Reset();
                        GLEntry.Reset();
                        CustLedgerEntry.Reset();
                        DetailedCustLedgEntry.Reset();
                        ResLedgerEntry.Reset();
                        ItemLedgerEntry.Reset();
                        ValueEntry.Reset();
                        FALedgerEntry.Reset();
                        VatEntry.SetRange(VatEntry."Document No.", SalesInvoiceHeader."No.");
                        if VatEntry.FindFirst() then
                            VatEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                        GLEntry.SetRange(GLEntry."Document No.", SalesInvoiceHeader."No.");
                        if GLEntry.FindFirst() then
                            GLEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                        CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                        if CustLedgerEntry.FindFirst() then
                            CustLedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                        ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                        if ResLedgerEntry.FindFirst() then
                            ResLedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                        if ItemLedgerEntry.FindFirst() then
                            ItemLedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                        ValueEntry.SetRange(ValueEntry."Document No.", SalesInvoiceHeader."No.");
                        if ValueEntry.FindFirst() then
                            ValueEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                        FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesInvoiceHeader."No.");
                        if FALedgerEntry.FindFirst() then
                            FALedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);

                        SalesInvoiceHeader."External Document No." := SalesNewExternalDocumentNo;
                        SalesInvoiceHeader.Modify();

                    end;

                    // Posting date
                    if SalesPostingDate <> SalesNewPostingDate then begin
                        VatEntry.Reset();
                        GLEntry.Reset();
                        CustLedgerEntry.Reset();
                        DetailedCustLedgEntry.Reset();
                        ResLedgerEntry.Reset();
                        ItemLedgerEntry.Reset();
                        ValueEntry.Reset();
                        FALedgerEntry.Reset();
                        VatEntry.SetRange(VatEntry."Document No.", SalesInvoiceHeader."No.");
                        if VatEntry.FindFirst() then
                            VatEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        /*////////-----Esta version de Nav no tiene postindate en G/L REGISTER
                             gglentry.SETRANGE(gglentry."Document No.",SalesInvoiceHeader."No.");
                             IF gglentry.FIND('-') THEN
                                 REPEAT
                                  gGlRegister.RESET;
                                  gGlRegister.SETRANGE(gGlRegister."From Entry No.",
                                                               gglentry."Entry No.");
                                  IF gGlRegister.FIND('-') THEN
                                     BEGIN
                                      gGlRegister."Posting Date":=SalesNewPostingDate;
                                      gGlRegister.MODIFY
                                     END;
                                 UNTIL gglentry.NEXT=0; */
                        GLEntry.Reset();
                        GLEntry.SetRange(GLEntry."Document No.", SalesInvoiceHeader."No.");
                        if GLEntry.FindFirst() then
                            GLEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                        if ResLedgerEntry.FindFirst() then
                            ResLedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                        if ItemLedgerEntry.FindFirst() then
                            ItemLedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        ValueEntry.SetRange(ValueEntry."Document No.", SalesInvoiceHeader."No.");
                        if ValueEntry.FindFirst() then
                            ValueEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesInvoiceHeader."No.");
                        if FALedgerEntry.FindFirst() then
                            FALedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                        if CustLedgerEntry.FindFirst() then
                            CustLedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Document No.", SalesInvoiceHeader."No.");
                        if DetailedCustLedgEntry.FindFirst() then
                            DetailedCustLedgEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        SalesInvoiceHeader."Posting Date" := SalesNewPostingDate;
                        SalesInvoiceHeader.Modify();
                    end;
                    //Doc date
                    if SalesDocumentDate <> SalesNewDocumentDate then begin
                        VatEntry.Reset();
                        GLEntry.Reset();
                        CustLedgerEntry.Reset();
                        DetailedCustLedgEntry.Reset();
                        ResLedgerEntry.Reset();
                        ItemLedgerEntry.Reset();
                        ValueEntry.Reset();
                        FALedgerEntry.Reset();
                        VatEntry.SetRange(VatEntry."Document No.", SalesInvoiceHeader."No.");
                        if VatEntry.FindFirst() then
                            VatEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        GLEntry.SetRange(GLEntry."Document No.", SalesInvoiceHeader."No.");
                        if GLEntry.FindFirst() then
                            GLEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                        if ResLedgerEntry.FindFirst() then
                            ResLedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                        if ItemLedgerEntry.FindFirst() then
                            ItemLedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        ValueEntry.SetRange(ValueEntry."Document No.", SalesInvoiceHeader."No.");
                        if ValueEntry.FindFirst() then
                            ValueEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesInvoiceHeader."No.");
                        if FALedgerEntry.FindFirst() then
                            FALedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                        if CustLedgerEntry.FindFirst() then
                            CustLedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        SalesInvoiceHeader."Document Date" := SalesNewDocumentDate;

                        SalesInvoiceHeader.Modify();
                    end;

                    //Fiscal date
                    /*if SalesFiscalType <> SalesNewFiscalType then begin
                        SalesInvoiceHeader."Fiscal Type" := SalesNewFiscalType;
                        SalesInvoiceHeader.Modify()
                    end;*/
                    //Actual doc no
                    if SalesDocumentNo <> SalesNewDocumentNo then begin
                        SalesInvoiceHeader2.Reset();
                        SalesInvoiceHeader2.SetRange(SalesInvoiceHeader2."No.", SalesNewDocumentNo);
                        if SalesInvoiceHeader2.FindFirst() then
                            Message(TextJXL00002Lbl, SalesNewExternalDocumentNo)
                        else begin
                            lclLineCommentLines.Reset();
                            lclLineCommentLines1.Reset();
                            lclPostedApprov.Reset();
                            lclPostedApprov1.Reset();

                            VatEntry.Reset();
                            GLEntry.Reset();
                            CustLedgerEntry.Reset();
                            DetailedCustLedgEntry.Reset();
                            ResLedgerEntry.Reset();
                            ItemLedgerEntry.Reset();
                            ValueEntry.Reset();
                            ValueEntry2.Reset();
                            FALedgerEntry.Reset();
                            JXVZHistReceiptVoucherLine.Reset();
                            SalesInvoiceLine.Reset();
                            ItemEntryRelation.Reset();
                            ValueEntryRelation.Reset();

                            lclLineCommentLines.SetRange(lclLineCommentLines."No.", SalesDocumentNo);
                            lclLineCommentLines.SetRange(lclLineCommentLines."Document Type",
                            lclLineCommentLines."Document Type"::"Posted Invoice");
                            if lclLineCommentLines.FindFirst() then
                                repeat
                                    lclLineCommentLines1.SetCurrentKey("Document Type", "No.", "Document Line No.", "Line No.");
                                    lclLineCommentLines1.Get(lclLineCommentLines."Document Type",
                                     lclLineCommentLines."No.", lclLineCommentLines."Document Line No.",
                                     lclLineCommentLines."Line No.");
                                    lclLineCommentLines1.Rename(lclLineCommentLines."Document Type",
                                     SalesNewDocumentNo, lclLineCommentLines."Document Line No.",
                                     lclLineCommentLines."Line No.");
                                until lclLineCommentLines.Next() = 0;

                            lclPostedApprov.SetRange(lclPostedApprov."Document No.", SalesDocumentNo);
                            lclPostedApprov.SetRange(lclPostedApprov."Table ID", 112);
                            if lclPostedApprov.FindFirst() then
                                repeat
                                    lclPostedApprov1.SetCurrentKey("Table ID", "Document No.", "Sequence No.");
                                    lclPostedApprov1.SetRange("Table ID", lclPostedApprov."Table ID");
                                    lclPostedApprov1.SetRange("Document No.", lclPostedApprov."Document No.");
                                    lclPostedApprov1.SetRange("Sequence No.", lclPostedApprov."Sequence No.");
                                    if lclPostedApprov1.FindFirst() then begin
                                        lclPostedApprov1."Document No." := SalesNewDocumentNo;
                                        lclPostedApprov1.Modify(false);
                                    end;
                                /*Old Code
                                lclPostedApprov1.Get(lclPostedApprov."Table ID",
                                 lclPostedApprov."Document No.", lclPostedApprov."Sequence No.");

                                lclPostedApprov1.Rename(lclPostedApprov."Table ID",
                                 SalesNewDocumentNo, lclPostedApprov."Sequence No.");
                                 */
                                until lclPostedApprov.Next() = 0;

                            SalesInvoiceLine.SetRange(SalesInvoiceLine."Document No.", SalesInvoiceHeader."No.");
                            if SalesInvoiceLine.FindFirst() then
                                repeat
                                    SalesInvoiceLine2.SetCurrentKey("Document No.", "Line No.");
                                    SalesInvoiceLine2.Get(SalesInvoiceLine."Document No.", SalesInvoiceLine."Line No.");
                                    SalesInvoiceLine2.Rename(SalesNewDocumentNo, SalesInvoiceLine."Line No.");
                                until SalesInvoiceLine.Next() = 0;
                            VatEntry.SetRange(VatEntry."Document No.", SalesInvoiceHeader."No.");
                            if VatEntry.FindFirst() then
                                VatEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            GLEntry.SetRange(GLEntry."Document No.", SalesInvoiceHeader."No.");
                            if GLEntry.FindFirst() then
                                GLEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                            if ResLedgerEntry.FindFirst() then
                                ResLedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                            if ItemLedgerEntry.FindFirst() then
                                ItemLedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            ValueEntry.SetRange(ValueEntry."Document No.", SalesInvoiceHeader."No.");
                            ValueEntry2.SetRange(ValueEntry2."Document No.", SalesInvoiceHeader."No.");
                            if ValueEntry2.FindFirst() then
                                repeat
                                    OK := ValueEntryRelation.Get(ValueEntry2."Entry No.");
                                    if OK then begin
                                        Clear(Pos);
                                        Pos := StrPos(ValueEntryRelation."Source RowId", SalesDocumentNo);
                                        if Pos <> 0 then begin
                                            ValueEntryRelation."Source RowId" :=
                                             DelStr(ValueEntryRelation."Source RowId", Pos, StrLen(SalesDocumentNo));

                                            ValueEntryRelation."Source RowId" :=
                                             InsStr(ValueEntryRelation."Source RowId", SalesNewDocumentNo, Pos);
                                            ValueEntryRelation.Modify();
                                        end;
                                    end;
                                until ValueEntry2.Next() = 0;
                            if ValueEntry.FindFirst() then
                                ValueEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesInvoiceHeader."No.");
                            if FALedgerEntry.FindFirst() then
                                FALedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesInvoiceHeader."No.");
                            if CustLedgerEntry.FindFirst() then
                                CustLedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Document No.", SalesInvoiceHeader."No.");
                            if DetailedCustLedgEntry.FindFirst() then
                                DetailedCustLedgEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            ItemEntryRelation.SetRange(ItemEntryRelation."Source ID", SalesInvoiceHeader."No.");
                            if ItemEntryRelation.FindFirst() then
                                ItemEntryRelation.ModifyAll(ItemEntryRelation."Source ID", SalesNewDocumentNo);
                            JXVZHistReceiptVoucherLine.SetRange(JXVZHistReceiptVoucherLine.JXVZVoucherNo, SalesInvoiceHeader."No.");
                            if JXVZHistReceiptVoucherLine.FindFirst() then
                                repeat
                                    JXVZHistReceiptVoucherLine2.Get(
                                                              JXVZHistReceiptVoucherLine.JXVZReceiptNo,
                                                              JXVZHistReceiptVoucherLine.JXVZVoucherNo,
                                                              JXVZHistReceiptVoucherLine.JXVZEntryNo);
                                    JXVZHistReceiptVoucherLine.Rename(JXVZHistReceiptVoucherLine2.JXVZReceiptNo,
                                                                SalesNewDocumentNo, JXVZHistReceiptVoucherLine2.JXVZEntryNo);

                                until JXVZHistReceiptVoucherLine.Next() = 0;


                            SalesInvoiceHeader.Rename(SalesNewDocumentNo);
                        end;
                    end;
                end;

            SalesVoucherType::"Notas Credito":
                begin
                    //  External doc no
                    if SalesExternalDocumentNo <> SalesNewExternalDocumentNo then begin
                        VatEntry.Reset();
                        GLEntry.Reset();
                        CustLedgerEntry.Reset();
                        DetailedCustLedgEntry.Reset();
                        ResLedgerEntry.Reset();
                        ItemLedgerEntry.Reset();
                        ValueEntry.Reset();
                        FALedgerEntry.Reset();
                        VatEntry.SetRange(VatEntry."Document No.", SalesCrMemoHeader."No.");
                        if VatEntry.FindFirst() then
                            VatEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                        GLEntry.SetRange(GLEntry."Document No.", SalesCrMemoHeader."No.");
                        if GLEntry.FindFirst() then
                            GLEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                        CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                        if CustLedgerEntry.FindFirst() then
                            CustLedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                        ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                        if ResLedgerEntry.FindFirst() then
                            ResLedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                        if ItemLedgerEntry.FindFirst() then
                            ItemLedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                        ValueEntry.SetRange(ValueEntry."Document No.", SalesCrMemoHeader."No.");
                        if ValueEntry.FindFirst() then
                            ValueEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                        FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesCrMemoHeader."No.");
                        if FALedgerEntry.FindFirst() then
                            FALedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);

                        SalesCrMemoHeader."External Document No." := SalesNewExternalDocumentNo;
                        SalesCrMemoHeader.Modify();

                    end;

                    //Posting date
                    if SalesPostingDate <> SalesNewPostingDate then begin
                        VatEntry.Reset();
                        GLEntry.Reset();
                        CustLedgerEntry.Reset();
                        DetailedCustLedgEntry.Reset();
                        ResLedgerEntry.Reset();
                        ItemLedgerEntry.Reset();
                        ValueEntry.Reset();
                        FALedgerEntry.Reset();
                        VatEntry.SetRange(VatEntry."Document No.", SalesCrMemoHeader."No.");
                        if VatEntry.FindFirst() then
                            VatEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        /*////////-----Esta version de Nav no tiene postindate en G/L REGISTER
                           gglentry.SETRANGE(gglentry."Document No.",SalesCrMemoHeader."No.");
                           IF gglentry.FIND('-') THEN
                               REPEAT
                                gGlRegister.RESET;
                                gGlRegister.SETRANGE(gGlRegister."From Entry No.",
                                                             gglentry."Entry No.");
                                IF gGlRegister.FIND('-') THEN
                                   BEGIN
                                    gGlRegister."Posting Date":=SalesNewPostingDate;
                                    gGlRegister.MODIFY
                                   END;
                               UNTIL gglentry.NEXT=0; */
                        GLEntry.Reset();
                        GLEntry.SetRange(GLEntry."Document No.", SalesCrMemoHeader."No.");
                        if GLEntry.FindFirst() then
                            GLEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                        if ResLedgerEntry.FindFirst() then
                            ResLedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                        if ItemLedgerEntry.FindFirst() then
                            ItemLedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        ValueEntry.SetRange(ValueEntry."Document No.", SalesCrMemoHeader."No.");
                        if ValueEntry.FindFirst() then
                            ValueEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesCrMemoHeader."No.");
                        if FALedgerEntry.FindFirst() then
                            FALedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                        if CustLedgerEntry.FindFirst() then
                            CustLedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Document No.", SalesCrMemoHeader."No.");
                        if DetailedCustLedgEntry.FindFirst() then
                            DetailedCustLedgEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        SalesCrMemoHeader."Posting Date" := SalesNewPostingDate;

                        SalesCrMemoHeader.Modify();
                    end;
                    //Doc date
                    if SalesDocumentDate <> SalesNewDocumentDate then begin
                        VatEntry.Reset();
                        GLEntry.Reset();
                        CustLedgerEntry.Reset();
                        DetailedCustLedgEntry.Reset();
                        ResLedgerEntry.Reset();
                        ItemLedgerEntry.Reset();
                        ValueEntry.Reset();
                        FALedgerEntry.Reset();
                        VatEntry.SetRange(VatEntry."Document No.", SalesCrMemoHeader."No.");
                        if VatEntry.FindFirst() then
                            VatEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        GLEntry.SetRange(GLEntry."Document No.", SalesCrMemoHeader."No.");
                        if GLEntry.FindFirst() then
                            GLEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                        if ResLedgerEntry.FindFirst() then
                            ResLedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                        if ItemLedgerEntry.FindFirst() then
                            ItemLedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        ValueEntry.SetRange(ValueEntry."Document No.", SalesCrMemoHeader."No.");
                        if ValueEntry.FindFirst() then
                            ValueEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesCrMemoHeader."No.");
                        if FALedgerEntry.FindFirst() then
                            FALedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                        if CustLedgerEntry.FindFirst() then
                            CustLedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        SalesCrMemoHeader."Document Date" := SalesNewDocumentDate;

                        SalesCrMemoHeader.Modify();
                    end;
                    //Fiscal type
                    /*if SalesFiscalType <> SalesNewFiscalType then begin
                        SalesCrMemoHeader."Fiscal Type" := SalesNewFiscalType;
                        SalesCrMemoHeader.Modify()
                    end;*/

                    //Actual doc no
                    if SalesDocumentNo <> SalesNewDocumentNo then begin
                        SalesCrMemoHeader2.Reset();
                        SalesCrMemoHeader2.SetRange(SalesCrMemoHeader2."No.", SalesNewDocumentNo);
                        if SalesCrMemoHeader2.FindFirst() then
                            Message(TextJXL00002Lbl, SalesNewExternalDocumentNo)
                        else begin
                            lclLineCommentLines.Reset();
                            lclLineCommentLines1.Reset();
                            lclPostedApprov.Reset();
                            lclPostedApprov1.Reset();

                            VatEntry.Reset();
                            GLEntry.Reset();
                            CustLedgerEntry.Reset();
                            DetailedCustLedgEntry.Reset();
                            ResLedgerEntry.Reset();
                            ItemLedgerEntry.Reset();
                            ValueEntry.Reset();
                            ValueEntry2.Reset();
                            FALedgerEntry.Reset();
                            ItemEntryRelation.Reset();
                            ValueEntryRelation.Reset();
                            JXVZHistReceiptVoucherLine.Reset();

                            lclLineCommentLines.SetRange(lclLineCommentLines."No.", SalesDocumentNo);
                            lclLineCommentLines.SetRange(lclLineCommentLines."Document Type",
                            lclLineCommentLines."Document Type"::"Posted Credit Memo");
                            if lclLineCommentLines.FindFirst() then
                                repeat
                                    lclLineCommentLines1.SetCurrentKey("Document Type", "No.", "Document Line No.", "Line No.");
                                    lclLineCommentLines1.Get(lclLineCommentLines."Document Type",
                                     lclLineCommentLines."No.", lclLineCommentLines."Document Line No.",
                                     lclLineCommentLines."Line No.");
                                    lclLineCommentLines1.Rename(lclLineCommentLines."Document Type",
                                     SalesNewDocumentNo, lclLineCommentLines."Document Line No.",
                                     lclLineCommentLines."Line No.");
                                until lclLineCommentLines.Next() = 0;

                            lclPostedApprov.SetRange(lclPostedApprov."Document No.", SalesDocumentNo);
                            lclPostedApprov.SetRange(lclPostedApprov."Table ID", 114);
                            if lclPostedApprov.FindFirst() then
                                repeat
                                    lclPostedApprov1.SetCurrentKey("Table ID", "Document No.", "Sequence No.");
                                    lclPostedApprov1.SetRange("Table ID", lclPostedApprov."Table ID");
                                    lclPostedApprov1.SetRange("Document No.", lclPostedApprov."Document No.");
                                    lclPostedApprov1.SetRange("Sequence No.", lclPostedApprov."Sequence No.");
                                    if lclPostedApprov1.FindFirst() then begin
                                        lclPostedApprov1."Document No." := SalesNewDocumentNo;
                                        lclPostedApprov1.Modify(false);
                                    end;
                                /* Old Code
                                lclPostedApprov1.SetCurrentKey("Table ID", "Document No.", "Sequence No.");
                                lclPostedApprov1.Get(lclPostedApprov."Table ID",
                                 lclPostedApprov."Document No.", lclPostedApprov."Sequence No.");
                                lclPostedApprov1.Rename(lclPostedApprov."Table ID",
                                 SalesNewDocumentNo, lclPostedApprov."Sequence No.");
                                 */
                                until lclPostedApprov.Next() = 0;

                            SalesCrMemoLine.Reset();
                            SalesCrMemoLine.SetRange(SalesCrMemoLine."Document No.", SalesCrMemoHeader."No.");
                            if SalesCrMemoLine.FindFirst() then
                                repeat
                                    SalesCrMemoLine2.SetCurrentKey("Document No.", "Line No.");
                                    SalesCrMemoLine2.Get(SalesCrMemoLine."Document No.", SalesCrMemoLine."Line No.");
                                    SalesCrMemoLine2.Rename(SalesNewDocumentNo, SalesCrMemoLine."Line No.");
                                until SalesCrMemoLine.Next() = 0;
                            VatEntry.SetRange(VatEntry."Document No.", SalesCrMemoHeader."No.");
                            if VatEntry.FindFirst() then
                                VatEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            GLEntry.SetRange(GLEntry."Document No.", SalesCrMemoHeader."No.");
                            if GLEntry.FindFirst() then
                                GLEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                            if ResLedgerEntry.FindFirst() then
                                ResLedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                            if ItemLedgerEntry.FindFirst() then
                                ItemLedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            ValueEntry.SetRange(ValueEntry."Document No.", SalesCrMemoHeader."No.");
                            ValueEntry2.SetRange(ValueEntry2."Document No.", SalesCrMemoHeader."No.");
                            if ValueEntry2.FindFirst() then
                                repeat
                                    OK := ValueEntryRelation.Get(ValueEntry2."Entry No.");
                                    if OK then begin
                                        Clear(Pos);
                                        Pos := StrPos(ValueEntryRelation."Source RowId", SalesDocumentNo);
                                        if Pos <> 0 then begin
                                            ValueEntryRelation."Source RowId" :=
                                             DelStr(ValueEntryRelation."Source RowId", Pos, StrLen(SalesDocumentNo));

                                            ValueEntryRelation."Source RowId" :=
                                             InsStr(ValueEntryRelation."Source RowId", SalesNewDocumentNo, Pos);
                                            ValueEntryRelation.Modify();
                                        end;
                                    end;
                                until ValueEntry2.Next() = 0;
                            if ValueEntry.FindFirst() then
                                ValueEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesCrMemoHeader."No.");
                            if FALedgerEntry.FindFirst() then
                                FALedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesCrMemoHeader."No.");
                            if CustLedgerEntry.FindFirst() then
                                CustLedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Document No.", SalesCrMemoHeader."No.");
                            if DetailedCustLedgEntry.FindFirst() then
                                DetailedCustLedgEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            ItemEntryRelation.SetRange(ItemEntryRelation."Source ID", SalesCrMemoHeader."No.");
                            if ItemEntryRelation.FindFirst() then
                                ItemEntryRelation.ModifyAll(ItemEntryRelation."Source ID", SalesNewDocumentNo);
                            JXVZHistReceiptVoucherLine.SetRange(JXVZHistReceiptVoucherLine.JXVZVoucherNo, SalesCrMemoHeader."No.");
                            if JXVZHistReceiptVoucherLine.FindFirst() then
                                repeat
                                    JXVZHistReceiptVoucherLine2.Get(
                                                              JXVZHistReceiptVoucherLine.JXVZReceiptNo,
                                                              JXVZHistReceiptVoucherLine.JXVZVoucherNo,
                                                              JXVZHistReceiptVoucherLine.JXVZEntryNo);
                                    JXVZHistReceiptVoucherLine.Rename(JXVZHistReceiptVoucherLine2.JXVZReceiptNo,
                                                                SalesNewDocumentNo,
                                                                JXVZHistReceiptVoucherLine2.JXVZEntryNo);
                                until JXVZHistReceiptVoucherLine.Next() = 0;


                            SalesCrMemoHeader.Rename(SalesNewDocumentNo);
                        end;
                    end;
                end;

            SalesVoucherType::Remitos:
                begin
                    //Ext. doc. no
                    if SalesExternalDocumentNo <> SalesNewExternalDocumentNo then begin
                        VatEntry.Reset();
                        GLEntry.Reset();
                        CustLedgerEntry.Reset();
                        DetailedCustLedgEntry.Reset();
                        ResLedgerEntry.Reset();
                        ItemLedgerEntry.Reset();
                        ValueEntry.Reset();
                        FALedgerEntry.Reset();
                        VatEntry.SetRange(VatEntry."Document No.", SalesShipmentHeader."No.");
                        if VatEntry.FindFirst() then
                            VatEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                        GLEntry.SetRange(GLEntry."Document No.", SalesShipmentHeader."No.");
                        if GLEntry.FindFirst() then
                            GLEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                        CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesShipmentHeader."No.");
                        if CustLedgerEntry.FindFirst() then
                            CustLedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                        ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesShipmentHeader."No.");
                        if ResLedgerEntry.FindFirst() then
                            ResLedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesShipmentHeader."No.");
                        if ItemLedgerEntry.FindFirst() then
                            ItemLedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                        ValueEntry.SetRange(ValueEntry."Document No.", SalesShipmentHeader."No.");
                        if ValueEntry.FindFirst() then
                            ValueEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);
                        FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesShipmentHeader."No.");
                        if FALedgerEntry.FindFirst() then
                            FALedgerEntry.ModifyAll("External Document No.", SalesNewExternalDocumentNo);

                        SalesShipmentHeader."External Document No." := SalesNewExternalDocumentNo;
                        SalesShipmentHeader.Modify();

                    end;

                    // Posting date
                    if SalesPostingDate <> SalesNewPostingDate then begin
                        VatEntry.Reset();
                        GLEntry.Reset();
                        CustLedgerEntry.Reset();
                        DetailedCustLedgEntry.Reset();
                        ResLedgerEntry.Reset();
                        ItemLedgerEntry.Reset();
                        ValueEntry.Reset();
                        FALedgerEntry.Reset();
                        VatEntry.SetRange(VatEntry."Document No.", SalesShipmentHeader."No.");
                        if VatEntry.FindFirst() then
                            VatEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        /*////////-----Esta version de Nav no tiene postindate en G/L REGISTER
                              gglentry.SETRANGE(gglentry."Document No.",SalesShipmentHeader."No.");
                              IF gglentry.FIND('-') THEN
                                  REPEAT
                                   gGlRegister.RESET;
                                   gGlRegister.SETRANGE(gGlRegister."From Entry No.",
                                                                gglentry."Entry No.");
                                   IF gGlRegister.FIND('-') THEN
                                      BEGIN
                                       gGlRegister."Posting Date":=SalesNewPostingDate;
                                       gGlRegister.MODIFY
                                      END;
                                  UNTIL gglentry.NEXT=0;        */
                        GLEntry.Reset();
                        GLEntry.SetRange(GLEntry."Document No.", SalesShipmentHeader."No.");
                        if GLEntry.FindFirst() then
                            GLEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesShipmentHeader."No.");
                        if ResLedgerEntry.FindFirst() then
                            ResLedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesShipmentHeader."No.");
                        if ItemLedgerEntry.FindFirst() then
                            ItemLedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        ValueEntry.SetRange(ValueEntry."Document No.", SalesShipmentHeader."No.");
                        if ValueEntry.FindFirst() then
                            ValueEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesShipmentHeader."No.");
                        if FALedgerEntry.FindFirst() then
                            FALedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesShipmentHeader."No.");
                        if CustLedgerEntry.FindFirst() then
                            CustLedgerEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Document No.", SalesShipmentHeader."No.");
                        if DetailedCustLedgEntry.FindFirst() then
                            DetailedCustLedgEntry.ModifyAll("Posting Date", SalesNewPostingDate);
                        SalesShipmentHeader."Posting Date" := SalesNewPostingDate;

                        SalesShipmentHeader.Modify();
                    end;
                    //Doc. date
                    if SalesDocumentDate <> SalesNewDocumentDate then begin
                        VatEntry.Reset();
                        GLEntry.Reset();
                        CustLedgerEntry.Reset();
                        DetailedCustLedgEntry.Reset();
                        ResLedgerEntry.Reset();
                        ItemLedgerEntry.Reset();
                        ValueEntry.Reset();
                        FALedgerEntry.Reset();
                        VatEntry.SetRange(VatEntry."Document No.", SalesShipmentHeader."No.");
                        if VatEntry.FindFirst() then
                            VatEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        GLEntry.SetRange(GLEntry."Document No.", SalesShipmentHeader."No.");
                        if GLEntry.FindFirst() then
                            GLEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesShipmentHeader."No.");
                        if ResLedgerEntry.FindFirst() then
                            ResLedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesShipmentHeader."No.");
                        if ItemLedgerEntry.FindFirst() then
                            ItemLedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        ValueEntry.SetRange(ValueEntry."Document No.", SalesShipmentHeader."No.");
                        if ValueEntry.FindFirst() then
                            ValueEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesShipmentHeader."No.");
                        if FALedgerEntry.FindFirst() then
                            FALedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesShipmentHeader."No.");
                        if CustLedgerEntry.FindFirst() then
                            CustLedgerEntry.ModifyAll("Document Date", SalesNewDocumentDate);
                        SalesShipmentHeader."Document Date" := SalesNewDocumentDate;

                        SalesShipmentHeader.Modify();
                    end;

                    /*//-------------Nuevo Tipo fiscal-----------------------
                    IF SalesFiscalType<>SalesNewFiscalType THEN
                    BEGIN
                    SalesShipmentHeader."Tipo Fiscal":=SalesNewFiscalType;
                    SalesShipmentHeader.MODIFY
                    END;*/

                    //Actual doc. no.
                    if SalesDocumentNo <> SalesNewDocumentNo then begin
                        SalesShipmentHeader2.Reset();
                        SalesShipmentHeader2.SetRange(SalesShipmentHeader2."No.", SalesNewDocumentNo);
                        if SalesShipmentHeader2.FindFirst() then
                            Message(TextJXL00002Lbl, SalesNewExternalDocumentNo)
                        else begin
                            lclLineCommentLines.Reset();
                            lclLineCommentLines1.Reset();
                            lclPostedApprov.Reset();
                            lclPostedApprov1.Reset();

                            VatEntry.Reset();
                            GLEntry.Reset();
                            CustLedgerEntry.Reset();
                            DetailedCustLedgEntry.Reset();
                            ResLedgerEntry.Reset();
                            ItemLedgerEntry.Reset();
                            ValueEntry.Reset();
                            ValueEntry2.Reset();
                            FALedgerEntry.Reset();
                            ItemEntryRelation.Reset();
                            ValueEntryRelation.Reset();

                            lclLineCommentLines.SetRange(lclLineCommentLines."No.", SalesDocumentNo);
                            lclLineCommentLines.SetRange(lclLineCommentLines."Document Type",
                            lclLineCommentLines."Document Type"::"Posted Return Receipt");
                            if lclLineCommentLines.FindFirst() then
                                repeat
                                    lclLineCommentLines1.SetCurrentKey("Document Type", "No.", "Document Line No.", "Line No.");
                                    lclLineCommentLines1.Get(lclLineCommentLines."Document Type",
                                     lclLineCommentLines."No.", lclLineCommentLines."Document Line No.",
                                     lclLineCommentLines."Line No.");
                                    lclLineCommentLines1.Rename(lclLineCommentLines."Document Type",
                                     SalesNewDocumentNo, lclLineCommentLines."Document Line No.",
                                     lclLineCommentLines."Line No.");
                                until lclLineCommentLines.Next() = 0;

                            lclPostedApprov.SetRange(lclPostedApprov."Document No.", SalesDocumentNo);
                            lclPostedApprov.SetRange(lclPostedApprov."Table ID", 110);
                            if lclPostedApprov.FindFirst() then
                                repeat
                                    lclPostedApprov1.SetCurrentKey("Table ID", "Document No.", "Sequence No.");
                                    lclPostedApprov1.SetRange("Table ID", lclPostedApprov."Table ID");
                                    lclPostedApprov1.SetRange("Document No.", lclPostedApprov."Document No.");
                                    lclPostedApprov1.SetRange("Sequence No.", lclPostedApprov."Sequence No.");
                                    if lclPostedApprov1.FindFirst() then begin
                                        lclPostedApprov1."Document No." := SalesNewDocumentNo;
                                        lclPostedApprov1.Modify(false);
                                    end;
                                /*Old Code
                                lclPostedApprov1.SetCurrentKey("Table ID", "Document No.", "Sequence No.");
                                lclPostedApprov1.Get(lclPostedApprov."Table ID",
                                 lclPostedApprov."Document No.", lclPostedApprov."Sequence No.");
                                lclPostedApprov1.Rename(lclPostedApprov."Table ID",
                                 SalesNewDocumentNo, lclPostedApprov."Sequence No.");
                                 */
                                until lclPostedApprov.Next() = 0;

                            SalesShipmentLine.Reset();
                            SalesShipmentLine.SetRange(SalesShipmentLine."Document No.", SalesShipmentHeader."No.");
                            if SalesShipmentLine.FindFirst() then
                                repeat
                                    SalesShipmentLine2.SetCurrentKey("Document No.", "Line No.");
                                    SalesShipmentLine2.Get(SalesShipmentLine."Document No.", SalesShipmentLine."Line No.");
                                    SalesShipmentLine2.Rename(SalesNewDocumentNo, SalesShipmentLine."Line No.");
                                until SalesShipmentLine.Next() = 0;
                            VatEntry.SetRange(VatEntry."Document No.", SalesShipmentHeader."No.");
                            if VatEntry.FindFirst() then
                                VatEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            GLEntry.SetRange(GLEntry."Document No.", SalesShipmentHeader."No.");
                            if GLEntry.FindFirst() then
                                GLEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            ResLedgerEntry.SetRange(ResLedgerEntry."Document No.", SalesShipmentHeader."No.");
                            if ResLedgerEntry.FindFirst() then
                                ResLedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", SalesShipmentHeader."No.");
                            if ItemLedgerEntry.FindFirst() then
                                ItemLedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            ValueEntry.SetRange(ValueEntry."Document No.", SalesShipmentHeader."No.");
                            ValueEntry2.SetRange(ValueEntry2."Document No.", SalesShipmentHeader."No.");
                            if ValueEntry2.FindFirst() then
                                repeat
                                    OK := ValueEntryRelation.Get(ValueEntry2."Entry No.");
                                    if OK then begin
                                        Clear(Pos);
                                        Pos := StrPos(ValueEntryRelation."Source RowId", SalesDocumentNo);
                                        if Pos <> 0 then begin
                                            ValueEntryRelation."Source RowId" :=
                                             DelStr(ValueEntryRelation."Source RowId", Pos, StrLen(SalesDocumentNo));

                                            ValueEntryRelation."Source RowId" :=
                                             InsStr(ValueEntryRelation."Source RowId", SalesNewDocumentNo, Pos);
                                            ValueEntryRelation.Modify();
                                        end;
                                    end;
                                until ValueEntry2.Next() = 0;
                            if ValueEntry.FindFirst() then
                                ValueEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            FALedgerEntry.SetRange(FALedgerEntry."Document No.", SalesShipmentHeader."No.");
                            if FALedgerEntry.FindFirst() then
                                FALedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", SalesShipmentHeader."No.");
                            if CustLedgerEntry.FindFirst() then
                                CustLedgerEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Document No.", SalesShipmentHeader."No.");
                            if DetailedCustLedgEntry.FindFirst() then
                                DetailedCustLedgEntry.ModifyAll("Document No.", SalesNewDocumentNo);
                            ItemEntryRelation.SetRange(ItemEntryRelation."Source ID", SalesShipmentHeader."No.");
                            if ItemEntryRelation.FindFirst() then
                                ItemEntryRelation.ModifyAll(ItemEntryRelation."Source ID", SalesNewDocumentNo);
                            SalesShipmentHeader.Rename(SalesNewDocumentNo);
                        end;
                    end;
                end;
        end;
    end;
}