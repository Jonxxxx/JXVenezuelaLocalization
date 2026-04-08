pageextension 84104 JXVZSalesHeader extends "Sales Order"
{
    layout
    {
        addafter("Foreign Trade")
        {
            group(JXElectronicInvoice)
            {
                Visible = IsVenezuela;
                Caption = 'Venezuela',
                            Comment = 'ESP = Venezuela';

                field(JXVZInvoiceType; Rec.JXVZInvoiceType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Invoice type', Comment = 'ESP = Tipo de factura';
                }
                field(JXVZPointOfSale; Rec.JXVZPointOfSale)
                {
                    ApplicationArea = All;
                    ToolTip = 'Point of sale', Comment = 'ESP = Punto de venta';
                }
                field(JXVZFiscalType; Rec.JXVZFiscalType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Fiscal Type', Comment = 'ESP = Tipo fiscal';
                }

                field(JXVZFEDocumentType; Rec.JXVZFEDocumentType)
                {
                    Visible = IsVenezuela;
                    ApplicationArea = All;
                    ToolTip = 'document type', Comment = 'ESP = Tipo documento';
                }
                field(JXVZSTypeVoucher; Rec.JXVZSTypeVoucher)
                {
                    Visible = IsVenezuela;
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Voucher type for', Comment = 'ESP = Tipo de voucher para';
                }

                field("JXPosting No."; Rec."Posting No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Posting number', Comment = 'ESP = Numero de registro';
                }

                field(JXVZProvinceCode; Rec.JXVZProvinceCode)
                {
                    ApplicationArea = all;
                    ToolTip = 'Province', Comment = 'ESP=Provincia';
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
                field("JXPosting No. Series"; Rec."Posting No. Series")
                {
                    ApplicationArea = all;
                    ToolTip = 'Posting no. series', Comment = 'ESP=Numero serie registro';
                    Editable = ShowSeriesField;
                }
                field("JXShipping No. Series"; Rec."Shipping No. Series")
                {
                    ApplicationArea = all;
                    ToolTip = 'Shipping no. series', Comment = 'ESP=Numero serie remito';
                    Editable = false;
                }

                field(JXVZCtrlDocumentNo; Rec.JXVZCtrlDocumentNo)
                {
                    ApplicationArea = all;
                    ToolTip = 'Control Document No.';
                }

            }
        }
        modify("Sell-to Customer Name")
        {
            trigger OnAfterValidate()
            begin
                if ((IsVenezuela)) then begin
                    rec.JXCheckFESeriesSetup();
                    rec.Modify(false);
                end;
            end;
        }

        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            begin
                if ((IsVenezuela)) then begin
                    rec.JXCheckFESeriesSetup();
                    rec.Modify(false);

                end;
            end;
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
        VisiblePaymSameCurrency: Boolean;

}