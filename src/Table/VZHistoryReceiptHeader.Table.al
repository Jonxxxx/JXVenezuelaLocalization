table 84107 JXVZHistoryReceiptHeader
{
    Caption = 'Registered receipt', Comment = 'ESP=Recibos registrados';
    DrillDownPageID = JXVZPostedReceiptsList;
    LookupPageID = JXVZPostedReceiptsList;

    fields
    {
        field(1; JXVZReceiptNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'No.', Comment = 'ESP=No.';
        }
        field(2; JXVZPostingDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Posting date', Comment = 'ESP=Fecha registro';
        }
        field(3; JXVZDocumentDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document date', Comment = 'ESP=Fecha documento';
        }
        field(4; JXVZCustomerNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Customer no.', Comment = 'ESP=No. cliente';
            TableRelation = Customer."No.";
        }
        field(5; JXVZName; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Name', Comment = 'ESP=Nombre';
            Editable = true;
        }
        field(6; JXVZCuit; Text[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'NIF', Comment = 'ESP=CUIT';
        }
        field(7; JXVZAddress; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Address', Comment = 'ESP=Direccion';
        }

        field(8; JXVZStatus; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Status', Comment = 'Estado';
            OptionMembers = " ",Registered,Cancelled;
            OptionCaption = ' ,Registered,Cancelled', Comment = 'ESP= ,Registrado,Cancelado';
        }

        field(14; JXVZAmount; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP=Importe';
            FieldClass = FlowField;
            CalcFormula = sum(JXVZHistReceiptValueLine.JXVZAmount where(JXVZReceiptNo = field(JXVZReceiptNo)));
        }
        field(15; JXVZConcept; Text[50])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Concept', Comment = 'ESP=Concepto';
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
        field(61; JXVZUserId; Code[50])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'User id', Comment = 'ESP=Id usuario';
        }
    }

    keys
    {
        key(Key1; JXVZReceiptNo)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; JXVZReceiptNo, JXVZPostingDate)
        { }
    }
}