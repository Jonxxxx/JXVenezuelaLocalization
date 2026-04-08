enum 84101 JXVZDocTypeLVE
{
    Extensible = true;

    value(0; Empty)
    {
        Caption = ' ';
    }

    value(1; Reg)
    {
        Caption = '01 Reg'; //factura, nota de débito o nota de crédito sin referencia a factura afectada
    }
    value(2; Com)
    {
        Caption = '02 Com'; //nota de débito o nota de crédito con referencia a una factura
    }
    value(3; Anu)
    {
        Caption = '03 Anu'; //cancelación de factura / nota de débito / nota de crédito
    }
    value(4; Aju)
    {
        Caption = '04 Aju'; //egistro de documento con fecha distinta al período contable que se está reportando.
    }
}