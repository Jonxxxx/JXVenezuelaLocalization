table 84129 JXVZHistoryPaymOrder
{
    Caption = 'Registered payment order', comment = 'ESP=Orden de pago registrada';
    DrillDownPageID = JXVZHistoryPaymOrderList;
    LookupPageID = JXVZHistoryPaymOrderList;

    fields
    {
        field(1; JXVZNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'No.', Comment = 'ESP=No.';
        }
        field(2; JXVZDocumentDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document date', Comment = 'ESP=Fecha documento';
        }
        field(3; JXVZPostingDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Posting date', Comment = 'ESP=Fecha registro';
        }
        field(4; JXVZVendorNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Vendor No.', Comment = 'ESP=Codigo proveedor';
            TableRelation = Vendor;
        }
        field(5; JXVZName; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Name', Comment = 'ESP=Nombre';
            Editable = true;
        }
        field(6; JXVZCUIT; Text[20])
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
            Caption = 'Status', comment = 'ESP=Estado';
            OptionMembers = " ",Registered,Cancelled;
            OptionCaption = ' ,Registered,Cancelled', Comment = 'ESP= ,Registrado,Cancelado';
        }

        field(14; JXVZAmountLCY; Decimal)
        {
            CalcFormula = Sum(JXVZHistPaymValueLine.JXVZAmount WHERE(JXVZNo = FIELD(JXVZNo)));
            Caption = 'Amount', Comment = 'ESP=Importe';
            FieldClass = FlowField;
        }
        field(18; JXVZExternalDocumentNo; Text[50])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'External document no.', Comment = 'ESP=No. Documento externo';
        }
        field(19; JXVZConcept; Text[50])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Concept', Comment = 'ESP=Concepto';
        }
        field(20; JXVZUserID; Code[50])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'User Id', Comment = 'ESP=Id usuario';
            TableRelation = User;
        }
    }

    keys
    {
        key(Key1; JXVZNo)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; JXVZNo, JXVZDocumentDate, JXVZVendorNo)
        { }
    }
}

