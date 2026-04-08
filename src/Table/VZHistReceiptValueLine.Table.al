table 84109 JXVZHistReceiptValueLine
{
    //Caption = 'Registered receipt values', Comment = 'ESP=Recibos valores registrados';
    fields
    {
        field(1; "JXVZReceiptNo"; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Receipt no.', Comment = 'ESP=No. recibo';
            TableRelation = JXVZHistoryReceiptHeader.JXVZReceiptNo;
        }

        field(2; JXVZAccountNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Account no.', Comment = 'ESP = No. cuenta';
            TableRelation = "G/L Account"."No.";
        }
        field(3; JXVZDescription; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Description', Comment = 'ESP=Descripcion';
        }
        field(4; JXVZValueNo; Code[30])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Value no.', Comment = 'ESP=No. valor';
        }
        field(5; JXVZAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Amount', Comment = 'ESP=Importe';
        }
        field(6; JXVZCurrency; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Currency', Comment = 'ESP=Divisa';
            TableRelation = Currency;
        }
        field(7; "JXVZLineNo"; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Line no.', Comment = 'ESP=No. linea';
        }
        field(8; "JXVZSeriesCode"; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Series code', Comment = 'ESP=Codigo serie';
        }
        field(9; JXVZEntity; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Entity', Comment = 'ESP=Entidad';
        }
        field(10; "JXVZToDate"; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'To date', Comment = 'ESP=A fecha';
        }
        field(11; JXVZClearing; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Clearing', Comment = 'ESP=Clearing';
        }
        field(12; JXVZComment; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Comment', Comment = 'ESP=Comentario';
        }
        field(13; JXVZAccount; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Account', Comment = 'ESP=Cuenta';
        }
        field(15; "JXVZTotalAmount"; Decimal)
        {
            CalcFormula = Sum(JXVZHistReceiptValueLine.JXVZAmount WHERE(JXVZReceiptNo = FIELD("JXVZReceiptNo")));
            Caption = 'Total amount', Comment = 'ESP=Importe total';
            FieldClass = FlowField;
        }
        field(19; JXVZCurrencyCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Currency code', Comment = 'ESP=Codigo divisa';
            TableRelation = Currency;
        }
        field(20; JXVZCurrencyFactor; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Currency factor', Comment = 'ESP=Factor divisa';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(31; JXVZDocumentDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document date', Comment = 'ESP=Fecha documento';
        }
        field(32; JXVZAcreditationDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Acreditation date', Comment = 'ESP=Fecha acreditacion';
        }
    }

    keys
    {
        key(Key1; "JXVZReceiptNo", "JXVZLineNo")
        {
            SumIndexFields = JXVZAmount;
        }
    }
}

