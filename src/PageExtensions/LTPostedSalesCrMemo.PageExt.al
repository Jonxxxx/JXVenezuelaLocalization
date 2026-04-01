pageextension 84108 JXVZPostedSalesCrMemo extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("External Document No.")
        {
            field(JXVZNotShowInBooks; Rec.JXVZNotShowInBooks)
            {
                Visible = IsVenezuela;
                ApplicationArea = All;
                ToolTip = 'Not show in books', Comment = 'ESP=No mostrar en libro';
                Editable = false;
            }
        }
        addafter("Shipping and Billing")
        {
            group(JXElectronicInvoice)
            {
                Visible = IsVenezuela;
                Caption = 'Venezuela',
                            Comment = 'ESP = Venezuela';
                Editable = false;

                field(JXFEOption; Rec.JXFEOption)
                {
                    Visible = IsVenezuela;
                    ApplicationArea = All;
                    ToolTip = 'FE option', Comment = 'ESP = Opcion FE';
                }
                field(JXVZPointOfSale; Rec.JXVZPointOfSale)
                {
                    ApplicationArea = All;
                    ToolTip = 'Point of sale', Comment = 'ESP = Punto de venta';
                }
                field(JXVZFEDocumentType; Rec.JXVZFEDocumentType)
                {
                    Visible = IsVenezuela;
                    ApplicationArea = All;
                    ToolTip = 'FE document type', Comment = 'ESP = Tipo documento FE';
                }
                field("JXTax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Tax area code', Comment = 'ESP=Codigo area impuesto';
                }
                field(JXFEExportType; Rec.JXFEExportType)
                {
                    Visible = IsVenezuela;
                    ApplicationArea = All;
                    ToolTip = 'Export type', Comment = 'ESP = Tipo exportacion';
                }
                field(JXFEExportPermisson; Rec.JXFEExportPermisson)
                {
                    Visible = IsVenezuela;
                    ApplicationArea = All;
                    ToolTip = 'FE Export permisson', Comment = 'ESP = Permiso exportacion FE';
                }
                field(JXFETypeVoucher; Rec.JXFETypeVoucher)
                {
                    Visible = IsVenezuela;
                    ApplicationArea = All;
                    ToolTip = 'Voucher type for FE', Comment = 'ESP = Tipo de voucher para FE';
                }
                field(JXFECAE; Rec.JXFECAE)
                {
                    Visible = IsVenezuela;
                    ApplicationArea = All;
                    ToolTip = 'CAE', Comment = 'ESP = CAE';
                }
                field(JXFEDueDateCAE; Rec.JXFEDueDateCAE)
                {
                    Visible = IsVenezuela;
                    ApplicationArea = All;
                    ToolTip = 'CAE due date', Comment = 'ESP = Fecha vencimiento CAE';
                }
                field(JXVZDispatchImportation; Rec.JXVZDispatchImportation)
                {
                    Visible = IsVenezuela;
                    ApplicationArea = all;
                    ToolTip = 'Dispatch Importation', Comment = 'ESP=Despacho de importacion';
                }
                field(JXVZAsociateDocument; rec.JXVZAsociateDocument)
                {
                    Visible = IsVenezuela;
                    ApplicationArea = All;
                    ToolTip = 'Associated document';
                }

                field(JXVZPeriodAsocFromDate; Rec.JXVZPeriodAsocFromDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Period Asoc. from date', Comment = 'ESP="Periodo Asoc. fecha desde"';
                }

                field(JXVZPeriodAsocToDate; Rec.JXVZPeriodAsocToDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Period Asoc. to date', Comment = 'ESP="Periodo Asoc. fecha hasta"';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        IsVenezuela := CompanyInformation.JXIsVenezuela();


    end;

    var
        CompanyInformation: Record "Company Information";


        IsVenezuela: Boolean;

}