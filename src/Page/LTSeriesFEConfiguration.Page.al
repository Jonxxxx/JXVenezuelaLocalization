page 84101 JXVZSeriesFEConfiguration
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = JXVZSeriesFEConfiguration;
    Caption = 'Venezuela FE series configuration',
                Comment = 'ESP = Configuracion series Venezuela FE';
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(JXType; Rec.JXType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Type', Comment = 'ESP = Tipo';
                }
                field(JXFiscalType; Rec.JXFiscalType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Fiscal type', Comment = 'ESP = Tipo fiscal';
                }
                field(JXVZPointOfSale; Rec.JXVZPointOfSale)
                {
                    ApplicationArea = All;
                    ToolTip = 'Point of sale', Comment = 'ESP = Punto de venta';
                }
                field(JXVZFEDocumentType; Rec.JXVZFEDocumentType)
                {
                    ApplicationArea = All;
                    ToolTip = 'FE document type', Comment = 'ESP = Tipo de documento FE';
                }
                field(JXSeriesNumber; Rec.JXSeriesNumber)
                {
                    ApplicationArea = All;
                    ToolTip = 'Series number', Comment = 'ESP = Numero de serie';
                }
                field(JXFEType; Rec.JXFEType)
                {
                    ApplicationArea = All;
                    ToolTip = 'FE type', Comment = 'ESP = Tipo FE';
                }
                field(JXLetter; Rec.JXLetter)
                {
                    ApplicationArea = All;
                    ToolTip = 'Letter', Comment = 'ESP = Letra';
                }
                field(JXFEReportDescription; Rec.JXFEReportDescription)
                {
                    ApplicationArea = All;
                    ToolTip = 'Report description', Comment = 'ESP = Descripcion reporte';
                }
                field(JXVZShipmentPointOfSale; Rec.JXVZShipmentPointOfSale)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shipment Point of sale', Comment = 'ESP = Remito Punto de venta';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}