page 84118 JXVZPostedReceiptValues
{
    Caption = 'Registered receipt values', Comment = 'ESP=Recibos valores registrados';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = JXVZHistReceiptValueLine;
    //UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                ShowCaption = false;
                field(JXVZAccount; Rec.JXVZAccount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Account no.', Comment = 'ESP=No. cuenta';
                    Editable = false;
                }
                field(JXVZDescription; Rec.JXVZDescription)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description', Comment = 'ESP=Descripcion';
                    Editable = false;
                }
                field(JXVZAmount; Rec.JXVZAmount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Amount', Comment = 'ESP=Importe';
                    Editable = false;
                }
                field(JXVZCurrencyCode; Rec.JXVZCurrencyCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Currency code', Comment = 'ESP=Codigo divisa';
                    Editable = false;
                }
                field(JXVZCurrencyFactor; Rec.JXVZCurrencyFactor)
                {
                    ApplicationArea = All;
                    ToolTip = 'Currency factor', Comment = 'ESP=Factor divisa';
                    Editable = false;
                    Visible = false;
                }
                field(JXVZValueNo; Rec.JXVZValueNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Value no.', Comment = 'ESP=No. Valor';
                    Editable = false;
                }
                field(JXVZEntity; Rec.JXVZEntity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Entity', Comment = 'ESP=Entidad';
                    Editable = false;
                }
                field(JXVZToDate; Rec.JXVZToDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'To date', Comment = 'ESP=A fecha';
                    Editable = false;
                }
                field(JXVZDocumentDate; Rec.JXVZDocumentDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Document date', Comment = 'ESP=Fecha documento';
                    Editable = false;
                }
                field(JXVZAcreditationDate; Rec.JXVZAcreditationDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Acreditation date', Comment = 'ESP=Fecha acreditacion';
                    Editable = false;
                }
            }
        }
    }
}