codeunit 84101 JXVZVenApplicationAreaMgt
{
    procedure ApplyVenezuelaApplicationArea()
    var
        CompanyInformation: Record "Company Information";
        CurrentApplicationAreas: Text;
        NewApplicationAreas: Text;
    begin
        if not CompanyInformation.Get() then
            exit;

        CurrentApplicationAreas := Session.ApplicationArea();
        NewApplicationAreas := BuildApplicationAreaList(
          CurrentApplicationAreas,
          GetVenezuelaApplicationArea(),
          CompanyInformation.JXVZVenezuelaLocEnabled);

        if NewApplicationAreas <> CurrentApplicationAreas then
            Session.ApplicationArea(NewApplicationAreas);
    end;

    procedure GetVenezuelaApplicationArea(): Text
    begin
        exit(GlobalAppAreaVen);
    end;

    procedure IsVenezuelaEnabled(): Boolean
    var
        CompanyInformation: Record "Company Information";
    begin
        if not CompanyInformation.Get() then
            exit(false);

        exit(CompanyInformation.JXVZVenezuelaLocEnabled);
    end;

    local procedure BuildApplicationAreaList(CurrentApplicationAreas: Text; ApplicationAreaName: Text; EnableApplicationArea: Boolean): Text
    begin
        CurrentApplicationAreas := RemoveApplicationArea(CurrentApplicationAreas, ApplicationAreaName);

        if EnableApplicationArea then
            exit(AddApplicationArea(CurrentApplicationAreas, ApplicationAreaName));

        exit(CurrentApplicationAreas);
    end;

    local procedure AddApplicationArea(CurrentApplicationAreas: Text; ApplicationAreaName: Text): Text
    begin
        if CurrentApplicationAreas = '' then
            exit(ApplicationAreaName);

        exit(CurrentApplicationAreas + ',' + ApplicationAreaName);
    end;

    local procedure RemoveApplicationArea(CurrentApplicationAreas: Text; ApplicationAreaName: Text): Text
    var
        ApplicationAreaList: List of [Text];
        ResultApplicationAreas: Text;
        ApplicationAreaValue: Text;
    begin
        SplitApplicationAreas(CurrentApplicationAreas, ApplicationAreaList);

        foreach ApplicationAreaValue in ApplicationAreaList do
            if UpperCase(ApplicationAreaValue) <> UpperCase(ApplicationAreaName) then begin
                if ResultApplicationAreas = '' then
                    ResultApplicationAreas := ApplicationAreaValue
                else
                    ResultApplicationAreas += ',' + ApplicationAreaValue;
            end;

        exit(ResultApplicationAreas);
    end;

    local procedure SplitApplicationAreas(ApplicationAreas: Text; var ApplicationAreaList: List of [Text])
    var
        WorkingText: Text;
        CommaPosition: Integer;
        ApplicationAreaValue: Text;
    begin
        WorkingText := DelChr(ApplicationAreas, '<>', ' ');

        while WorkingText <> '' do begin
            CommaPosition := StrPos(WorkingText, ',');

            if CommaPosition = 0 then begin
                ApplicationAreaValue := WorkingText;
                WorkingText := '';
            end else begin
                ApplicationAreaValue := CopyStr(WorkingText, 1, CommaPosition - 1);
                WorkingText := CopyStr(WorkingText, CommaPosition + 1);
            end;

            if ApplicationAreaValue <> '' then
                ApplicationAreaList.Add(ApplicationAreaValue);
        end;
    end;

    //Control aplication Area
    [EventSubscriber(ObjectType::Codeunit, 9178, 'OnGetEssentialExperienceAppAreas', '', false, false)]
    local procedure GetEssentialExperienceAppAreas(var TempApplicationAreaSetup: Record "Application Area Setup" temporary)
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Reset();
        if CompanyInfo.FindFirst() then;
        if CompanyInfo.JXVZVenezuelaLocEnabled then begin
            TempApplicationAreaSetup.JXVZshowVen := true;
            TempApplicationAreaSetup.JXVZNotshowVen := false;
        end else begin
            TempApplicationAreaSetup.JXVZshowVen := false;
            TempApplicationAreaSetup.JXVZNotshowVen := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 79, 'OnAfterModifyEvent', '', true, true)]
    local procedure AfterModifyEvent9000(var Rec: Record "Company Information"; var xRec: Record "Company Information"; RunTrigger: Boolean)
    var
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin
        ApplicationAreaMgmtFacade.RefreshExperienceTierCurrentCompany();
    end;

    procedure SetGlobalAppAreaVenezuela(AppArea: Text)
    begin
        GlobalAppAreaVen := AppArea;
    end;

    var
        GlobalAppAreaVen: Text;
}