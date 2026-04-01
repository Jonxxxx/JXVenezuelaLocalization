tableextension 84109 JXVZTaxJurisdiction extends "Tax Jurisdiction"
{
    fields
    {
        field(84100; JXTaxType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Tax type',
                        Comment = 'ESP = Tipo de impuesto';
            OptionMembers = ,VAT,GrossIncome,VATPerception,Others;
            OptionCaption = ',VAT,Gross income,VAT perception,Others',
                              Comment = 'ESP = ,IVA,Ingresos brutos,Percepcion IVA,Otros';
        }

        field(84101; JXVAType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'VAT type',
                        Comment = 'ESP = Tipo de IVA';

            OptionMembers = ,NoGravado,Exento,IVA0,IVA105,IVA21,IVA27,ARBA,CABA,MISIONES;
            OptionCaption = ',Not taxted,Exempt,VAT 0,VAT 10.5,VAT 21,VAT 27,ARBA,CABA,MISIONES',
                              Comment = 'ESP = ,No gravado,Exento,IVA 0,IVA 10.5,IVA 21,IVA 27,ARBA,CABA,MISIONES';
        }
    }
}