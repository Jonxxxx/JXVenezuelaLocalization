page 84130 JXVZHistoryPaymOrderList
{
    Caption = 'Posted payment order list', Comment = 'ESP=Lista de ordenes de pago registradas';
    CardPageID = JXVZHistoryPaymOrder;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = JXVZHistoryPaymOrder;
    SourceTableView = sorting(JXVZNo) order(descending);
    ApplicationArea = All;
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                ShowCaption = false;
                field(JXVZNo; Rec.JXVZNo)
                {
                    Tooltip = 'No.', Comment = 'ESP=No.';
                    ApplicationArea = All;
                }
                field(JXVZDocumentDate; Rec.JXVZDocumentDate)
                {
                    Tooltip = 'Document date', Comment = 'ESP=Fecha documento';
                    ApplicationArea = All;
                }
                field(JXVZPostingDate; Rec.JXVZPostingDate)
                {
                    Tooltip = 'Posting date', Comment = 'ESP=Fecha registro';
                    ApplicationArea = All;
                }
                field(JXVZVendorNo; Rec.JXVZVendorNo)
                {
                    Tooltip = 'Vendor No.', Comment = 'ESP=Codigo proveedor';
                    ApplicationArea = All;
                }
                field(JXVZName; Rec.JXVZName)
                {
                    Tooltip = 'Name', Comment = 'ESP=Nombre';
                    ApplicationArea = All;
                }
                field(JXVZStatus; Rec.JXVZStatus)
                {
                    ApplicationArea = All;
                    ToolTip = 'Status';
                }
                field(JXVZAmountLCY; Rec.JXVZAmountLCY)
                {
                    Tooltip = 'Amount', Comment = 'ESP=Importe';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Navegar")
            {
                ApplicationArea = All;
                Caption = 'Navigate', Comment = 'ESP=Navegar';
                ToolTip = 'Navigate', Comment = 'ESP=Navegar';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    gNavigate.SetDoc(Rec.JXVZPostingDate, Rec.JXVZNo);
                    gNavigate.Run();
                end;
            }

            action(JXVZPrintPaymentOrders)
            {
                ApplicationArea = All;
                Caption = 'Print payment orders', Comment = 'ESP=Imprimir ordenes de pago';
                ToolTip = 'Print payment orders', Comment = 'ESP=Imprimir ordenes de pago';
                Image = Print;

                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    PostedPaymentOrder: Record JXVZHistoryPaymOrder;
                    PostedPaymentOrderAux: Record JXVZHistoryPaymOrder;
                    JXVZPaymentSetup: Record JXVZPaymentSetup;
                    JXVZWithholdLedgerEntryLocal: Record JXVZWithholdLedgerEntry;
                    JXVZWithholdDetailEntryLocal: Record JXVZWithholdDetailEntry;
                    JXVZPostedValuesLine: Record JXVZHistPaymValueLine;

                    //TempBlob: Record TempBlob temporary;
                    TempBlob: Codeunit "Temp Blob";
                    Out: OutStream;
                    RecRef: RecordRef;
                    FileManagementCdu: Codeunit "File Management";
                    DataCompression: Codeunit "Data Compression";
                    SalesHeader_lRec: Record "Sales Header";

                    ZipStream: InStream;
                    FileStream: InStream;
                    ZipedFile: OutStream;
                    //ZipBlob: Record TempBlob temporary;
                    ZipBlob: Codeunit "Temp Blob";
                    ZipName: Text;
                begin

                    JXVZPaymentSetup.Reset();
                    JXVZPaymentSetup.Get();

                    DataCompression.CreateZipArchive();

                    PostedPaymentOrder.Reset();
                    CurrPage.SetSelectionFilter(PostedPaymentOrder);
                    if (PostedPaymentOrder.FindSet()) then
                        repeat
                            Clear(Out);
                            clear(TempBlob);
                            clear(RecRef);
                            clear(FileStream);
                            Clear(ZipedFile);
                            TempBlob.CreateOutStream(Out, TEXTENCODING::UTF8);
                            TempBlob.CreateInStream(FileStream, TEXTENCODING::UTF8);
                            ZipBlob.CreateOutStream(ZipedFile, TEXTENCODING::UTF8);

                            //Print OP
                            PostedPaymentOrderAux.Reset();
                            PostedPaymentOrderAux.SetRange(JXVZNo, PostedPaymentOrder.JXVZNo);
                            if PostedPaymentOrderAux.FindFirst() then begin
                                RecRef.GetTable(PostedPaymentOrderAux);
                                REPORT.SAVEAS(JXVZPaymentSetup.JXVZHisPaymentReport, '', REPORTFORMAT::Pdf, Out, RecRef);
                                //TODO: Ver                                
                                //FileManagementCdu.AddStreamToZipStream(ZipedFile, FileStream, STRSUBSTNO('%1.Pdf', PostedPaymentOrderAux.JXVZNo));   
                                DataCompression.AddEntry(FileStream, STRSUBSTNO('%1.Pdf', PostedPaymentOrderAux.JXVZNo));
                            end;

                            //Print withholdings certs
                            JXVZPostedValuesLine.Reset();
                            JXVZPostedValuesLine.SetRange(JXVZPostedValuesLine.JXVZNo, Rec.JXVZNo);
                            JXVZPostedValuesLine.SetFilter(JXVZPostedValuesLine.JXVZWitholdingNo, '<>%1', 0);
                            if JXVZPostedValuesLine.FindSet() then
                                repeat
                                    JXVZWithholdLedgerEntryLocal.Reset();
                                    JXVZWithholdLedgerEntryLocal.SetRange(JXVZWithholdLedgerEntryLocal.JXVZVoucherNo, JXVZPostedValuesLine.JXVZNo);
                                    JXVZWithholdLedgerEntryLocal.SetRange(JXVZWitholdingNo, JXVZPostedValuesLine.JXVZWitholdingNo);
                                    if JXVZWithholdLedgerEntryLocal.FindSet() then
                                        repeat
                                            JXVZWithholdDetailEntryLocal.Reset();
                                            JXVZWithholdDetailEntryLocal.SetRange(JXVZWithholdDetailEntryLocal.JXVZWitholdingNo, JXVZWithholdLedgerEntryLocal.JXVZWitholdingNo);
                                            if JXVZWithholdDetailEntryLocal.FindFirst() then begin
                                                Clear(Out);
                                                clear(RecRef);
                                                clear(TempBlob);
                                                clear(FileStream);
                                                Clear(ZipedFile);
                                                RecRef.GetTable(JXVZWithholdLedgerEntryLocal);

                                                TempBlob.CreateOutStream(Out, TEXTENCODING::UTF8);
                                                TempBlob.CreateInStream(FileStream, TEXTENCODING::UTF8);
                                                ZipBlob.CreateOutStream(ZipedFile, TEXTENCODING::UTF8);

                                                REPORT.SAVEAS(JXVZWithholdDetailEntryLocal.JXVZReportID, '', REPORTFORMAT::Pdf, Out, RecRef);
                                                //TODO: VER
                                                //FileManagementCdu.AddStreamToZipStream(ZipedFile, FileStream, STRSUBSTNO('%1.Pdf', PostedPaymentOrderAux.JXVZNo + '_' + JXVZWithholdDetailEntryLocal.JXVZReportDescription));
                                                DataCompression.AddEntry(FileStream, STRSUBSTNO('%1.Pdf', PostedPaymentOrderAux.JXVZNo + '_' + JXVZWithholdDetailEntryLocal.JXVZReportDescription));
                                            end;
                                        until JXVZWithholdLedgerEntryLocal.Next() = 0;

                                until JXVZPostedValuesLine.Next() = 0;

                        until PostedPaymentOrder.Next() = 0;
                    /*Old
                    ZipBlob.CreateInStream(ZipStream);
                    ZipName := StrSubstNo('%1.zip', 'OrdenesDePago');
                    DownloadFromStream(ZipStream, 'Dialog', 'Folder', '', ZipName);
                    */

                    ZipName := StrSubstNo('%1.zip', 'OrdenesDePago');
                    DataCompression.SaveZipArchive(TempBlob);
                    TempBlob.CreateInStream(ZipStream);
                    DownloadFromStream(ZipStream, '', '', '', ZipName);

                    Message('Ordenes de pago generadas en PDF');
                    //7271  -  CAS-14016-H8D5B7  -  JX END
                end;
            }
        }
    }

    var
        gNavigate: Page Navigate;
}

