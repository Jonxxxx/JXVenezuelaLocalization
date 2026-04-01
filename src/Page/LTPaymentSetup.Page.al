page 84116 JXVZPaymentSetup
{
    Caption = 'Payment Venezuela setup', Comment = 'ESP=Config. pagos Venezuela';
    PageType = Card;
    SourceTable = JXVZPaymentSetup;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Reports)
            {
                Caption = 'Reports', Comment = 'ESP=Reportes';
                field(JXVZHistReceiptReport; Rec.JXVZHistReceiptReport)
                {
                    ApplicationArea = All;
                    ToolTip = 'Register receipt report', Comment = 'ESP=Reporte recibo registrado';
                }
                field(JXVZHisPaymentReport; Rec.JXVZHisPaymentReport)
                {
                    ApplicationArea = All;
                    ToolTip = 'Register payment report', Comment = 'ESP=Reporte orden de pago registrado';
                }
                field(JXVZGrossIncomeReport; Rec.JXVZGrossIncomeReport)
                {
                    ApplicationArea = All;
                    ToolTip = 'Gross income report', Comment = 'ESP=Reporte ingresos brutos';
                }
                field(JXVZGainReport; Rec.JXVZGainReport)
                {
                    ApplicationArea = All;
                    ToolTip = 'Gain report', Comment = 'ESP=Reporte ganancias';
                }
                field(JXVZSussReport; Rec.JXVZSussReport)
                {
                    ApplicationArea = All;
                    ToolTip = 'Suss report', Comment = 'ESP=Reporte Suss';
                }

                field(JXVZAccountDescripOP; rec.JXVZAccountDescripOP)
                {
                    ApplicationArea = All;
                    ToolTip = 'Account description in line OP report';
                }
            }

            group(Mails)
            {
                Caption = 'Mails', Comment = 'ESP=Correos';

                field(JXVZBodyOPMail; Rec.JXVZBodyOPMail)
                {
                    ApplicationArea = All;
                    ToolTip = '%1 = Vendor name, %2 = Posting date, %3 = No. OP, %4 = Company name';
                }

                field(JXVZBodyRCMail; Rec.JXVZBodyRCMail)
                {
                    ApplicationArea = All;
                    ToolTip = '%1 = Customer name, %2 = Posting date, %3 = No. RC, %4 = Company name';
                }
            }

            group(Padron)
            {
                Caption = 'Padrones';

                field(JXVZBasepathPadron; Rec.JXVZBasepathPadron)
                {
                    ApplicationArea = All;
                    ToolTip = 'Base path of padrones';
                }

                field(JXVZPadronArbaName; Rec.JXVZPadronArbaName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of file with extension';
                }

                field(JXVZPadronCabaName; Rec.JXVZPadronCabaName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of file with extension';
                }
            }

            group(Others)
            {
                Caption = 'Others', Comment = 'ESP="Otros"';

                field(JXVZCompleteWithSpace; rec.JXVZCompleteWithSpace)
                {
                    ApplicationArea = All;
                    ToolTip = 'Complete with space export files';
                }

                field(JXVZShowTCPaymentReport; rec.JXVZShowTCPaymentReport)
                {
                    ApplicationArea = All;
                    ToolTip = 'Show TC in payment report';
                }

                field(JXVZDefaultAccountTPCheck; rec.JXVZDefaultAccountTPCheck)
                {
                    ApplicationArea = All;
                    ToolTip = 'Default account Third Party Check';
                }

                field(JXVZControlTPCheckPost; rec.JXVZControlTPCheckPost)
                {
                    ApplicationArea = All;
                    ToolTip = 'Control third party check to post';
                }

                field(JXVZCheckAmountVAT; rec.JXVZCheckAmountVAT)
                {
                    ApplicationArea = All;
                    ToolTip = 'Check Amount VAT Reports', Comment = 'ESP="Chequear importes libros IVA"';
                }

                field(JXVZDeleteWithholdToRevert; rec.JXVZDeleteWithholdToRevert)
                {
                    ApplicationArea = All;
                    ToolTip = 'Delete withholding when revert OP', Comment = 'ESP="Eliminar retenciones al revertir OP';
                }

                field(JXVZNoNegativeSignLEDC; rec.JXVZNoNegativeSignLEDC)
                {
                    ApplicationArea = All;
                    ToolTip = 'No Negative Sign LVE Purchase', Comment = 'ESP="Sin signo negativo LVE Compras';
                }

                field(JXVZControlSecuencePaymorderNo; Rec.JXVZControlSecuencePaymorderNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Control for payment order posted secuence';
                }
            }

            Group(Exports)
            {
                Caption = 'Exports files';

                group(SicoreWH)
                {
                    Caption = 'Sicore withhold.';

                    field(JXVZField1DefaultSRET; rec.JXVZField1DefaultSRET)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Field 1 default value';
                    }

                    field(JXVZCompleteWithSRETF3; rec.JXVZCompleteWithSRETF3)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Complete with Field 3';
                    }

                    field(JXVZField10BisDefValueSRET; rec.JXVZField10BisDefValueSRET)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Field 10 bis default value';
                    }

                    field(JXVZCompleteWithSRETF16; rec.JXVZCompleteWithSRETF16)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Complete with Field 16';
                    }

                    field(JXVZSicoreRetFilter; rec.JXVZSicoreRetFilter)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Sicore Withhold. filter';
                    }

                    field(JXVZSicoreCertLen; rec.JXVZSicoreCertLen)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Sicore Certificate length', Comment = 'ESP="Longitud Certificado Sicore';
                    }
                }
                group(CABAAGIPEI)
                {
                    Caption = 'AGIP Export Invoices';

                    field(JXVZCABAInvoiceFilter; rec.JXVZCABAInvoiceFilter)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Caba invoice filter';
                    }

                    field(JXVZDefValueF4CABAEI; rec.JXVZDefValueF4CABAEI)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Field 4 default value';
                    }

                    field(JXVZDefValueF10CABAEI; rec.JXVZDefValueF10CABAEI)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Field 10 default value';
                    }

                    field(JXVZIIBBCodeCABAEI; rec.JXVZIIBBCodeCABAEI)
                    {
                        ApplicationArea = All;
                        ToolTip = 'IIBB CABA Tax Code';
                    }

                    field(JXVZCABAInvoiceVTFilter; rec.JXVZCABAInvoiceVTFilter)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Caba invoice VAT filter';
                    }

                    field(JXVZARBAPercepFilter; rec.JXVZARBAPercepFilter)
                    {
                        ApplicationArea = All;
                        ToolTip = 'ARBA vat percep filter';
                    }

                    field(JXVZCABAWitholDot; rec.JXVZCABAWitholDot)
                    {
                        ApplicationArea = All;
                        ToolTip = 'CABA Withold. dot separator';
                    }
                }

                Group(Sifere)
                {
                    Caption = 'Sifere', Comment = 'ESP=Sifere';

                    field(JXVZSifereAmountLen; rec.JXVZSifereAmountLen)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Sifere amount length', Comment = 'ESP="Longitud importe Sifere';
                    }
                }

                group(ARBA)
                {
                    Caption = 'Arba';

                    field(JXVZVersion2ARBAReport; rec.JXVZVersion2ARBAReport)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Version 2 ARBA Reports';
                    }
                }
            }

            group(AautomaticExchRate)
            {
                Caption = 'Automatic exchange rate';
                Visible = false;
                Enabled = false;

                field(JXVZurlServiceAutExchRate; rec.JXVZurlServiceAutExchRate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Utl service automatic exchange rate USD';
                }

                field(JXVZCurrencyCodeUSDSales; rec.JXVZCurrencyCodeUSDSales)
                {
                    ApplicationArea = All;
                    ToolTip = 'Currency Code USD Sales';
                }

                field(JXVZCurrencyCodeUSDPurch; rec.JXVZCurrencyCodeUSDPurch)
                {
                    ApplicationArea = All;
                    ToolTip = 'Currency Code USD Purchase';
                }
            }

            group(Purchases)
            {
                Caption = 'Purchase', Comment = 'ESP="Compras"';

                field(JXVZPointSaleNumbers; rec.JXVZPointSaleNumbers)
                {
                    ApplicationArea = All;
                    ToolTip = 'Point of sale positions', Comment = 'ESP="Caracteres punto de venta';
                }
                field(JXVZDocumentNoNumbers; rec.JXVZDocumentNoNumbers)
                {
                    ApplicationArea = All;
                    ToolTip = 'Document No. positions', Comment = 'ESP="Caracteres numero de documento';
                }
                field(JXVZAllowDiffTaxAreaCode; rec.JXVZAllowDiffTaxAreaCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Allow differents tax area in invoice', Comment = 'ESP="Permitir distintos codigos de areas en facturas"';
                }
            }
        }
    }

    actions
    {
        Area(Processing)
        {
            action(DeleteTransactions)
            {
                ApplicationArea = All;
                Caption = 'Delete all transactions';
                ToolTip = 'Delete all transactions';

                trigger OnAction()
                var
                    JXVZDeleteTransactions: Report JXVZDeleteTransactions;
                begin
                    Clear(JXVZDeleteTransactions);
                    JXVZDeleteTransactions.Run();
                end;
            }

            action(InitSeriesNum)
            {
                ApplicationArea = All;
                Caption = 'Init series numbers';
                ToolTip = 'Init series numbers';

                trigger OnAction()
                var
                    NoSeries: Record "No. Series";
                    NoSeriesLines: Record "No. Series Line";
                begin
                    if (confirm('Esta seguro que desea continuar?', false)) then
                        if Confirm('Al realizar esta accion no se pueden recuperar los datos, desea continuar?', false) then begin
                            NoSeries.Reset();
                            if NoSeries.FindSet() then
                                repeat
                                    NoSeriesLines.Reset();
                                    NoSeriesLines.SetRange("Series Code", NoSeries.Code);
                                    if NoSeriesLines.FindFirst() then begin
                                        NoSeriesLines."Last Date Used" := 0D;
                                        NoSeriesLines."Last No. Used" := '';
                                        NoSeriesLines.Modify();
                                    end;
                                until NoSeries.Next() = 0;

                            Message('End process');
                        end;
                end;
            }
        }
    }
}