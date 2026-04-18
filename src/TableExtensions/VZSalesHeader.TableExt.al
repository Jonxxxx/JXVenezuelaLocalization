tableextension 84104 JXVZSalesHeader extends "Sales Header"
{
    fields
    {
        field(84100; JXVZPointOfSale; Code[5])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Point of sale',
                        Comment = 'ESP = Punto de venta';
            TableRelation = JXVZPointOfSale;
            ValidateTableRelation = true;

            trigger OnValidate()
            begin
                JXCheckFESeriesSetup();

                if (rec.JXVZPointOfSale <> xRec.JXVZPointOfSale) and (rec."Posting No." <> '') then
                    rec.Validate("Posting No.", '');
            end;
        }

        field(84101; JXVZSTypeVoucher; Code[5])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'voucher type',
                        Comment = 'ESP = Tipo comprobante';
            TableRelation = JXVZFEDocumentType;
            ValidateTableRelation = true;

            trigger OnValidate()
            begin
                "Posting No." := '';
                JXCheckFESeriesSetup();
            end;
        }

        field(84105; JXVZFEDocumentType; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document type',
                        Comment = 'ESP = Tipo documento';
            TableRelation = JXVZFECustDocumentType;
            ValidateTableRelation = true;
        }

        field(84106; JXVZFiscalType; Code[20])
        {
            //RI = Responsable inscripto, CF = Consumidor final, MO = Monotributista
            //RX = Exento, EXT = Extranjero, NC = No categorizado
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Fiscal type', Comment = 'ESP = "Tipo fiscal"';
            TableRelation = JXVZFiscalType."No.";

            trigger OnValidate()
            begin
                JXCheckFESeriesSetup();
            end;
        }

        field(84107; JXVZInvoiceType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Invoice type',
                        Comment = 'ESP = Tipo factura';
            OptionMembers = ,Invoice,DebitMemo;
            OptionCaption = ' ,Invoice,DebitMemo', Comment = 'ESP= ,Factura,Nota de debito';

            trigger OnValidate()
            begin
                JXCheckFESeriesSetup();
            end;
        }

        field(84111; JXVZProvinceCode; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Province', Comment = 'ESP=Provincia';
            TableRelation = JXVZProvince;
        }

        field(84112; JXVZCtrlDocumentNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Control Document No';
        }

        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                customer: Record Customer;
                CompanyInformation: Record "Company Information";
            begin
                if (CompanyInformation.JXIsVenezuela()) then begin
                    customer.Reset();
                    customer.SetRange("No.", "Sell-to Customer No.");
                    if customer.FindFirst() then begin
                        rec.JXVZFiscalType := customer.JXVZFiscalType;
                        rec.JXVZFEDocumentType := customer.JXVZFEDocumentType;
                        rec.JXVZProvinceCode := customer.JXVZProvinceCode;
                        if customer.JXVZPointofSale <> '' then begin
                            rec.Validate(JXVZPointOfSale, customer.JXVZPointofSale);
                            JXCheckFESeriesSetup();
                        end;
                    end;
                end;
            end;
        }

        modify("Sell-to Customer Name")
        {
            trigger OnAfterValidate()
            var
                customer: Record Customer;
                CompanyInformation: Record "Company Information";
            begin
                if (CompanyInformation.JXIsVenezuela()) then begin

                    customer.Reset();
                    customer.SetRange("No.", "Sell-to Customer No.");
                    if customer.FindFirst() then begin
                        rec.JXVZFiscalType := customer.JXVZFiscalType;
                        rec.JXVZFEDocumentType := customer.JXVZFEDocumentType;
                        rec.JXVZProvinceCode := customer.JXVZProvinceCode;
                        if customer.JXVZPointofSale <> '' then begin
                            rec.Validate(JXVZPointOfSale, customer.JXVZPointofSale);
                            JXCheckFESeriesSetup();
                        end;
                    end;
                end;
            end;
        }

    }

    trigger OnModify()
    var
        CompanyInformation: Record "Company Information";
    begin
        if (CompanyInformation.JXIsVenezuela()) then
            if ((JXVZInvoiceType <> xRec.JXVZInvoiceType) OR (JXVZFiscalType <> xRec.JXVZFiscalType) OR (JXVZPointOfSale <> xRec.JXVZPointOfSale) or (JXVZSTypeVoucher <> xRec.JXVZSTypeVoucher)) then
                JXCheckFESeriesSetup();
    end;

    procedure JXCheckFESeriesSetup()
    var
        JXVZSeriesFEConfiguration: Record JXVZSeriesFEConfiguration;
        CompanyInformation: Record "Company Information";
    begin
        if (CompanyInformation.JXIsVenezuela()) then begin
            JXVZSeriesFEConfiguration.Reset();
            JXVZSeriesFEConfiguration.SetRange(JXVZPointOfSale, JXVZPointOfSale);
            JXVZSeriesFEConfiguration.SetRange(JXVZFiscalType, JXVZFiscalType);
            case Rec."Document Type" of
                "Document Type"::Invoice:
                    if JXVZInvoiceType = JXVZInvoiceType::Invoice then
                        JXVZSeriesFEConfiguration.SetRange(JXVZType, JXVZSeriesFEConfiguration.JXVZType::Invoice)
                    else
                        if JXVZInvoiceType = JXVZInvoiceType::DebitMemo then
                            JXVZSeriesFEConfiguration.SetRange(JXVZType, JXVZSeriesFEConfiguration.JXVZType::DebitMemo);
                "Document Type"::"Credit Memo":
                    JXVZSeriesFEConfiguration.SetRange(JXVZType, JXVZSeriesFEConfiguration.JXVZType::CreditMemo);
                "Document Type"::Order:
                    JXVZSeriesFEConfiguration.SetRange(JXVZType, JXVZSeriesFEConfiguration.JXVZType::Invoice);
            end;

            if JXVZSeriesFEConfiguration.FindFirst() then begin
                rec."Posting No. Series" := JXVZSeriesFEConfiguration.JXVZSeriesNumber;
                rec.JXVZSTypeVoucher := JXVZSeriesFEConfiguration.JXVZFEDocumentType;
            end else begin
                //rec."Posting No. Series" := '';
                rec.JXVZSTypeVoucher := '';
            end;

            if rec."Document Type" = rec."Document Type"::Order then begin
                JXVZSeriesFEConfiguration.Reset();
                JXVZSeriesFEConfiguration.SetRange(JXVZPointOfSale, JXVZPointOfSale);
                JXVZSeriesFEConfiguration.SetRange(JXVZFiscalType, JXVZFiscalType);
                JXVZSeriesFEConfiguration.SetRange(JXVZType, JXVZSeriesFEConfiguration.JXVZType::Shipment);
                if JXVZSeriesFEConfiguration.FindFirst() then
                    rec."Shipping No. Series" := JXVZSeriesFEConfiguration.JXVZSeriesNumber;
            end;
        end;
    end;
}