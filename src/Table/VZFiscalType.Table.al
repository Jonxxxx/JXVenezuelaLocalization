table 84141 JXVZFiscalType
{
    DataClassification = OrganizationIdentifiableInformation;
    Caption = 'Fiscal Type';

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Code', Comment = 'ESP=Codigo';
        }

        field(2; Description; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Description', Comment = 'Descripcion';
        }

        field(3; JXVZFiscalType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Fiscal type',
                        Comment = 'ESP = Tipo fiscal';
            OptionMembers = ,ORD,FO,OC,RE,EX;
            OptionCaption = ',Ordinario,Formal,Ocacional,Responsable,Exterior',
                              Comment = 'ESP = ,Ordinario,Formal,Ocacional,Responsable,Exterior';
        }

        field(4; JXVZSVATCondition; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'VAT Condition', Comment = 'ESP="Condicion IVA"';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    procedure GetDescription(pCode: Code[20]): Text[100]
    var
        auxRec: Record JXVZFiscalType;
    begin
        auxRec.Reset();
        auxRec.SetRange("No.", pCode);
        if auxRec.FindFirst() then
            exit(auxRec.Description);

        exit('');
    end;
}