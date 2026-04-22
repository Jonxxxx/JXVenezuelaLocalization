pageextension 84117 JXVZPurchaseOrder extends "Purchase Order"
{
    layout
    {

        addafter("Foreign Trade")
        {
            group(JXVZVenezuela)
            {
                Visible = IsVenezuela;
                Caption = 'Venezuela', Comment = 'ESP=Venezuela';

                field(JXVZInvoiceType; Rec.JXVZInvoiceType)
                {
                    ApplicationArea = all;
                    ToolTip = 'Invoice type', Comment = 'ESP=Tipo factura';
                }
                field(JXVZFiscalType; Rec.JXVZFiscalType)
                {
                    ApplicationArea = all;
                    ToolTip = 'Fiscal type', Comment = 'ESP=Tipo fiscal';
                }
                field(JXVZProvince; Rec.JXVZProvince)
                {
                    ApplicationArea = all;
                    ToolTip = 'Province code', Comment = 'ESP=Codigo provincia';
                }
                field(JXVZWithholdingCode; Rec.JXVZWithholdingCode)
                {
                    ApplicationArea = all;
                    ToolTip = 'Withholding code', Comment = 'ESP=Codigo retencion';
                }
                field("JXTax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Tax area code', Comment = 'ESP=Codigo area impuesto';
                }
                field("JXTax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = all;
                    ToolTip = 'Tax liable', Comment = 'ESP=Sujeto a impuestos';
                }

                field("JX Posting No."; Rec."Posting No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Posting No.', Comment = 'ESP="No. Registro"';
                    Editable = ShowSeriesField;
                    Enabled = ShowSeriesField;
                    Visible = ShowSeriesField;
                }
                field("JX Posting No. Series"; Rec."Posting No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Posting No. Series', Comment = 'ESP="No. Serie Registro"';
                    Editable = ShowSeriesField;
                    Enabled = ShowSeriesField;
                    Visible = ShowSeriesField;
                }
                field(JXVZCtrlDocumentNo; Rec.JXVZCtrlDocumentNo)
                {
                    ApplicationArea = all;
                    Visible = IsVenezuela;
                    ToolTip = 'Control Document No.';
                }

                field(JXVZAutoInvoice; Rec.JXVZAutoInvoice)
                {
                    ApplicationArea = All;
                    Visible = IsVenezuela;
                    ToolTip = 'Auto-Invoice';
                }
            }
        }
    }

    actions
    {
        addafter(VendorStatistics)
        {
            action(JXVZCalcWithholds)
            {
                Caption = 'Calcular retenciones';
                ToolTip = 'Calcula las retenciones del documento de compra actual.';
                ApplicationArea = All;
                Image = CalculateHierarchy;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = false;
                PromotedOnly = true;

                trigger OnAction()
                var
                    JXVZWithholdings: Codeunit JXVZWithholdings;
                begin
                    Clear(JXVZWithholdings);
                    JXVZWithholdings.CalculateFromPurchaseDocument(Rec);
                    CurrPage.Update(false);
                    Message('Las retenciones fueron calculadas correctamente.');
                end;
            }

            action(JXVZViewWithholds)
            {
                Caption = 'Ver retenciones';
                ToolTip = 'Ver las retenciones del documento de compra actual.';
                ApplicationArea = All;
                Image = ViewDocumentLine;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = false;
                PromotedOnly = true;

                trigger OnAction()
                var
                    JXVZWithholdings: Codeunit JXVZWithholdings;
                begin
                    Clear(JXVZWithholdings);
                    JXVZWithholdings.ShowCalculatedWithholdings(Rec);
                end;
            }

            action(JXVZDeleteWithholdings)
            {
                Caption = 'Eliminar retenciones';
                ToolTip = 'Elimina las retenciones calculadas para el documento actual.';
                ApplicationArea = All;
                Image = DeleteQtyToHandle;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = false;
                PromotedOnly = true;

                trigger OnAction()
                var
                    JXVZWithholdings: Codeunit JXVZWithholdings;
                begin
                    if not Confirm('¿Desea eliminar las retenciones calculadas del documento?', false) then
                        exit;

                    Clear(JXVZWithholdings);
                    JXVZWithholdings.DeleteCalculatedWithholdings(Rec);
                    CurrPage.Update(false);
                    Message('Las retenciones calculadas fueron eliminadas correctamente.');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IsVenezuela := CompanyInformation.JXIsVenezuela();
    end;

    var
        CompanyInformation: Record "Company Information";
        GeneralLedgerSetup: Record "General Ledger Setup";


        IsVenezuela: Boolean;
        ShowSeriesField: Boolean;

}