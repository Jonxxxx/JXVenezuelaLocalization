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

        field(84101; JXFETypeVoucher; Code[5])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'FE voucher type',
                        Comment = 'ESP = Tipo comprobante FE';
            TableRelation = JXVZFEDocumentType;
            ValidateTableRelation = true;

            trigger OnValidate()
            begin
                "Posting No." := '';
                JXCheckFESeriesSetup();
            end;
        }

        field(84102; JXFEOption; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'FE option',
                        Comment = 'ESP = Opcion FE';
            OptionMembers = No,FE,FEX,FCCRED;
        }

        field(84105; JXVZFEDocumentType; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'FE Document type',
                        Comment = 'ESP = Tipo documento FE';
            TableRelation = JXVZFECustDocumentType;
            ValidateTableRelation = true;
        }

        field(84106; JXFiscalType; Code[20])
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

        field(84107; JXInvoiceType; Option)
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

        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                customer: Record Customer;
                CompanyInformation: Record "Company Information";
            begin
                if (CompanyInformation.JXIsVenezuela()) then begin
                    JXVZSetDefaultValues();

                    customer.Reset();
                    customer.SetRange("No.", "Sell-to Customer No.");
                    if customer.FindFirst() then begin
                        rec.JXFiscalType := customer.JXFiscalType;
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
                    JXVZSetDefaultValues();

                    customer.Reset();
                    customer.SetRange("No.", "Sell-to Customer No.");
                    if customer.FindFirst() then begin
                        rec.JXFiscalType := customer.JXFiscalType;
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
        modify("Currency Code")
        {
            trigger OnAfterValidate()
            var
                customer: Record Customer;
                CompanyInformation: Record "Company Information";
            begin
                if (CompanyInformation.JXIsVenezuela()) then begin
                    JXVZSetDefaultValues();
                end;
            end;
        }
    }

    trigger OnModify()
    var
        CompanyInformation: Record "Company Information";
    begin
        if (CompanyInformation.JXIsVenezuela()) then
            if ((JXInvoiceType <> xRec.JXInvoiceType) OR (JXFiscalType <> xRec.JXFiscalType) OR (JXVZPointOfSale <> xRec.JXVZPointOfSale) or (JXFETypeVoucher <> xRec.JXFETypeVoucher)) then
                JXCheckFESeriesSetup();
    end;

    procedure JXCheckFESeriesSetup()
    var
        JXVZSeriesFEConfiguration: Record JXVZSeriesFEConfiguration;
        JXVZFEConfiguration: Record JXVZFEConfiguration;
        CompanyInformation: Record "Company Information";
    begin
        if (CompanyInformation.JXIsVenezuela()) then begin
            JXVZFEConfiguration.Reset();
            if JXVZFEConfiguration.FindFirst() then;

            JXVZSeriesFEConfiguration.Reset();
            JXVZSeriesFEConfiguration.SetRange(JXVZPointOfSale, JXVZPointOfSale);
            JXVZSeriesFEConfiguration.SetRange(JXFiscalType, JXFiscalType);
            case Rec."Document Type" of
                "Document Type"::Invoice:
                    if JXInvoiceType = JXInvoiceType::Invoice then
                        JXVZSeriesFEConfiguration.SetRange(JXType, JXVZSeriesFEConfiguration.JXType::Invoice)
                    else
                        if JXInvoiceType = JXInvoiceType::DebitMemo then
                            JXVZSeriesFEConfiguration.SetRange(JXType, JXVZSeriesFEConfiguration.JXType::DebitMemo);
                "Document Type"::"Credit Memo":
                    JXVZSeriesFEConfiguration.SetRange(JXType, JXVZSeriesFEConfiguration.JXType::CreditMemo);
                "Document Type"::Order:
                    JXVZSeriesFEConfiguration.SetRange(JXType, JXVZSeriesFEConfiguration.JXType::Invoice);
            end;
            if JXVZFEConfiguration.JXFEManualVoucherType then
                if rec.JXFETypeVoucher <> '' then
                    JXVZSeriesFEConfiguration.SetRange(JXVZFEDocumentType, rec.JXFETypeVoucher);
            if JXVZSeriesFEConfiguration.FindFirst() then begin
                rec."Posting No. Series" := JXVZSeriesFEConfiguration.JXSeriesNumber;
                rec.JXFETypeVoucher := JXVZSeriesFEConfiguration.JXVZFEDocumentType;
                rec.JXFEOption := JXVZSeriesFEConfiguration.JXFEType;
            end else begin
                rec."Posting No. Series" := '';
                rec.JXFETypeVoucher := '';
                rec.JXFEOption := JXFEOption::No;
            end;

            if rec."Document Type" = rec."Document Type"::Order then begin
                JXVZSeriesFEConfiguration.Reset();
                JXVZSeriesFEConfiguration.SetRange(JXVZPointOfSale, JXVZPointOfSale);
                JXVZSeriesFEConfiguration.SetRange(JXFiscalType, JXFiscalType);
                JXVZSeriesFEConfiguration.SetRange(JXType, JXVZSeriesFEConfiguration.JXType::Shipment);
                if JXVZSeriesFEConfiguration.FindFirst() then
                    rec."Shipping No. Series" := JXVZSeriesFEConfiguration.JXSeriesNumber;
            end;
        end;
    end;

    local procedure JXVZSetDefaultValues()
    var
        JXVZFEConfiguration: Record JXVZFEConfiguration;
    begin
        JXVZFEConfiguration.Reset();
        if JXVZFEConfiguration.FindFirst() then begin
            if ((rec."Document Type" = rec."Document Type"::Order) or (rec."Document Type" = rec."Document Type"::Invoice)) then
                rec.validate(JXInvoiceType, JXVZFEConfiguration.JXVZDefValueInvoiceType);
        end;
    end;

    procedure JXFEAllowEditTypeVoucher(): Boolean
    var
        JXVZFEConfiguration: Record JXVZFEConfiguration;
    begin
        JXVZFEConfiguration.Reset();
        if JXVZFEConfiguration.FindFirst() then;

        exit(JXVZFEConfiguration.JXFEManualVoucherType);
    end;
}