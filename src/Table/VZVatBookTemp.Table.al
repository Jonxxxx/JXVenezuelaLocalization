table 84102 JXVZVatBookTemp
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; JXVZKey; Integer)
        {
            Caption = 'Comprobate Nro.';
        }
        field(2; JXVZPostingDate; Text[100])
        {
            Caption = 'Posting date';
        }
        field(3; JXVZVATRegistrationNo; Code[20])
        {
            Caption = 'RIF';
        }
        field(4; JXVZLegalName; text[100])
        {
            Caption = 'Razón social';
        }
        field(5; JXVZVatRetenNo; Code[35])
        {
            Caption = 'Nro Comprobante retención IVA';
        }
        field(6; JXVZEmissionDate; Date)
        {
            Caption = 'Fecha emisión comprobante retención IVA';
        }
        field(7; JXVZReceptionDate; Date)
        {
            Caption = 'Fecha recepción Comprobante Retención IVA';
        }
        field(8; JXVZImportTemplateNo; Code[35])
        {
            Caption = 'Nro. plantilla de importación';
        }
        field(9; JXVZImportFileNo; Code[35])
        {
            Caption = 'Nro de expediente de importación';
        }
        field(10; JXVZInvoiceNumber; Code[35])
        {
            Caption = 'Nro. factura';
        }
        field(11; JXVZControlNumber; Code[35])
        {
            Caption = 'Nro. Control';
        }
        field(12; JXVZDebitMemoNo; Code[35])
        {
            Caption = 'Nro. nota de debito';
        }
        field(13; JXVZCreditMemoNo; Code[35])
        {
            Caption = 'Nro. nota de crédito';
        }
        field(14; JXVZAffectedDocNo; Code[35])
        {
            Caption = 'Nro. documento afectado';
        }
        field(15; JXVZPaymentMethod; Text[100])
        {
            Caption = 'Forma de pago';
        }
        field(16; JXVZSupportNo; Code[50])
        {
            Caption = 'Nro. de soporte';
        }
        field(17; JXVZBank; Text[30])
        {
            Caption = 'Banco';
        }
        field(18; JXVZTotalAmountVAT; Decimal)
        {
            Caption = ' Total compras incluido IVA';
        }
        field(19; JXVZBaseAmount; Decimal)
        {
            Caption = 'Base impositiva';
        }
        field(20; "JXVZVAT%"; Decimal)
        {
            Caption = '% alícuota';
        }
        field(21; JXVZVatAmount; Decimal)
        {
            Caption = 'Impuesto IVA';
        }
        field(22; JXVZVATRetention; Decimal)
        {
            Caption = 'IVA Retenido al vendedor';
        }
        field(23; JXVZTransactionType; Text[50])
        {
            Caption = 'Tipo de Trans.';
        }
        field(24; JXVZAffectedInvoiceNo; Code[35])
        {
            Caption = 'Número de Factura Afectada';
        }
        field(25; JXVZExemptPurchases; Decimal)
        {
            Caption = 'Exentas';
        }
        field(26; JXVZPurchasesWithoutCredit; Decimal)
        {
            Caption = 'Compras sin derecho a Crédito Fiscal';
        }
        field(27; JXVZExoneratedPurchases; Decimal)
        {
            Caption = 'Compras Exoneradas o no Sujetas';
        }
        field(28; JXVZTaxableBase; Decimal)
        {
            Caption = 'Base Imponible';
        }
        field(29; JXVZTaxRate; Decimal)
        {
            Caption = '% Alic.';
        }
        field(30; JXVZTaxAmount; Decimal)
        {
            Caption = 'Impuesto IVA';
        }
        field(31; JXVZExemptOrExonerated; Decimal)
        {
            Caption = 'Exentas o Exoneradas';
        }
        field(32; JXVZExoneratedBase; Decimal)
        {
            Caption = 'Base Imponible Exonerada';
        }
        field(33; JXVZExoneratedRate; Decimal)
        {
            Caption = '% Alic. Exonerado';
        }
        field(34; JXVZExoneratedTax; Decimal)
        {
            Caption = 'Impuesto IVA Exonerado';
        }
        field(35; JXVZVATRetainedVendor; Decimal)
        {
            Caption = 'IVA Retenido (por el vendedor)';
        }
        field(36; JXVZVATRetainedThirdParty; Decimal)
        {
            Caption = 'IVA Retenido (a Terceros)';
        }
        field(37; JXVZExportTemplateNo; Code[35])
        {
            Caption = 'Núm Planilla de Exportación';
        }
        field(38; JXVZFOBValue; Decimal)
        {
            Caption = 'Valor FOB de la Mercancía';
        }
        field(39; JXVZSalesThirdParty; Decimal)
        {
            Caption = 'Ventas Tercero';
        }
        field(40; JXVZSalesExempt; Decimal)
        {
            Caption = 'Ventas Exentas';
        }
        field(41; JXVZSalesExonerated; Decimal)
        {
            Caption = 'Ventas Exoneradas o No Sujetas';
        }
        field(42; JXVZVATRetainedBuyer; Decimal)
        {
            Caption = 'IVA Retenido (por el comprador)';
        }
        field(43; JXVZVATPerceived; Decimal)
        {
            Caption = 'IVA Percibido';
        }
        field(44; JXVZPerceivedBaseAmount; Decimal)
        {
            Caption = 'Base Imponible';
        }
        field(45; JXVZPerceivedTaxRate; Decimal)
        {
            Caption = '% Alic.';
        }
        field(46; JXVZPerceivedTaxAmount; Decimal)
        {
            Caption = 'Impuesto IVA';
        }
        field(47; JXVZGeneralTaxRate; Decimal)
        {
            Caption = '% Alicuota General';
        }
        field(48; JXVZGeneralTaxAmount; Decimal)
        {
            Caption = 'Monto IVA General';
        }
        field(49; JXVZGeneralTaxBase; Decimal)
        {
            Caption = 'Base Imponible General';
        }
        field(50; "Partner Type"; Text[30])
        {
            Caption = 'Partner Type';
        }
        field(51; BaseComprasInternas; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(52; AlicuotaComprasInternas; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(53; ImpuestoIVAComprasInternas; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(54; BaseComprasImportaciones; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(55; AlicuotaComprasImportaciones; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(56; ImpIVAComprasImportaciones; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(57; BaseCompraInterGrav; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(58; AlicuotaCompraInterGrav; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(59; ImpIVACompraInterGrav; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60; Exento; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; JXVZKey)
        {
        }
    }
}