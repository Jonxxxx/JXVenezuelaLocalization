table 84114 JXVZPaymentSetup
{
    Caption = 'Payment Venezuela setup', Comment = 'ESP=Config. pagos Venezuela';

    fields
    {
        field(1; JXVZIdCode; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'ID', Comment = 'ESP=Id';
        }

        field(2; JXVZHistReceiptReport; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Register receipt report', Comment = 'ESP=Reporte recibo registrado';
        }
        field(3; JXVZHisPaymentReport; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Register payment report', Comment = 'ESP=Reporte orden de pago registrado';
        }

        field(4; JXVZWitholdReport; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Withholding report', Comment = 'ESP=Reporte Retenciones';
        }

        field(5; JXVZGainReport; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Gain report', Comment = 'ESP=Reporte ganancias';
        }

        field(6; JXVZSussReport; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Suss report', Comment = 'ESP=Reporte Suss';
        }

        field(7; JXVZAccountDescripOP; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Account description in line OP report';
        }

        field(8; JXVZDeleteWithholdToRevert; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Delete withholding when revert OP', Comment = 'ESP="Eliminar retenciones al revertir OP';
        }

        field(9; JXVZControlSecuencePaymorderNo; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Control Payment Order Sequence';
        }
    }

    keys
    {
        key(Key1; JXVZIdCode)
        {
        }
    }
}