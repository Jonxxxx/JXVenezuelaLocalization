pageextension 84199 JXVZReverseEntries extends "Reverse Transaction Entries" /*"Reverse Entries"*/
{
    layout
    {
        addfirst(Content)
        {
            field(JXglobaPostingDate; globaPostingDate)
            {
                Visible = IsVenezuela;
                ApplicationArea = All;
                Caption = 'Posting Date', Comment = 'ESP=Fecha de registro';
                ToolTip = 'Posting Date', Comment = 'ESP=Fecha de registro';

                trigger OnValidate()
                var
                    pkey: Integer;
                begin
                    if IsVenezuela then
                        if globaPostingDate <> 0D then begin
                            JXVZTempTable.Reset();
                            JXVZTempTable.SetRange(JXVZTempTable.User, UserId);
                            JXVZTempTable.DeleteAll();

                            JXVZTempTable.Reset();
                            if JXVZTempTable.FindLast() then
                                pkey := JXVZTempTable.pKey + 1
                            else
                                pkey := 1;

                            JXVZTempTable.Init();
                            JXVZTempTable.pKey := pkey;
                            JXVZTempTable.PostingDate := globaPostingDate;
                            JXVZTempTable.Revert := true;
                            JXVZTempTable.User := CopyStr(UserId, 1, 250);
                            JXVZTempTable.Insert();
                        end;
                end;

            }
        }
    }

    var
        JXVZTempTable: Record JXVZTempTable;
        CompanyInformation: Record "Company Information";
        globaPostingDate: Date;


        IsVenezuela: Boolean;
        IsCustom: Boolean;


    trigger OnOpenPage()
    begin
        IsVenezuela := CompanyInformation.JXIsVenezuela();

        if IsVenezuela then
            globaPostingDate := Rec."Posting Date";
    end;

    trigger OnClosePage()
    begin
        if IsVenezuela then begin
            JXVZTempTable.Reset();
            JXVZTempTable.SetRange(JXVZTempTable.User, UserId);
            JXVZTempTable.DeleteAll();
        end;
    end;
}