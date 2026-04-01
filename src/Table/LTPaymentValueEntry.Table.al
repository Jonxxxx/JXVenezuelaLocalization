table 84115 JXVZPaymentValueEntry
{

    Caption = 'Payment value entry', Comment = 'ESP=Pagos entrada valor';
    DrillDownPageID = JXVZTreasuryValueEntries;
    LookupPageID = JXVZTreasuryValueEntries;

    fields
    {
        field(1; JXVZEntryNo; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Entry No.';
        }
        field(2; JXVZDocumentDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document Date';
        }
        field(3; JXVZDocumentType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document Type';
            OptionCaption = ',Receipt,Payment Order,Transfer,Deposit/Withdrawal,Realization';
            OptionMembers = ,Recibo,"Orden de Pago",Transferencia,"Ing/Egreso",Realizacion;
        }
        field(4; JXVZDocumentNo; Text[30])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Document No.';
        }
        field(5; JXVZDescription; Text[50])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Description';
        }
        field(6; JXVZAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Amount';
        }
        field(8; JXVZSeriesCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Series Code';
        }
        field(9; JXVZEntity; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Entity';
        }
        field(10; JXVZToDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'To Date';
        }
        field(11; JXVZUserId; Code[50])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'User Id';
        }
        field(13; JXVZPostingDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Posting Date';
        }
        field(15; JXVZCurrencyCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Currency Code';
        }
        field(16; JXVZValueNo; Code[30])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Value No.';
        }
        field(17; JXVZClearing; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Clearing';
        }
        field(18; JXVZComment; Text[100])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Comment';
        }
        field(19; JXVZGLAccount; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'GL Account';
            TableRelation = "G/L Account";
        }
        field(20; JXVZUseGlAccount; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Use GL Account';
        }
        field(21; JXVZOpen; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Open';
        }
        field(22; JXVZAppliedByEntryNo; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Applied by Entry No.';
        }
        field(23; JXVZCurrencyFactor; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
        }
        field(24; JXVZRemainingAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Remaining Amount';
        }
        field(25; JXVZAmountLCY; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Amount (LCY)';
        }
        field(26; JXVZRemainingAmountLCY; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Remaining Amount (LCY)';
        }
        field(27; JXVZAppliedAtDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Applied at Date';
        }
        field(28; JXVZInitialAmountLCY; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Initial Amount (LCY)';
        }
        field(29; JXVZClosedByAmount; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Closed by Amount';
        }
        field(30; JXVZClosedByAmountLCY; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Closed by Amount (LCY)';
        }
        field(31; JXVZValueDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Value Date';
        }
        field(32; JXVZAcreditationDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Acreditation Date';
        }
        field(40; JXVZEntrySourceType; Option)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Entry Source Type';
            OptionCaption = ' ,Customer,Vendor';
            OptionMembers = " ",Cliente,Proveedor;
        }
        field(41; JXVZEntrySourceCode; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Entry Source Code';
        }
        field(50; JXVZConciliationUserId; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Conciliation User Id';
        }
        field(51; JXVZConciliationDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Conciliation Date';
        }
        field(52; JXVZExtractNo; Text[30])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Extract No.';
        }
        field(53; JXVZDateFromExtract; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Date From-Extract';
        }
        field(54; JXVZToDateExtract; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'To Date-Extract';
        }
        field(55; JXVZExternalDocumentNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'External Document No.';
        }
        field(56; JXVZAccountNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Account No.';
        }
        field(57; JXVZWitholdingNo; Integer)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Witholding No.';
        }
        field(58; JXVZExcludeCashFlow; Boolean)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Exclude CashFlow';
            Description = 'LOC33';
        }
        field(59; JXVZInterfaceTrackingNo; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Interface Tracking No.';
            Description = 'LOC48';
        }
    }

    keys
    {
        key(Key1; JXVZEntryNo)
        {
            SumIndexFields = JXVZAmount, JXVZAmountLCY;
        }
        key(Key2; JXVZAcreditationDate)
        {
        }
        key(Key3; JXVZDocumentNo)
        {
        }
    }

    fieldgroups
    {
    }
}