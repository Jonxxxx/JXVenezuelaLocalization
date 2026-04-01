page 84100 JXVZPointOfSale
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = JXVZPointOfSale;
    Caption = 'Venezuela point of sale',
                Comment = 'ESP = Puntos de venta Venezuela';
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(JXVZPointOfSale; Rec.JXVZPointOfSale)
                {
                    ApplicationArea = All;
                    ToolTip = 'Point of sale', Comment = 'ESP = Punto de venta';
                }

                field(JXDescription; Rec.JXDescription)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description', Comment = 'ESP = Descripcion';
                }

                field(JXVZShipment; Rec.JXVZShipment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Is Shipment', Comment = 'ESP=Es remito';

                    trigger OnValidate()
                    begin
                        SetEnableRemito();
                    end;
                }
                field(JXVZCAI; Rec.JXVZCAI)
                {
                    ApplicationArea = All;
                    ToolTip = 'CAI', Comment = 'ESP=CAI';
                    Enabled = EnabledRemito;
                }
                field(JXVZStartDate; Rec.JXVZStartDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Start Date', Comment = 'ESP=Fecha Inicio';
                    Enabled = EnabledRemito;
                }
                field(JXVZDueDate; Rec.JXVZDueDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Due Date', Comment = 'ESP=Fecha vencimiento';
                    Enabled = EnabledRemito;
                }
                field(JXVZAddress; Rec.JXVZAddress)
                {
                    ApplicationArea = All;
                    ToolTip = 'Address', Comment = 'ESP=Direccion';
                    Enabled = EnabledRemito;
                }
                field(JXVZAddress2; Rec.JXVZAddress2)
                {
                    ApplicationArea = All;
                    ToolTip = 'Address 2', Comment = 'ESP=Direccion 2';
                    Enabled = EnabledRemito;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetEnableRemito();
    end;

    trigger OnAfterGetRecord()
    begin
        SetEnableRemito();
    end;

    local procedure SetEnableRemito()
    begin
        if Rec.JXVZShipment then
            EnabledRemito := true
        else
            EnabledRemito := false;
    end;

    var
        EnabledRemito: Boolean;
}
