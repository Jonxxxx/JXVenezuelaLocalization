pageextension 84106 JXVZSalesCreditMemo extends "Sales Credit Memo"
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

                field(JXVZPointOfSale; Rec.JXVZPointOfSale)
                {
                    ApplicationArea = All;
                    ToolTip = 'Point of sale', Comment = 'ESP = Punto de venta';
                }
                field(JXFiscalType; Rec.JXFiscalType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Fiscal type', Comment = 'ESP = Tipo fiscal';
                }

                field(JXVZFEDocumentType; Rec.JXVZFEDocumentType)
                {
                    Visible = IsVenezuela;
                    ApplicationArea = All;
                    ToolTip = 'FE document type', Comment = 'ESP = Tipo documento FE';
                }
                field(JXFETypeVoucher; Rec.JXFETypeVoucher)
                {
                    Visible = IsVenezuela;
                    ApplicationArea = All;
                    Editable = AllowEditVoucherType;
                    ToolTip = 'Voucher type for FE', Comment = 'ESP = Tipo de voucher para FE';
                }
                field(JXFEOption; Rec.JXFEOption)
                {
                    Visible = IsVenezuela;
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'FE option', Comment = 'ESP = Opcion FE';
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

        if ((IsVenezuela)) then begin
            AllowEditVoucherType := rec.JXFEAllowEditTypeVoucher();

        end;
    end;

    var
        CompanyInformation: Record "Company Information";
        GeneralLedgerSetup: Record "General Ledger Setup";


        IsVenezuela: Boolean;
        AllowEditVoucherType: Boolean;
        ShowSeriesField: Boolean;

}