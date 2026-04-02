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

                field(JXVZDescription; Rec.JXVZDescription)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description', Comment = 'ESP = Descripcion';
                }
            }
        }
    }
}
