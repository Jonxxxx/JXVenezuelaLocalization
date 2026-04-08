page 84109 JXVZTaxDetails
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Tax Detail";
    Caption = 'Tax detail', Comment = 'ESP = Detalle impuesto';

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Tax Jurisdiction Code"; Rec."Tax Jurisdiction Code")
                {
                    applicationArea = All;
                    ToolTip = 'Tax jurisdiction code', Comment = 'ESP = Codigo jurisdiccion';
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    applicationArea = All;
                    ToolTip = 'Tax group code', Comment = 'ESP = Codigo grupo impuesto';
                }
                field("Tax Type"; Rec."Tax Type")
                {
                    applicationArea = All;
                    ToolTip = 'Tax type', Comment = 'ESP = Tipo impuesto';
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    applicationArea = All;
                    ToolTip = 'Effecive date', Comment = 'ESP = Fecha efectiva';
                }
                field("Tax Below Maximum"; Rec."Tax Below Maximum")
                {
                    applicationArea = All;
                    ToolTip = 'Tax below maximum', Comment = 'ESP = Impuesto por debajo del máximo';
                }
                field("Maximum Amount/Qty."; Rec."Maximum Amount/Qty.")
                {
                    applicationArea = All;
                    ToolTip = 'Maximum amount/qty.', Comment = 'ESP = Impote/cantidad maxima';
                }
                field("Tax Above Maximum"; Rec."Tax Above Maximum")
                {
                    applicationArea = All;
                    ToolTip = 'Tax abobe maximum', Comment = 'ESP = Impuesto por arriba del máximo';
                }
            }
        }
    }
}