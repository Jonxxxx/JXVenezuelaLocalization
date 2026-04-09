enum 84103 JXVZWithholdBaseType
{
    Extensible = true;
    Caption = 'Withholding base type', Comment = 'ESP=Tipo base retención';

    value(0; NetAmount)
    {
        Caption = 'Base neta', Comment = 'ESP=Base neta';
    }
    value(1; TaxAmount)
    {
        Caption = 'Importe impuestos', Comment = 'ESP=Importe impuestos';
    }
    value(2; GrossAmount)
    {
        Caption = 'Importe total', Comment = 'ESP=Importe total';
    }
    value(3; GrossLessVATAndOtherTaxes)
    {
        Caption = 'Total menos IVA y otros impuestos', Comment = 'ESP=Total menos IVA y otros impuestos';
    }
    value(4; GrossLessVAT)
    {
        Caption = 'Total menos IVA', Comment = 'ESP=Total menos IVA';
    }
    value(5; GrossLessVATAndVATRelatedTaxes)
    {
        Caption = 'Total menos IVA e impuestos asociados al IVA', Comment = 'ESP=Total menos IVA e impuestos asociados al IVA';
    }
    value(6; VATOnly)
    {
        Caption = 'Solo IVA', Comment = 'ESP=Solo IVA';
    }
}