page 84119 JXVZPostedReceiptsList
{
    Caption = 'Registered receipt', Comment = 'ESP=Recibos registrados';
    CardPageID = JXVZPostedReceipt;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = JXVZHistoryReceiptHeader;
    SourceTableView = sorting(JXVZReceiptNo) order(descending);
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
                field(JXVZReceiptNo; Rec.JXVZReceiptNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'No.', Comment = 'ESP=No.';

                    trigger OnDrillDown()
                    begin
                        JXVZHistoryReceiptHeader.SetRange(JXVZReceiptNo, Rec.JXVZReceiptNo);
                        PAGE.Run(PAGE::JXVZPostedReceipt, JXVZHistoryReceiptHeader);
                    end;
                }
                field(JXVZPostingDate; Rec.JXVZPostingDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Posting date', Comment = 'ESP=Fecha registro';
                }
                field(JXVZDocumentDate; Rec.JXVZDocumentDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Document date', Comment = 'ESP=Fecha documento';
                }
                field(JXVZCustomerNo; Rec.JXVZCustomerNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Customer no.', Comment = 'ESP=No. Cliente';
                }
                field(JXVZName; Rec.JXVZName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Name', Comment = 'ESP=Nombre';
                }
                field(JXVZAmount; Rec.JXVZAmount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Amount', Comment = 'ESP=Importe';
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
                ;
                ToolTip = 'Navigate', Comment = 'ESP=Navegar';
                ;
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    gNavigate.SetDoc(Rec.JXVZPostingDate, Rec.JXVZReceiptNo);
                    gNavigate.Run();
                end;
            }

            action(JXVZPrintReceipts)
            {
                ApplicationArea = All;
                Caption = 'Print Receipts', Comment = 'ESP=Imprimir Recibos';
                ToolTip = 'Print Receipts', Comment = 'ESP=Imprimir Recibos';
                Image = Print;

                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    PostedReceipts: Record JXVZHistoryReceiptHeader;
                    PostedReceiptsAux: Record JXVZHistoryReceiptHeader;
                    JXVZPaymentSetup: Record JXVZPaymentSetup;

                    //TempBlob: Record TempBlob temporary;
                    TempBlob: Codeunit "Temp Blob";
                    Out: OutStream;
                    RecRef: RecordRef;
                    //FileManagementCdu: Codeunit "File Management";
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

                    PostedReceipts.Reset();
                    CurrPage.SetSelectionFilter(PostedReceipts);
                    if (PostedReceipts.FindSet()) then
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
                            PostedReceiptsAux.Reset();
                            PostedReceiptsAux.SetRange(JXVZReceiptNo, PostedReceipts.JXVZReceiptNo);
                            if PostedReceiptsAux.FindFirst() then begin
                                RecRef.GetTable(PostedReceiptsAux);
                                REPORT.SAVEAS(JXVZPaymentSetup.JXVZHistReceiptReport, '', REPORTFORMAT::Pdf, Out, RecRef);

                                DataCompression.AddEntry(FileStream, PostedReceiptsAux.JXVZReceiptNo + '.pdf');
                            end;
                        until PostedReceipts.Next() = 0;

                    /* old
                    ZipBlob.CreateInStream(ZipStream);   
                    ZipName := StrSubstNo('%1.zip', 'Recibos');                 
                    DownloadFromStream(ZipStream, 'Dialog', 'Folder', '', ZipName);
                    */
                    //DataCompression.CloseZipArchive();
                    ZipName := StrSubstNo('%1.zip', 'Recibos');
                    DataCompression.SaveZipArchive(TempBlob);
                    TempBlob.CreateInStream(ZipStream);
                    DownloadFromStream(ZipStream, '', '', '', ZipName);

                    Message('Recibos guardados en PDF');
                end;
            }
        }
    }

    var
        gNavigate: Page Navigate;
        JXVZHistoryReceiptHeader: Record JXVZHistoryReceiptHeader;
}