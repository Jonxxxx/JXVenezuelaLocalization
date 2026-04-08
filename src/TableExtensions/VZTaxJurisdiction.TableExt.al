tableextension 84109 JXVZTaxJurisdiction extends "Tax Jurisdiction"
{
    fields
    {
        field(84100; JXVZTaxType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Tax type',
                        Comment = 'ESP = Tipo de impuesto';
            OptionMembers = ,VAT,Withold,VATPerception,Others;
            OptionCaption = ',VAT,Withholding,VAT perception,Others',
                              Comment = 'ESP = ,IVA,Retenciones,Percepcion IVA,Otros';
        }

        field(84101; JXVZVAType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'VAT type',
                        Comment = 'ESP = Tipo de IVA';

            OptionMembers = ,NoGravado,Exento,IVA0,IVA8,IVA16,ISLR,Municipal,RETIVA;
            OptionCaption = ',Not taxted,Exempt,VAT 0,VAT 8,VAT 16,ISLR,Municipal,RETIVA',
                              Comment = 'ESP = ,No gravado,Exento,IVA 0,IVA 8,IVA 16,ISLR,Municipal,RETIVA';
        }
    }
}