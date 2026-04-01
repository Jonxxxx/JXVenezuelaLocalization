table 84117 JXVZWithholdTaxCondition
{
    Caption = 'Tax conditions', Comment = 'ESP=Condicion de impuesto';
    LookupPageID = "JXVZWithholdTaxCondition";

    fields
    {
        field(1; "JXVZTaxCode"; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Tax code', Comment = 'ESP=Codigo impuesto';
            NotBlank = true;
            TableRelation = JXVZWithholdingTax;
        }
        field(2; "JXVZConditionCode"; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Condition Code', Comment = 'ESP=Codigo condicion';
            NotBlank = true;
        }
        field(3; JXVZDescription; Text[50])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Description', Comment = 'ESP=Descripcion';
        }
        field(4; "JXVZSicoreConditionCode"; Code[3])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'SICORE Condition Code', Comment = 'ESP=Codigo condicion SICORE';
        }
        field(5; "JXVZGgttWithholdingGroup"; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'GGTT Withholding group', Comment = 'ESP=Grupo retencion GGTT';
            Description = 'Grupo Retencion Igresos Brutos Bs As';

            trigger OnValidate()
            begin
                gTaxCondition.SetRange("JXVZGgttWithholdingGroup", "JXVZGgttWithholdingGroup");
                if gTaxCondition.FindFirst() then begin
                    Message(TextJXL0017Lbl, "JXVZGgttWithholdingGroup", gTaxCondition."JXVZConditionCode", gTaxCondition."JXVZTaxCode");
                    "JXVZGgttWithholdingGroup" := '';
                end;
            end;
        }
        field(6; "JXVZWithholdingCodeIVA"; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Withholding code IVA', Comment = 'ESP=Codigo retencion IVA';
        }
        field(7; "JXVZCodeAgipIibbCF"; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Code Agip IIBB CF', Comment = 'ESP=Codigo Agip IIBB CF';
        }
        field(8; "JXVZAliquotPerceptionCABA"; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Aliquot oerception CABA', Comment = 'ESP=Percepcion alicuota CABA';
        }
        field(9; "JXVZGroupARBA"; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Group ARBA', Comment = 'ESP=Grupo ARBA';
        }
        field(10; "JXVZAliquotCABA"; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Aliquot CABA', Comment = 'ESP=Alicuota CABA';
        }
        field(11; "JXVZGroupCABA"; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Group CABA', Comment = 'ESP=Grupo CABA';
        }
        field(12; "JXVZAliquotTucuman"; Code[10])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Aliquot Tucuman', Comment = 'ESP=Alicuota Tucuman';
        }
    }

    keys
    {
        key(Key1; "JXVZTaxCode", "JXVZConditionCode")
        {
        }
        key(Key2; "JXVZSICOREConditionCode")
        {
        }
    }

    fieldgroups
    {
    }

    var
        gTaxCondition: Record JXVZWithholdTaxCondition;
        TextJXL0017Lbl: Label 'El grupo %1 ya fué asignado a la condición %2  del impuesto %3.';
}