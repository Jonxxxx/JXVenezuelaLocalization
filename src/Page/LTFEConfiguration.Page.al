page 84102 JXVZFEConfiguration
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = JXVZFEConfiguration;
    Caption = 'Venezuela FE configuration',
                Comment = 'ESP = Configuracion FE Venezuela';
    layout
    {
        area(Content)
        {
            group(General)
            {
                field(JXFEEnabled; Rec.JXFEEnabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'FE Enabled', Comment = 'ESP = FE habilitada';
                }
                field(JXFEVersion; rec.JXFEVersion)
                {
                    ApplicationArea = All;
                    ToolTip = 'FE Version';

                    trigger OnValidate()
                    begin
                        VisibleFE1 := false;
                        VisibleFE2 := false;

                        if (rec.JXFEVersion = JXVZFEVersion::V1) or (rec.JXFEVersion = JXVZFEVersion::V11) then
                            VisibleFE1 := true;

                        if (rec.JXFEVersion = JXVZFEVersion::V2) or (rec.JXFEVersion = JXVZFEVersion::V21) then
                            VisibleFE2 := true;
                    end;
                }
            }

            group(Urls)
            {
                Caption = 'URL';
                field(JXWSTAUrl; Rec.JXWSTAUrl)
                {
                    ApplicationArea = All;
                    ToolTip = 'Url ticket access', Comment = 'ESP = Url Ticket de acceso';
                }
                field(JXWSFEUrl; Rec.JXWSFEUrl)
                {
                    ApplicationArea = All;
                    ToolTip = 'Url FE', Comment = 'ESP = Url FE';
                }
                field(JXFEXUrl; Rec.JXFEXUrl)
                {
                    ApplicationArea = All;
                    ToolTip = 'Url FEX', Comment = 'ESP = Url FEX';
                }
                field(JXFECREDUrl; Rec.JXFECREDUrl)
                {
                    ApplicationArea = All;
                    ToolTip = 'Url FCCred', Comment = 'ESP = Url FCCred';
                }
            }

            group(FEID)
            {
                Caption = 'FE ID';
                field(JXFEId; Rec.JXFEId)
                {
                    ApplicationArea = All;
                    ToolTip = 'FE Id', Comment = 'ESP = Id FE';
                }
                field(JXFEXId; Rec.JXFEXId)
                {
                    ApplicationArea = All;
                    ToolTip = 'FEX Id', Comment = 'ESP = Id FEX';
                }
                field(JXFECREDId; Rec.JXFECREDId)
                {
                    ApplicationArea = All;
                    ToolTip = 'FCCred Id', Comment = 'ESP = Id FCCred';
                }
            }

            group(FE1)
            {
                Caption = 'FE - Version 1.0';
                Visible = VisibleFE1;

                field(JXCertificatePath;
                Rec.JXCertificatePath)
                {
                    ApplicationArea = All;
                    ToolTip = 'File certificate path', Comment = 'ESP = Ruta archivo certificado';
                }
                field(JXCertificatePassword; Rec.JXCertificatePassword)
                {
                    ApplicationArea = All;
                    ToolTip = 'Certificate password', Comment = 'ESP = Contraseña certificado';
                }
                field(JXLogBasePath; Rec.JXLogBasePath)
                {
                    ApplicationArea = All;
                    ToolTip = 'Log base path', Comment = 'ESP = Ruta base log';
                }
                field(JXCUIT; Rec.JXCUIT)
                {
                    ApplicationArea = All;
                    ToolTip = 'CUIT', Comment = 'ESP = CUIT';
                }
                field(JXFELocalCurrencyCode; Rec.JXFELocalCurrencyCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'FE local currency code', Comment = 'ESP = Codigo divisa local FE';
                }
                field(JXwebservice; Rec.JXwebservice)
                {
                    ApplicationArea = All;
                    ToolTip = 'JX web service', Comment = 'ESP = Web service JX';
                }
            }

            group(FE2)
            {
                Caption = 'FE - Version 2.0';
                Visible = VisibleFE2;

                field(JXFEContentCertificate; Rec.JXFEContentCertificate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Content certificate PFX', Comment = 'ESP = Contenido certificado PFX';
                }
                field(JXCertificatePasswordV2; Rec.JXCertificatePassword)
                {
                    ApplicationArea = All;
                    ToolTip = 'Certificate password', Comment = 'ESP = Contraseña certificado';
                }
                field(JXCUITV2; Rec.JXCUIT)
                {
                    ApplicationArea = All;
                    ToolTip = 'CUIT', Comment = 'ESP = CUIT';
                }
                field(JXFELocalCurrencyCodeV2; Rec.JXFELocalCurrencyCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'FE local currency code', Comment = 'ESP = Codigo divisa local FE';
                }
                field(JXwebserviceV2; Rec.JXwebservice)
                {
                    ApplicationArea = All;
                    ToolTip = 'JX web service', Comment = 'ESP = Web service JX';
                }
            }

            group(Report)
            {
                Caption = 'Report';
                //QR
                field(JXUrlQRCode; Rec.JXUrlQRCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Url QR Code', Comment = 'ESP = Url codigo QR';
                }
                field(JXVZPrintQRCode; Rec.JXVZPrintQRCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Print QR Code', Comment = 'ESP = Imprimir codigo QR';
                }
                //Save URL qr Code
                field(JXFESaveUrlQr; Rec.JXFESaveUrlQr)
                {
                    ApplicationArea = All;
                    ToolTip = 'Save Url QR';
                }
                //Save URL qr Code END
                //QR END
                field(JXFETransFiscalLeyend; Rec.JXFETransFiscalLeyend)
                {
                    ApplicationArea = All;
                    ToolTip = 'Show text transparencia fiscal B';
                }
            }

            group(Others)
            {
                Caption = 'Others';
                field(JXVZShowRequest; Rec.JXVZShowRequest)
                {
                    ApplicationArea = All;
                    ToolTip = 'Show request', Comment = 'ESP=Muestra request';
                }

                field(JXFEShowAllError; Rec.JXFEShowAllError)
                {
                    ApplicationArea = All;
                    ToolTip = 'Show all error';
                }

                field(JXVZEncryptRequest; Rec.JXVZEncryptRequest)
                {
                    ApplicationArea = All;
                    ToolTip = 'Encryipt request', Comment = 'ESP=Encripta request';
                }



                field(JXVZFERoundFE; Rec.JXVZFERoundFE)
                {
                    ApplicationArea = All;
                    ToolTip = 'Round decimals places';
                }

                field(JXVZFEErrorPostNoFE; Rec.JXVZFEErrorPostNoFE)
                {
                    ApplicationArea = All;
                    ToolTip = 'Error invoices NO FE';
                }

                field(JXVZupdateSeriesCode; Rec.JXVZupdateSeriesCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Update series code';
                }

                field(JXLCheckAFIPNumber; Rec.JXLCheckAFIPNumber)
                {
                    ApplicationArea = All;
                    ToolTip = 'Check AFIP numner when post';
                }

                field(JXVZLimitAmountNoCheckB; rec.JXVZLimitAmountNoCheckB)
                {
                    ApplicationArea = All;
                    ToolTip = 'Limit Amount to check amount FB';
                }

                field(JXFEVisibleSavePdfReport; rec.JXFEVisibleSavePdfReport)
                {
                    ApplicationArea = All;
                    ToolTip = 'Show save pdf report';
                }
            }

            group(JXVZDefaultValues)
            {
                Caption = 'Default values', Comment = 'Valores por defecto';

                field(JXVZDefValueInvoiceType; rec.JXVZDefValueInvoiceType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Def. Invoice type',
                        Comment = 'ESP = Tipo factura defecto';
                }

                field(JXVZDefExportType; rec.JXVZDefExportType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Def. FE export type',
                        Comment = 'ESP = Tipo exportacion FE Defecto';
                }

                field(JXVZEnabledCUITValidation; rec.JXVZEnabledCUITValidation)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enabled CUIT validation';
                }

                field(JXFEManualVoucherType; rec.JXFEManualVoucherType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Allow edit voucher type', Comment = 'ESP="Tipo de comprobante editable"';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        VisibleFE1 := false;
        VisibleFE2 := false;

        if (rec.JXFEVersion = JXVZFEVersion::V1) or (rec.JXFEVersion = JXVZFEVersion::V11) then
            VisibleFE1 := true;

        if (rec.JXFEVersion = JXVZFEVersion::V2) or (rec.JXFEVersion = JXVZFEVersion::V21) then
            VisibleFE2 := true;
    end;

    trigger OnAfterGetRecord()
    begin
        if (rec.JXFEVersion = JXVZFEVersion::V1) or (rec.JXFEVersion = JXVZFEVersion::V11) then
            VisibleFE1 := true;

        if (rec.JXFEVersion = JXVZFEVersion::V2) or (rec.JXFEVersion = JXVZFEVersion::V21) then
            VisibleFE2 := true;
    end;

    var
        VisibleFE1: Boolean;
        VisibleFE2: Boolean;
}