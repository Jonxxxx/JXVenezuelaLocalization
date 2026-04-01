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

                field(JXFiscalType; Rec.JXFiscalType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Fiscal type', Comment = 'ESP = Tipo fiscal';
                }
                field(JXCompanyStartDate; Rec.JXCompanyStartDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Company start date', Comment = 'ESP = fecha de inicio de la compañia';
                }
                field(JXLocalCurrencyDesc; Rec.JXLocalCurrencyDesc)
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

                field(JXLocAdminUser; Rec.JXLocAdminUser)
                {
                    ApplicationArea = All;
                    ToolTip = 'Imp. Loc. User';
                    Visible = false;
                }

                field(JXVZLatamLocEnabled; Rec.JXVZLatamLocEnabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'LATAM Loc Enabled';
                    Visible = false;
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
        JXPublisherLbl: Label 'Jonxsoft Venezuela S.R.L.';
        JXNameLbl: Label 'Jonxsoft LATAM Venezuela';
        JXVersionLbl: Label '2.7.13.6768';
}