page 84134 JXVZPostedPOValues
{
    Caption = 'Posted payment order values', Comment = 'ESP=Valores de orden de pago registrada';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = JXVZHistPaymValueLine;
    //UsageCategory = None;

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
                field(JXVZAccountNo; Rec.JXVZAccountNo)
                {
                    Tooltip = 'Account No.', Comment = 'ESP=No. Cuenta';
                    ApplicationArea = All;
                }
                field(JXVZDescription; Rec.JXVZDescription)
                {
                    Tooltip = 'Description', Comment = 'ESP=Descripcion';
                    ApplicationArea = All;
                }
                field(JXVZAmount; Rec.JXVZAmount)
                {
                    Tooltip = 'Amount', Comment = 'ESP=Importe';
                    ApplicationArea = All;
                }
                field(JXVZValueNo; Rec.JXVZValueNo)
                {
                    Tooltip = 'Value no.', Comment = 'ESP=No. Valor';
                    ApplicationArea = All;
                }
                field(JXVZSeriesCode; Rec.JXVZSeriesCode)
                {
                    Tooltip = 'Series code', Comment = 'ESP=Codigo serie';
                    ApplicationArea = All;
                }
                field(JXVZEntity; Rec.JXVZEntity)
                {
                    Tooltip = 'Entity', Comment = 'ESP=Entidad';
                    ApplicationArea = All;
                }
                field(JXVZToDate; Rec.JXVZToDate)
                {
                    Tooltip = 'To Date', Comment = 'ESP=A fecha';
                    ApplicationArea = All;
                }
                field(JXVZClearing; Rec.JXVZClearing)
                {
                    Tooltip = 'Clearing', Comment = 'ESP=Clearing';
                    ApplicationArea = All;
                }
                field(JXVZDocumentDate; Rec.JXVZDocumentDate)
                {
                    Tooltip = 'Document date', Comment = 'ESP=Fecha documento';
                    ApplicationArea = All;
                }
                field(JXVZAcreditationDate; Rec.JXVZAcreditationDate)
                {
                    Tooltip = 'Acreditation date', Comment = 'ESP=Fecha acreditacion';
                    ApplicationArea = All;
                }
                field(JXVZComment; Rec.JXVZComment)
                {
                    Tooltip = 'Comment', Comment = 'ESP=Comentario';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Línea")
            {
                Caption = 'Line', Comment = 'ESP=Linea';
                action("Seguimiento Valor")
                {
                    ApplicationArea = All;
                    Caption = 'Value tracking', Comment = 'ESP=Valor de seguimiento';
                    ToolTip = 'Value tracking', Comment = 'ESP=Valor de seguimiento';
                    Image = Track;
                    ShortCutKey = 'Shift+Ctrl+N';

                    trigger OnAction()
                    begin
                        /*CurrPage.formValores.PAGE.*/
                        ShowValor();

                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        ComentarioVisible := true;
        ClearingVisible := true;
        "A FechaVisible" := true;
        "Nº ValorVisible" := true;
        EntidadVisible := true;
        "Cód. SerieVisible" := true;
    end;

    trigger OnOpenPage()
    begin
        "Cód. SerieVisible" := false;

        EntidadVisible := false;
        "Nº ValorVisible" := false;
        "A FechaVisible" := false;
        ClearingVisible := false;
        ComentarioVisible := false;
    end;

    var
        [InDataSet]
        "Cód. SerieVisible": Boolean;
        [InDataSet]
        EntidadVisible: Boolean;
        [InDataSet]
        "Nº ValorVisible": Boolean;
        [InDataSet]
        "A FechaVisible": Boolean;
        [InDataSet]
        ClearingVisible: Boolean;
        [InDataSet]
        ComentarioVisible: Boolean;

    procedure ShowValor()
    var
        MovValores: Record JXVZPaymentValueEntry;
        Text53800Lbl: Label 'El Valor de esta línea no contiene "Cód. Serie"';
    begin
        if Rec.JXVZSeriesCode <> '' then begin
            MovValores.Reset();
            MovValores.SetCurrentKey(JXVZEntryNo);
            MovValores.SetRange(MovValores.JXVZSeriesCode, Rec.JXVZSeriesCode);
            PAGE.Run(0, MovValores);
        end
        else
            Message(Text53800Lbl);
    end;
}

