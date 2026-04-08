tableextension 84105 JXVZSalesInvHeader extends "Sales Invoice Header"
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
        }

        field(84101; JXVZSTypeVoucher; Code[5])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'voucher type',
                        Comment = 'ESP = Tipo comprobante';
            TableRelation = JXVZFEDocumentType;
            ValidateTableRelation = true;
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
        }

        field(84107; JXVZInvoiceType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Invoice type',
                        Comment = 'ESP = Tipo factura';
            OptionMembers = ,Invoice,DebitMemo;
            OptionCaption = ' ,Invoice,DebitMemo', Comment = 'ESP= ,Factura,Nota de debito';
        }

        field(84111; JXVZProvinceCode; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Province code', Comment = 'ESP=Codigo provincia';
            TableRelation = JXVZProvince;
        }

        field(84112; JXVZCtrlDocumentNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Control Document No';
        }
    }

    trigger OnBeforeDelete()
    var
        CompanyInformation: Record "Company Information";
    begin
        if (CompanyInformation.JXIsVenezuela()) then begin
            rec."No. Printed" := 1;
            rec.Modify(false);
        end;
    end;
}