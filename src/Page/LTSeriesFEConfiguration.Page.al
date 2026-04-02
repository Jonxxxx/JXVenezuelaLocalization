page 84101 JXVZSeriesFEConfiguration
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = JXVZSeriesFEConfiguration;
    Caption = 'Venezuela series configuration',
                Comment = 'ESP = Configuracion series Venezuela';
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(JXVZType; Rec.JXVZType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Type', Comment = 'ESP = Tipo';
                }
                field(JXVZFiscalType; Rec.JXVZFiscalType)
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
                    ToolTip = 'document type', Comment = 'ESP = Tipo de documento';
                }
                field(JXVZSeriesNumber; Rec.JXVZSeriesNumber)
                {
                    ApplicationArea = All;
                    ToolTip = 'Series number', Comment = 'ESP = Numero de serie';
                }
                field(JXVZLetter; Rec.JXVZLetter)
                {
                    ApplicationArea = All;
                    ToolTip = 'Letter', Comment = 'ESP = Letra';
                }
                field(JXVZSReportDescription; Rec.JXVZSReportDescription)
                {
                    ApplicationArea = All;
                    ToolTip = 'Report description', Comment = 'ESP = Descripcion reporte';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}