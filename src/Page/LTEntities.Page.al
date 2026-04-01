page 84113 JXVZEntities
{
    Caption = 'Entities', Comment = 'ESP=Entidades';
    PageType = List;
    SourceTable = JXVZEntity;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(JXVZEntity; Rec.JXVZEntity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Entity', Comment = 'ESP=Entidad';
                }
            }
        }
    }

    actions
    {
    }
}