page 84108 JXVZTaxAreas
{
    PageType = List;
    Caption = 'Tax Area List', Comment = 'ESP = Lista de area de impuestos';
    SourceTable = "Tax Area";
    UsageCategory = Administration;
    CardPageId = "Tax Area";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Code', Comment = 'ESP = Codigo';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description', Comment = 'ESP = Descripcion';
                }

                field(JXVZSpedificArea; Rec.JXVZSpedificArea)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specific area', Comment = 'Area especifico';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(JXConvertToSpecificArea)
            {
                ApplicationArea = All;
                Caption = 'Convert to specific area', Comment = 'ESP=Convertir en area especifico';
                ToolTip = 'Convert to specific area', Comment = 'ESP=Convertir en area especifico';
                Image = Process;
                Visible = IsVenezuela;

                trigger OnAction()
                var
                    LogicalFactory: Codeunit JXVZLogicalFactory;
                    ConfirmLbl: Label 'Are you sure you want to continue?', Comment = 'ESP= Está seguro que desea continuar?';
                begin
                    if (Confirm(ConfirmLbl, false)) then
                        LogicalFactory.ConvertToSpecificAreas();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(rec.JXVZSpedificArea, false);

        IsVenezuela := CompanyInformation.JXIsVenezuela();


    end;

    var
        CompanyInformation: Record "Company Information";


        IsVenezuela: Boolean;
}