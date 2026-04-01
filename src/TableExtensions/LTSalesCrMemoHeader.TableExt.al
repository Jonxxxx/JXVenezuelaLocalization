tableextension 84106 JXVZSalesCrMemoHeader extends "Sales Cr.Memo Header"
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

        field(84101; JXFETypeVoucher; Code[5])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'FE voucher type',
                        Comment = 'ESP = Tipo comprobante FE';
            TableRelation = JXVZFEDocumentType;
            ValidateTableRelation = true;
        }

        field(84102; JXFEOption; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'FE option',
                        Comment = 'ESP = Opcion FE';
            OptionMembers = No,FE,FEX,FCCRED;
        }

        field(84103; JXFEExportType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'FE export type',
                        Comment = 'ESP = Tipo exportacion FE';
            OptionMembers = ,Products,Services,Others;
            OptionCaption = ',Products,Services,Others',
                              Comment = 'ESP = ,Productos,Servicios,Otros';
        }

        field(84104; JXFEExportPermisson; Text[16])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'FE export permisson',
                        Comment = 'ESP = Permiso exportacion FE';
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
        }

        field(84107; JXInvoiceType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Invoice type',
                        Comment = 'ESP = Tipo factura';
            OptionMembers = ,Invoice,DebitMemo;
        }

        field(84109; JXFCREDRejectedPurchase; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'FCCred rejected purchase',
                        Comment = 'ESP = FCCred rechazada comprador';
        }

        field(84150; JXFECAE; Text[50])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'CAE',
                        Comment = 'ESP = CAE';
        }

        field(84151; JXFEDueDateCAE; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'CAE due date',
                        Comment = 'ESP = Fecha vencimiento CAE';
        }

        field(84111; JXVZProvinceCode; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Province code', Comment = 'ESP=Codigo provincia';
            TableRelation = JXVZProvince;
        }

        field(84112; JXVZDispatchImportation; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Dispatch Importation', Comment = 'ESP=Despacho de importacion';
        }
        field(84113; JXVZNotShowInBooks; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Not show in books', Comment = 'ESP=No mostrar en libro';
        }

        //QR
        field(84114; JXQRCode; Blob)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'QR Code',
                        Comment = 'ESP = Codigo QR';
        }
        //QR END

        field(84115; JXVZNegotiationType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Negotiation type', Comment = 'ESP=Tipo de negociacion';
            OptionMembers = " ",SCA,ADC;
            OptionCaption = ' ,SCA,ADC', Comment = ' ,Transferencia al sistema de circulacion abierta,Agente de deposito colectivo';
        }

        field(84116; JXVZAsociateDocument; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Associated document';
            TableRelation = "Sales Invoice Header" where("Bill-to Customer No." = field("Bill-to Customer No."));
            ValidateTableRelation = false;
        }

        field(84117; JXVZPeriodAsocFromDate; date)
        {
            DataClassification = CustomerContent;
            Caption = 'Period Asoc. from date', Comment = 'ESP="Periodo Asoc. fecha desde"';
        }

        field(84118; JXVZPeriodAsocToDate; date)
        {
            DataClassification = CustomerContent;
            Caption = 'Period Asoc. to date', Comment = 'ESP="Periodo Asoc. fecha hasta"';
        }
        //Save URL qr Code
        field(84120; JXVZFEUrlQR; Text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'Url QR Code';
        }
        //Save URL qr Code END
    }
}