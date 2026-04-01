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

        field(3; JXFiscalType; Option)
        {
            //RI = Responsable inscripto, CF = Consumidor final, MO = Monotributista
            //RX = Exento, EXT = Extranjero, NC = No categorizado
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Fiscal type',
                        Comment = 'ESP = Tipo fiscal';
            OptionMembers = ,RI,CF,MO,EX,EXT,NC,OTHR;
            OptionCaption = ',Responsible registered,Final consumer,Monotributista,Exempt,Foreign,Not categorized,Other',
                              Comment = 'ESP = ,Responsable inscripto,Consumidor final,Monotributista,Exento,Exterior,No categorizado,Otro';
        }

        field(4; JXFEVATCondition; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'VAT Condition FE', Comment = 'ESP="Condicion IVA FE"';
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