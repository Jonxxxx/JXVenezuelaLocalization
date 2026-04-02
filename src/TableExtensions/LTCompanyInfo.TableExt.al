tableextension 84110 JXVZCompanyInfo extends "Company Information"
{
    fields
    {
        field(84100; JXVZFiscalType; Code[20])
        {
            //RI = Responsable inscripto, CF = Consumidor final, MO = Monotributista
            //RX = Exento, EXT = Extranjero, NC = No categorizado
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Fiscal type', Comment = 'ESP = "Tipo fiscal"';
            TableRelation = JXVZFiscalType."No.";
        }

        field(84102; JXVZCompanyStartDate; Date)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Company start date',
                        Comment = 'ESP = Fecha comienzo empresa';
        }

        field(84103; JXVZLocalCurrencyDesc; Text[30])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Local currency description',
                        Comment = 'ESP = Descripcion divisa local';
        }
        field(84106; JXVZProvince; Code[20])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Province', Comment = 'ESP=Provincia';
            TableRelation = JXVZProvince;
        }

        field(84107; JXVZMaxDiferenceIVA; Decimal)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'VAT MAX Difference', Comment = 'ESP=Maxima diferencia IVA';
        }

        field(84108; JXVZCountry; Enum JXVZCountry)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Venezuela';

            trigger OnValidate()
            var
                JXConfirmLbl: Label 'Are you sure you want to change the Venezuela of the company', Comment = 'Está seguro que desea modificar la Venezuela de la empresa?';
                JXErrorLbl: Label 'This Venezuela is under development', Comment = 'Esta Venezuela está en desarrollo';
            begin
                if (Rec.JXVZCountry <> Rec.JXVZCountry::Empty) then
                    Rec.Validate(JXVZVenezuelaLocEnabled, true)
                else
                    Rec.Validate(JXVZVenezuelaLocEnabled, false);
            end;
        }

        field(84109; JXVZLicenseCode; Code[38])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'License Code';

            trigger OnValidate()
            var
                JXVZLogicalFactory: Codeunit JXVZLogicalFactory;
            begin
                if (JXVZLicenseCode <> '') and (rec.JXVZCountry <> JXVZCountry::Empty) then
                    JXVZLogicalFactory.LicenseCodeValidations(Rec.JXVZLicenseCode, rec.JXVZCountry);
            end;
        }
        field(84111; JXVZLocAdminUser; Guid)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Imp Loc. User';
            TableRelation = User;
        }

        field(84112; JXVZVenezuelaLocEnabled; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Venezuela Localization Enabled';

            trigger OnValidate()
            var
                JXVZVenApplicationAreaMgt: Codeunit JXVZVenApplicationAreaMgt;
                AppArea: Text;
            begin
                if JXVZVenezuelaLocEnabled then
                    AppArea := '#JXVZshowVen'
                else
                    AppArea := '#JXVZNotshowVen';

                JXVZVenApplicationAreaMgt.SetGlobalAppAreaVenezuela(AppArea);
                JXVZVenApplicationAreaMgt.ApplyVenezuelaApplicationArea();

                RestartSession();
            end;
        }
    }

    procedure JXIsVenezuela(): Boolean
    var
        companyInfo: Record "Company Information";
    begin
        companyInfo.FindFirst();
        if (companyInfo.JXVZCountry = JXVZCountry::Venezuela) then
            exit(true)
        else
            exit(false);
    end;

    local procedure RestartSession()
    var
        SessionSetting: SessionSettings;
    begin
        SessionSetting.Init();
        SessionSetting.RequestSessionUpdate(false);
    end;
}