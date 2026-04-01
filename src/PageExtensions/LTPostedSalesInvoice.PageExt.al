pageextension 84107 JXVZPostedSalesInvoice extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Foreign Trade")
        {
            group(JXElectronicInvoice)
            {
                Visible = IsVenezuela;
                Caption = 'Venezuela',
                            Comment = 'ESP = Venezuela';
                Editable = false;


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
                    Visible = IsVenezuela;
                    ApplicationArea = all;
                    ToolTip = 'Tax area code', Comment = 'ESP=Codigo area impuesto';
                }

                field(JXFETypeVoucher; Rec.JXFETypeVoucher)
                {
                    Visible = IsVenezuela;
                    ApplicationArea = All;
                    ToolTip = 'Voucher type for FE', Comment = 'ESP = Tipo de voucher para FE';
                }

                field(JXVZDispatchImportation; Rec.JXVZDispatchImportation)
                {
                    Visible = IsVenezuela;
                    ApplicationArea = all;
                    ToolTip = 'Dispatch Importation', Comment = 'ESP=Despacho de importacion';
                }

            }
        }
    }

    trigger OnOpenPage()
    begin
        VisiblePdfReport := false;
        IsVenezuela := CompanyInformation.JXIsVenezuela();



        if ((IsVenezuela)) then begin


            JXVZFEConfiguration.Reset();
            if JXVZFEConfiguration.FindFirst() then
                if JXVZFEConfiguration.JXFEVisibleSavePdfReport then
                    VisiblePdfReport := true;
        end;
    end;

    var
        CompanyInformation: Record "Company Information";
        JXVZFEConfiguration: Record JXVZFEConfiguration;


        IsVenezuela: Boolean;
        VisiblePdfReport: Boolean;

}