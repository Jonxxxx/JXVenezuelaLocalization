page 84116 JXVZPaymentSetup
{
    Caption = 'Payment Venezuela setup', Comment = 'ESP=Config. pagos Venezuela';
    PageType = Card;
    SourceTable = JXVZPaymentSetup;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Reports)
            {
                Caption = 'Reports', Comment = 'ESP=Reportes';
                field(JXVZHistReceiptReport; Rec.JXVZHistReceiptReport)
                {
                    ApplicationArea = All;
                    ToolTip = 'Register receipt report', Comment = 'ESP=Reporte recibo registrado';
                }
                field(JXVZHisPaymentReport; Rec.JXVZHisPaymentReport)
                {
                    ApplicationArea = All;
                    ToolTip = 'Register payment report', Comment = 'ESP=Reporte orden de pago registrado';
                }
                field(JXVZWitholdReport; Rec.JXVZWitholdReport)
                {
                    ApplicationArea = All;
                    ToolTip = 'Withholding report', Comment = 'ESP=Reporte Retenciones';
                }
                field(JXVZGainReport; Rec.JXVZGainReport)
                {
                    ApplicationArea = All;
                    ToolTip = 'Gain report', Comment = 'ESP=Reporte ganancias';
                }
                field(JXVZSussReport; Rec.JXVZSussReport)
                {
                    ApplicationArea = All;
                    ToolTip = 'Suss report', Comment = 'ESP=Reporte Suss';
                }

                field(JXVZAccountDescripOP; rec.JXVZAccountDescripOP)
                {
                    ApplicationArea = All;
                    ToolTip = 'Account description in line OP report';
                }
            }

            group(Others)
            {
                Caption = 'Others', Comment = 'ESP="Otros"';


                field(JXVZControlSecuencePaymorderNo; Rec.JXVZControlSecuencePaymorderNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Control for payment order posted secuence';
                }
            }
        }
    }

    actions
    {
        Area(Processing)
        {
            action(DeleteTransactions)
            {
                ApplicationArea = All;
                Caption = 'Delete all transactions';
                ToolTip = 'Delete all transactions';

                trigger OnAction()
                var
                    JXVZDeleteTransactions: Report JXVZDeleteTransactions;
                begin
                    Clear(JXVZDeleteTransactions);
                    JXVZDeleteTransactions.Run();
                end;
            }

            action(InitSeriesNum)
            {
                ApplicationArea = All;
                Caption = 'Init series numbers';
                ToolTip = 'Init series numbers';

                trigger OnAction()
                var
                    NoSeries: Record "No. Series";
                    NoSeriesLines: Record "No. Series Line";
                begin
                    if (confirm('Esta seguro que desea continuar?', false)) then
                        if Confirm('Al realizar esta accion no se pueden recuperar los datos, desea continuar?', false) then begin
                            NoSeries.Reset();
                            if NoSeries.FindSet() then
                                repeat
                                    NoSeriesLines.Reset();
                                    NoSeriesLines.SetRange("Series Code", NoSeries.Code);
                                    if NoSeriesLines.FindFirst() then begin
                                        NoSeriesLines."Last Date Used" := 0D;
                                        NoSeriesLines."Last No. Used" := '';
                                        NoSeriesLines.Modify();
                                    end;
                                until NoSeries.Next() = 0;

                            Message('End process');
                        end;
                end;
            }
        }
    }
}