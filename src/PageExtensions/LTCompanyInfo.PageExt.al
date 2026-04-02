pageextension 84112 JXVZCompanyInfo extends "Company Information"
{
    layout
    {
        addafter(Shipping)
        {
            group(JXElectronicInvoice)
            {
                Caption = 'Venezuela',
                            Comment = 'ESP = Venezuela';

                field(JXVZCountry; rec.JXVZCountry)
                {
                    ApplicationArea = All;
                    ToolTip = 'Venezuela', Comment = 'ESP = Venezuela';
                }

                field(JXVZFiscalType; Rec.JXVZFiscalType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Fiscal type', Comment = 'ESP = Tipo fiscal';
                }
                field(JXVZCompanyStartDate; Rec.JXVZCompanyStartDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Company start date', Comment = 'ESP = fecha de inicio de la compañia';
                }
                field(JXVZLocalCurrencyDesc; Rec.JXVZLocalCurrencyDesc)
                {
                    ApplicationArea = All;
                    ToolTip = 'Local currency code', Comment = 'ESP = Codigo de divisa local';
                }
                field(JXVZProvince; Rec.JXVZProvince)
                {
                    ApplicationArea = all;
                    ToolTip = 'Province', Comment = 'ESP = Provincia';
                }
                field(JXVZMaxDiferenceIVA; Rec.JXVZMaxDiferenceIVA)
                {
                    ApplicationArea = all;
                    ToolTip = 'VAT max difference', Comment = 'ESP = Diferencia maxima IVA';
                }

                field(JXVZLocAdminUser; Rec.JXVZLocAdminUser)
                {
                    ApplicationArea = All;
                    ToolTip = 'Imp. Loc. User';
                    Visible = false;
                }

                field(JXVZVenezuelaLocEnabled; Rec.JXVZVenezuelaLocEnabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'Venezuela Loc Enabled';
                    Visible = true;
                }

                group(JXVenezuelaInfo)
                {
                    Caption = 'Venezuela info';

                    field(JXPublisherLbl; JXPublisherLbl)
                    {
                        ApplicationArea = All;
                        Caption = 'Publisher';
                        ToolTip = 'Publisher';
                        Editable = false;
                    }

                    field(JXNameLbl; JXNameLbl)
                    {
                        ApplicationArea = All;
                        Caption = 'Name';
                        ToolTip = 'Name';
                        Editable = false;
                    }

                    field(JXVersionLbl; JXVersionLbl)
                    {
                        ApplicationArea = All;
                        Caption = 'Version';
                        ToolTip = 'Version';
                        Editable = false;
                    }

                    field(JXVZLicenseCode; Rec.JXVZLicenseCode)
                    {
                        ApplicationArea = All;
                        Caption = 'License Code';
                        ToolTip = 'License Code';
                        ShowMandatory = true;
                    }
                }
            }
        }
    }

    var
        JXPublisherLbl: Label 'Jonxsoft Uruguay S.A.S.';
        JXNameLbl: Label 'Jonxsoft Venezuela Localization';
        JXVersionLbl: Label '2.1.2.1238';
}