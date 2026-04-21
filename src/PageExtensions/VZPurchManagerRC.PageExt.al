pageextension 84159 JXVZPurchManagerRC extends "Purchasing Manager Role Center"
{
    actions
    {
        addlast(Sections)
        {
            group(JXVenezuela)
            {
                Caption = 'Venezuela', Comment = 'ESP="Venezuela"';

                group(JXVZTaxesConfigurations)
                {
                    Caption = 'Perceptions setup', Comment = 'ESP="Conf. percepcion"';
                    Visible = false;

                    action(JXVZTaxJurisdictions)
                    {
                        Caption = 'Tax jurisdictions', Comment = 'ESP="Jurisdicciones de impuestos"';
                        RunObject = page JXVZTaxJurisdictions;
                        ApplicationArea = JXVZshowVen;
                        Image = SalesTax;
                        ToolTip = 'Tax jurisdictions setup', Comment = 'ESP="Configuracion de jurisdicciones de impuestos"';
                    }

                    action(JXVZTaxGroups)
                    {
                        Caption = 'Tax groups', Comment = 'ESP="Grupos de impuestos"';
                        RunObject = page "Tax Groups";
                        ApplicationArea = JXVZshowVen;
                        Image = TaxSetup;
                        ToolTip = 'Tax groups setup', Comment = 'ESP="Configuracion de grupos de impuestos"';
                    }

                    action(JXVZTaxAreas)
                    {
                        Caption = 'Tax area', Comment = 'ESP="Areas de impuestos"';
                        RunObject = page JXVZTaxAreas;
                        ApplicationArea = JXVZshowVen;
                        Image = CollectedTax;
                        ToolTip = 'Tax area setup', Comment = 'ESP="Configuracion de areas de impuestos"';
                    }

                    action(JXVZTaxDetails)
                    {
                        Caption = 'Tax details', Comment = 'ESP="Detalles de impuestos"';
                        RunObject = page JXVZTaxDetails;
                        ApplicationArea = JXVZshowVen;
                        Image = TaxDetail;
                        ToolTip = 'Tax details setup', Comment = 'ESP="Configuracion de detalles de impuestos"';
                    }

                }

                group(JXVZWithholdingConfiguratons)
                {
                    Caption = 'Withholdings setup', Comment = 'ESP="Conf. retenciones"';

                    action(JXVZWithholdTax)
                    {
                        Caption = 'Withholding taxes', Comment = 'ESP="Impuesto retenciones"';
                        RunObject = page JXVZWithholdingTax;
                        ApplicationArea = JXVZshowVen;
                        Image = Setup;
                        ToolTip = 'Withholding taxes setup', Comment = 'ESP="Configuracion de impuesto retenciones"';
                    }

                    action(JXVZWithholdTaxCond)
                    {
                        Caption = 'Withholding Tax conditions', Comment = 'ESP="Condicion de impuesto retenciones"';
                        RunObject = page JXVZWithholdTaxCondition;
                        ApplicationArea = JXVZshowVen;
                        Image = TaxSetup;
                        ToolTip = 'Withholding Tax conditions setup', Comment = 'ESP="Configuracion de condicion de impuesto retenciones"';
                    }

                    action(JXVZWithholdTaxDetail)
                    {
                        Caption = 'Witholding detail', Comment = 'ESP="Detalle retencion"';
                        RunObject = page JXVZWithholdDetailEntry;
                        ApplicationArea = JXVZshowVen;
                        Image = TaxDetail;
                        ToolTip = 'Witholding detail setup', Comment = 'ESP="Configuracion detalle retencion"';
                    }

                    action(JXVZWithholdTaxScale)
                    {
                        Caption = 'Witholding scale', Comment = 'ESP="Escala retencion"';
                        RunObject = page JXVZWithholdScale;
                        ApplicationArea = JXVZshowVen;
                        Image = GeneralPostingSetup;
                        ToolTip = 'Witholding scale setup', Comment = 'ESP="Configuracion escala retencion"';
                    }

                    action(JXVZWithholdAreaList)
                    {
                        Caption = 'Withholding area list', Comment = 'ESP="Lista de area de retencion"';
                        RunObject = page JXVZWithholdAreaList;
                        ApplicationArea = JXVZshowVen;
                        Image = SetupList;
                        ToolTip = 'Withholding area list', Comment = 'ESP="Lista de area de retencion"';
                    }
                }

                group(JXVZTreasury)
                {
                    Caption = 'Treasury', Comment = 'ESP=Tesoreria"';

                    action(JXVZPaymentJournal)
                    {
                        Caption = 'Payment Journal (Vendors)', Comment = 'ESP="Diario de pago (Proveedores)"';
                        RunObject = page "Payment Journal";
                        ApplicationArea = JXVZshowVen;
                        Image = PaymentJournal;
                        ToolTip = 'Payment Journal (Vendors)', Comment = 'ESP="Diario de pago (Proveedores)"';
                    }

                    action(JXVZReceiptJournal)
                    {
                        Caption = 'Payment Journal (Customers)', Comment = 'ESP="Diario de pago (Clientes)"';
                        RunObject = page "Cash Receipt Journal";
                        ApplicationArea = JXVZshowVen;
                        Image = CashReceiptJournal;
                        ToolTip = 'Payment Journal (Customers)', Comment = 'ESP="Diario de pago (Clientes)"';
                    }

                    action(JXVZPostedPaymOrders)
                    {
                        Caption = 'History payment orders', Comment = 'ESP="Historico ordenes de pago"';
                        RunObject = page JXVZHistoryPaymOrderList;
                        ApplicationArea = JXVZshowVen;
                        Image = PaymentHistory;
                        ToolTip = 'History payment orders', Comment = 'ESP="Historico ordenes de pago"';
                    }

                    action(JXVZPostedReceipts)
                    {
                        Caption = 'History receipts', Comment = 'ESP="Historico de recibos"';
                        RunObject = page JXVZPostedReceiptsList;
                        ApplicationArea = JXVZshowVen;
                        Image = PostedReceipts;
                        ToolTip = 'History receipts', Comment = 'ESP="Historico de recibos"';
                    }

                    action(JXVZTreasurySetup)
                    {
                        Caption = 'Treasury setup', Comment = 'ESP="Conf. tesoreria"';
                        RunObject = page JXVZPaymentSetup;
                        ApplicationArea = JXVZshowVen;
                        Image = PostedReceipts;
                        ToolTip = 'Treasury setup', Comment = 'ESP="Configuracion tesoreria"';
                    }
                }

                group(JXVZlectronicInvoice)//Venezuela
                {
                    Caption = 'Sales Doc. Setup', Comment = 'ESP="Config. doc. ventas"';

                    group(JXLEFEParams)
                    {
                        Caption = 'Sales Invoice', Comment = 'ESP="Factura ventas"';
                        action(JXVZPointOfSale)
                        {
                            Caption = 'Point of sale', Comment = 'ESP="Puntos de venta"';
                            RunObject = page JXVZPointOfSale;
                            ApplicationArea = JXVZshowVen;
                            Image = Setup;
                            ToolTip = 'Point of sale setup', Comment = 'ESP="Configuracion de puntos de venta"';
                        }

                        action(JXVZFEDocumentTypes)
                        {
                            Caption = 'Document types', Comment = 'ESP="Tipos de documento"';
                            RunObject = page JXVZFEDocumentTypes;
                            ApplicationArea = JXVZshowVen;
                            Image = Setup;
                            ToolTip = 'Document types setup', Comment = 'ESP="Configuracion tipos de documento"';
                        }

                        action(JXVZFECustDocumentTypes)
                        {
                            Caption = 'Customer document types', Comment = 'ESP="Tipos de documento clientes"';
                            RunObject = page JXVZFECustDocumentTypes;
                            ApplicationArea = JXVZshowVen;
                            Image = Setup;
                            ToolTip = 'Customer document types setup', Comment = 'ESP="Configuracion tipos de documento clientes"';
                        }

                        action(JXVZSeriesFEConfiguration)
                        {
                            Caption = 'Document series', Comment = 'ESP="Series de documentos"';
                            RunObject = page JXVZSeriesFEConfiguration;
                            ApplicationArea = JXVZshowVen;
                            Image = Setup;
                            ToolTip = 'Document series setup', Comment = 'ESP="Configuracion series de documentos"';
                        }
                        action(JXVZFiscalTypes)
                        {
                            Caption = 'Fiscal type', Comment = 'ESP="Tipo fiscal"';
                            RunObject = page JXVZFiscalTypes;
                            ApplicationArea = JXVZshowVen;
                            Image = TaxDetail;
                            ToolTip = 'Fiscal types setup', Comment = 'ESP="Configuracion de tipos fiscales"';
                        }
                        action(JXVZProvinces)
                        {
                            Caption = 'Province', Comment = 'ESP="Provincia"';
                            RunObject = page JXVZProvinces;
                            ApplicationArea = JXVZshowVen;
                            Image = TaxDetail;
                            ToolTip = 'Province setup', Comment = 'ESP="Configuracion de Provincias"';
                        }
                    }
                }


            }
        }
    }
}