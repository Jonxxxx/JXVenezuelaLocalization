report 84116 JXVZDeleteTransactions
{
    UsageCategory = None;
    Caption = 'Delete transactions';
    ProcessingOnly = true;
    Permissions = tabledata 17 = rd, tabledata 21 = rd, tabledata 25 = rd, tabledata 32 = rd, tabledata 36 = rd, tabledata 37 = rd, tabledata 38 = rd, tabledata 39 = rd,
                  tabledata 43 = rd, tabledata 44 = rd, tabledata 45 = rd, tabledata 46 = rd, tabledata 51 = rd, tabledata 81 = rd, tabledata 83 = rd, tabledata 86 = rd,
                  tabledata 87 = rd, tabledata 110 = rd, tabledata 111 = rd, tabledata 112 = rd, tabledata 113 = rd, tabledata 114 = rd, tabledata 115 = rd, tabledata 120 = rd,
                  tabledata 121 = rd, tabledata 122 = rd, tabledata 123 = rd, tabledata 124 = rd, tabledata 125 = rd, tabledata 160 = rd, tabledata 169 = rd, tabledata 179 = rd,
                  tabledata 203 = rd, tabledata 207 = rd, tabledata 210 = rd, tabledata 240 = rd, tabledata 241 = rd, tabledata 246 = rd, tabledata 253 = rd, tabledata 254 = rd,
                  tabledata 271 = rd, tabledata 272 = rd, tabledata 273 = rd, tabledata 274 = rd, tabledata 275 = rd, tabledata 276 = rd, tabledata 281 = rd,
                  tabledata 317 = rd, tabledata 336 = rd, tabledata 337 = rd, tabledata 338 = rd, tabledata 339 = rd, tabledata 365 = rd, tabledata 379 = rd, tabledata 380 = rd,
                  tabledata 405 = rd, tabledata 480 = rd, tabledata 481 = rd, tabledata 5107 = rd, tabledata 5108 = rd, tabledata 5109 = rd, tabledata 5110 = rd, tabledata 5405 = rd,
                  tabledata 5406 = rd, tabledata 5407 = rd, tabledata 5409 = rd, tabledata 5410 = rd, tabledata 5411 = rd, tabledata 5412 = rd, tabledata 5413 = rd, tabledata 5414 = rd,
                  tabledata 5415 = rd, tabledata 5416 = rd, tabledata 5489 = rd, tabledata 5601 = rd, tabledata 5617 = rd, tabledata 5621 = rd, tabledata 5624 = rd, tabledata 5625 = rd,
                  tabledata 5629 = rd, tabledata 5635 = rd, tabledata 5636 = rd, tabledata 5740 = rd, tabledata 5741 = rd, tabledata 5765 = rd, tabledata 5766 = rd, tabledata 5767 = rd,
                  tabledata 5772 = rd, tabledata 5773 = rd, tabledata 5802 = rd, tabledata 5804 = rd, tabledata 5805 = rd, tabledata 5809 = rd, tabledata 5823 = rd, tabledata 5832 = rd,
                  tabledata 5900 = rd, tabledata 5901 = rd, tabledata 5902 = rd, tabledata 5906 = rd, tabledata 5907 = rd, tabledata 5908 = rd, tabledata 5912 = rd, tabledata 5914 = rd,
                  tabledata 5934 = rd, tabledata 5936 = rd, tabledata 5942 = rd, tabledata 5943 = rd, tabledata 5944 = rd, tabledata 5950 = rd, tabledata 5964 = rd, tabledata 5965 = rd,
                  tabledata 5967 = rd, tabledata 5969 = rd, tabledata 5970 = rd, tabledata 5971 = rd, tabledata 5972 = rd, tabledata 6084 = rd, tabledata 6504 = rd, tabledata 6505 = rd,
                  tabledata 6506 = rd, tabledata 6507 = rd, tabledata 6508 = rd, tabledata 6509 = rd, tabledata 6550 = rd, tabledata 6650 = rd, tabledata 6651 = rd, tabledata 6660 = rd,
                  tabledata 6661 = rd, tabledata 7302 = rd, tabledata 7311 = rd, tabledata 7312 = rd, tabledata 7313 = rd, tabledata 7316 = rd, tabledata 7317 = rd, tabledata 7318 = rd,
                  tabledata 7319 = rd, tabledata 7320 = rd, tabledata 7321 = rd, tabledata 7322 = rd, tabledata 7323 = rd, tabledata 7324 = rd, tabledata 7325 = rd, tabledata 710 = rd,
                  tabledata 5477 = rd, tabledata JXVZHistoryReceiptHeader = rd, tabledata JXVZHistReceiptVoucherLine = rd, tabledata JXVZHistReceiptValueLine = rd, tabledata JXVZPaymentValueEntry = rd, tabledata JXVZWithholdCalcLines = rd, tabledata JXVZWithholdCalcDocument = rd,
                  tabledata JXVZWithholdAccumCalc = rd, tabledata JXVZWithholdLedgerEntry = rd, tabledata JXVZHistoryPaymOrder = rd, tabledata JXVZHistPaymVoucherLine = rd, tabledata JXVZHistPaymValueLine = rd, tabledata JXVZExportFilesTmp = rd,
                  tabledata JXVZTempTable = rd, tabledata JXVZVatBookTmp = rd, tabledata 99000799 = rd, tabledata 99000829 = rd, tabledata 99000830 = rd, tabledata 99000832 = rd, tabledata 99000848 = rd,
                  tabledata 99000849 = rd, tabledata 8888 = rd, tabledata 8889 = rd, tabledata 701 = rd, tabledata 1518 = rd, tabledata 1520 = rd, tabledata 454 = rd,
                  tabledata 181 = rd, tabledata 1514 = rd, tabledata 1299 = rd, tabledata 456 = rd, tabledata 1170 = rd, tabledata 5222 = rd, tabledata 5223 = rd, tabledata 5811 = rd,
                  tabledata "Record Link" = rd, tabledata 2711 = rd, tabledata 929 = rd, tabledata 167 = rd, tabledata 212 = rd, tabledata 278 = rd, tabledata 472 = rd,
                  tabledata 474 = rd, tabledata 479 = rd, tabledata 1001 = rd, tabledata 1002 = rd, tabledata 1003 = rd, tabledata 1012 = rd, tabledata 1013 = rd,
                  tabledata 1014 = rd, tabledata 1015 = rd, tabledata 1017 = rd, tabledata 1018 = rd, tabledata 1019 = rd, tabledata 1020 = rd, tabledata 1021 = rd,
                  tabledata 1022 = rd, tabledata 5135 = rd, tabledata 5136 = rd, tabledata 5137 = rd;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number)
                                ORDER(Ascending)
                                WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                T17.DeleteAll();
                T21.DeleteAll();
                T25.DeleteAll();
                T32.DeleteAll();
                T36.DeleteAll();
                T37.DeleteAll();
                T38.DeleteAll();
                T39.DeleteAll();
                T43.DeleteAll();
                T44.DeleteAll();
                T45.DeleteAll();
                T46.DeleteAll();
                T51.DeleteAll();
                T81.DeleteAll();
                T83.DeleteAll();
                T86.DeleteAll();
                T87.DeleteAll();
                T110.DeleteAll();
                T111.DeleteAll();
                T112.DeleteAll();
                T113.DeleteAll();
                T114.DeleteAll();
                T115.DeleteAll();
                T120.DeleteAll();
                T121.DeleteAll();
                T122.DeleteAll();
                T123.DeleteAll();
                T124.DeleteAll();
                T125.DeleteAll();
                T160.DeleteAll();
                T169.DeleteAll();
                T179.DeleteAll();
                T203.DeleteAll();
                T207.DeleteAll();
                T210.DeleteAll();
                T240.DeleteAll();
                T241.DeleteAll();
                T246.DeleteAll();
                T253.DeleteAll();
                T254.DeleteAll();
                //T263.DeleteAll(); Removed for BC obsolete object
                T271.DeleteAll();
                T272.DeleteAll();
                T273.DeleteAll();
                T274.DeleteAll();
                T275.DeleteAll();
                T276.DeleteAll();
                T281.DeleteAll();
                T317.DeleteAll();
                T336.DeleteAll();
                T337.DeleteAll();
                T338.DeleteAll();
                T339.DeleteAll();
                T365.DeleteAll();
                T379.DeleteAll();
                T380.DeleteAll();
                T405.DeleteAll();
                T480.DeleteAll();
                T481.DeleteAll();
                //T5106.DeleteAll();
                T5107.DeleteAll();
                T5108.DeleteAll();
                T5109.DeleteAll();
                T5110.DeleteAll();
                T5405.DeleteAll();
                T5406.DeleteAll();
                T5407.DeleteAll();
                T5409.DeleteAll();
                T5410.DeleteAll();
                T5411.DeleteAll();
                T5412.DeleteAll();
                T5413.DeleteAll();
                T5414.DeleteAll();
                T5415.DeleteAll();
                T5416.DeleteAll();
                T5489.DeleteAll();
                T5601.DeleteAll();
                T5617.DeleteAll();
                T5621.DeleteAll();
                T5624.DeleteAll();
                T5625.DeleteAll();
                T5629.DeleteAll();
                T5635.DeleteAll();
                T5636.DeleteAll();
                T5740.DeleteAll();
                T5741.DeleteAll();
                T5765.DeleteAll();
                T5766.DeleteAll();
                T5767.DeleteAll();
                T5772.DeleteAll();
                T5773.DeleteAll();
                T5802.DeleteAll();
                T5804.DeleteAll();
                T5805.DeleteAll();
                T5809.DeleteAll();
                T5823.DeleteAll();
                T5832.DeleteAll();
                T5900.DeleteAll();
                T5901.DeleteAll();
                T5902.DeleteAll();
                T5906.DeleteAll();
                T5907.DeleteAll();
                T5908.DeleteAll();
                T5912.DeleteAll();
                T5914.DeleteAll();
                T5934.DeleteAll();
                T5936.DeleteAll();
                T5942.DeleteAll();
                T5943.DeleteAll();
                T5944.DeleteAll();
                T5950.DeleteAll();
                T5964.DeleteAll();
                T5965.DeleteAll();
                T5967.DeleteAll();
                T5969.DeleteAll();
                T5970.DeleteAll();
                T5971.DeleteAll();
                T5972.DeleteAll();
                T6084.DeleteAll();
                T6504.DeleteAll();
                T6505.DeleteAll();
                T6506.DeleteAll();
                T6507.DeleteAll();
                T6508.DeleteAll();
                T6509.DeleteAll();
                T6550.DeleteAll();
                T6650.DeleteAll();
                T6651.DeleteAll();
                T6660.DeleteAll();
                T6661.DeleteAll();
                //T7004.DeleteAll();
                T7302.DeleteAll();
                T7311.DeleteAll();
                T7312.DeleteAll();
                T7313.DeleteAll();
                T7316.DeleteAll();
                T7317.DeleteAll();
                T7318.DeleteAll();
                T7319.DeleteAll();
                T7320.DeleteAll();
                T7321.DeleteAll();
                T7322.DeleteAll();
                T7323.DeleteAll();
                T7324.DeleteAll();
                T7325.DeleteAll();

                //BC news
                T710.DeleteAll();
                T5477.DeleteAll();
                T8888.DeleteAll();
                T8889.DeleteAll();

                T701.DeleteAll();
                T1518.DeleteAll();
                T1520.DeleteAll();
                T454.DeleteAll();
                T181.DeleteAll();
                T1514.DeleteAll();
                T1299.DeleteAll();
                T456.DeleteAll();
                T1170.DeleteAll();
                T5222.DeleteAll();
                t5223.DeleteAll();
                //BC news end

                JXVZHistoryReceiptHeader.DeleteAll();
                JXVZHistReceiptVoucherLine.DeleteAll();
                JXVZHistReceiptValueLine.DeleteAll();
                JXVZPaymentValueEntry.DeleteAll();
                JXVZWithholdCalcLines.DeleteAll();
                JXVZWithholdCalcDocument.DeleteAll();
                JXVZWithholdAccumCalc.DeleteAll();
                JXVZWithholdLedgerEntry.DeleteAll();
                JXVZHistoryPaymOrder.DeleteAll();
                JXVZHistPaymVoucherLine.DeleteAll();
                JXVZHistPaymValueLine.DeleteAll();
                JXVZExportFilesTmp.DeleteAll();
                JXVZTempTable.DeleteAll();
                JXVZVatBookTmp.DeleteAll();
                JXVZWithholdLedgerEntryByDoc.DeleteAll();
                T99000799.DeleteAll();
                T99000829.DeleteAll();
                T99000830.DeleteAll();
                T99000832.DeleteAll();
                T99000848.DeleteAll();
                T99000849.DeleteAll();
                T5811.DeleteAll();
                TrecLink.DeleteAll();
                t2711.DeleteAll();
                t929.DeleteAll();

                "FA Depreciation Book".Reset();
                if "FA Depreciation Book".FindSet() then
                    repeat
                        "FA Depreciation Book"."Acquisition Date" := 0D;
                        "FA Depreciation Book".Modify(false);
                    until "FA Depreciation Book".Next() = 0;

                //Projects
                if DeleteProjects then begin
                    T167.DeleteAll();
                    T169.DeleteAll();
                    T210.DeleteAll();
                    T212.DeleteAll();
                    T241.DeleteAll();
                    T278.DeleteAll();
                    T472.DeleteAll();
                    T474.DeleteAll();
                    T479.DeleteAll();
                    T1001.DeleteAll();
                    T1002.DeleteAll();
                    T1003.DeleteAll();
                    T1012.DeleteAll();
                    T1013.DeleteAll();
                    T1014.DeleteAll();
                    T1015.DeleteAll();
                    T1017.DeleteAll();
                    T1018.DeleteAll();
                    T1019.DeleteAll();
                    T1020.DeleteAll();
                    T1021.DeleteAll();
                    T1022.DeleteAll();
                    T5135.DeleteAll();
                    T5136.DeleteAll();
                    T5137.DeleteAll();
                    JobUsageLink.DeleteAll();
                end;

                Update := true;

                if DeleteMasterData then begin
                    tCustomer.DeleteAll();
                    tVendor.DeleteAll();
                    tItem.DeleteAll();
                    tBank.DeleteAll();
                    tBank2.DeleteAll();
                    tBankCustomer.DeleteAll();
                    tBankVendor.DeleteAll();
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(fClave; Clave)
                {
                    Caption = 'Key';
                    ToolTip = 'Key';
                    Style = Attention;
                    StyleExpr = true;
                    ApplicationArea = All;
                }

                field(fDeleteMasterData; DeleteMasterData)
                {
                    Caption = 'Delete master data';
                    ToolTip = 'Delete customers, vendors, items, banks';
                    ApplicationArea = All;
                }

                field(fDeleteProjects; DeleteProjects)
                {
                    Caption = 'Delete projects';
                    ToolTip = 'Delete projects info';
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        IF Clave <> 'Jx@82isS8' THEN BEGIN
            MESSAGE('Clave no Válida');
            CurrReport.Quit();
        END;

        if (Confirm('Esta seguro que desea continuar?', false) = false) then begin
            MESSAGE('Proceso abortado');
            CurrReport.Quit();
        end;
    end;

    trigger OnPostReport()
    begin
        if (Update) then
            Message('Proceso finalizado');
    end;

    var
        T17: Record 17;
        T21: Record 21;
        T25: Record 25;
        T32: Record 32;
        T36: Record 36;
        T37: Record 37;
        T38: Record 38;
        T39: Record 39;
        T43: Record 43;
        T44: Record 44;
        T45: Record 45;
        T46: Record 46;
        T51: Record 51;
        T81: Record 81;
        T83: Record 83;
        T86: Record 86;
        T87: Record 87;
        T110: Record 110;
        T111: Record 111;
        T112: Record 112;
        T113: Record 113;
        T114: Record 114;
        T115: Record 115;
        T120: Record 120;
        T121: Record 121;
        T122: Record 122;
        T123: Record 123;
        T124: Record 124;
        T125: Record 125;
        T160: Record 160;
        T169: Record 169;
        T179: Record 179;
        T203: Record 203;
        T207: Record 207;
        T210: Record 210;
        T240: Record 240;
        T241: Record 241;
        T246: Record 246;
        T253: Record 253;
        T254: Record 254;
        //T263: Record 263;//Removed for BC obsolet object
        T271: Record 271;
        T272: Record 272;
        T273: Record 273;
        T274: Record 274;
        T275: Record 275;
        T276: Record 276;
        T281: Record 281;
        T317: Record 317;
        T336: Record 336;
        T337: Record 337;
        T338: Record 338;
        T339: Record 339;
        T365: Record 365;
        T379: Record 379;
        T380: Record 380;
        T405: Record 405;
        T480: Record 480;
        T481: Record 481;
        T5107: Record 5107;
        T5108: Record 5108;
        T5109: Record 5109;
        T5110: Record 5110;
        T5405: Record 5405;
        T5406: Record 5406;
        T5407: Record 5407;
        T5409: Record 5409;
        T5410: Record 5410;
        T5411: Record 5411;
        T5412: Record 5412;
        T5413: Record 5413;
        T5414: Record 5414;
        T5415: Record 5415;
        T5416: Record 5416;
        T5489: Record 5489;
        T5601: Record 5601;
        T5617: Record 5617;
        T5621: Record 5621;
        T5624: Record 5624;
        T5625: Record 5625;
        T5629: Record 5629;
        T5635: Record 5635;
        T5636: Record 5636;
        T5740: Record 5740;
        T5741: Record 5741;
        T5765: Record 5765;
        T5766: Record 5766;
        T5767: Record 5767;
        T5772: Record 5772;
        T5773: Record 5773;
        T5802: Record 5802;
        T5804: Record 5804;
        T5805: Record 5805;
        T5809: Record 5809;
        T5823: Record 5823;
        T5832: Record 5832;
        T5900: Record 5900;
        T5901: Record 5901;
        T5902: Record 5902;
        T5906: Record 5906;
        T5907: Record 5907;
        T5908: Record 5908;
        T5912: Record 5912;
        T5914: Record 5914;
        T5934: Record 5934;
        T5936: Record 5936;
        T5942: Record 5942;
        T5943: Record 5943;
        T5944: Record 5944;
        T5950: Record 5950;
        T5964: Record 5964;
        T5965: Record 5965;
        T5967: Record 5967;
        T5969: Record 5969;
        T5970: Record 5970;
        T5971: Record 5971;
        T5972: Record 5972;
        T6084: Record 6084;
        T6504: Record 6504;
        T6505: Record 6505;
        T6506: Record 6506;
        T6507: Record 6507;
        T6508: Record 6508;
        T6509: Record 6509;
        T6550: Record 6550;
        T6650: Record 6650;
        T6651: Record 6651;
        T6660: Record 6660;
        T6661: Record 6661;
        //T7004: Record 7004;
        T7302: Record 7302;
        T7311: Record 7311;
        T7312: Record 7312;
        T7313: Record 7313;
        T7316: Record 7316;
        T7317: Record 7317;
        T7318: Record 7318;
        T7319: Record 7319;
        T7320: Record 7320;
        T7321: Record 7321;
        T7322: Record 7322;
        T7323: Record 7323;
        T7324: Record 7324;
        T7325: Record 7325;
        //BC news
        T710: Record 710;
        T5477: Record 477;
        T8888: Record 8888;
        T8889: Record 8889;

        T701: Record 701;
        T1518: Record 1518;
        T1520: Record 1520;
        T454: Record 454;
        T181: Record 181;
        T1514: Record 1514;
        T1299: Record 1299;
        T456: Record 456;
        T1170: Record 1170;

        //Projects
        T167: Record 167;
        //T169: Record 169;
        //T210: Record 210;
        T212: Record 212;
        //T241: Record 241;
        T278: Record 278;
        T472: Record 472;
        T474: Record 474;
        T479: Record 479;
        T1001: Record 1001;
        T1002: Record 1002;
        T1003: Record 1003;
        T1012: Record 1012;
        T1013: Record 1013;
        T1014: Record 1014;
        T1015: Record 1015;
        T1017: Record 1017;
        T1018: Record 1018;
        T1019: Record 1019;
        T1020: Record 1020;
        T1021: Record 1021;
        T1022: Record 1022;
        T5135: Record 5135;
        T5136: Record 5136;
        T5137: Record 5137;


        //BC new END
        JXVZHistoryReceiptHeader: Record JXVZHistoryReceiptHeader;
        JXVZHistReceiptVoucherLine: Record JXVZHistReceiptVoucherLine;
        JXVZHistReceiptValueLine: Record JXVZHistReceiptValueLine;
        JXVZPaymentValueEntry: Record JXVZPaymentValueEntry;
        JXVZWithholdCalcLines: Record JXVZWithholdCalcLines;
        JXVZWithholdCalcDocument: Record JXVZWithholdCalcDocument;
        JXVZWithholdAccumCalc: Record JXVZWithholdAccumCalc;
        JXVZWithholdLedgerEntry: Record JXVZWithholdLedgerEntry;
        JXVZHistoryPaymOrder: Record JXVZHistoryPaymOrder;
        JXVZHistPaymVoucherLine: Record JXVZHistPaymVoucherLine;
        JXVZHistPaymValueLine: Record JXVZHistPaymValueLine;
        JXVZExportFilesTmp: Record JXVZExportFilesTmp;
        JXVZTempTable: Record JXVZTempTable;
        JXVZVatBookTmp: Record JXVZVatBookTmp;
        JXVZWithholdLedgerEntryByDoc: Record JXVZWithholdLedgerEntryByDoc;
        T99000799: Record 99000799;
        T99000829: Record 99000829;
        T99000830: Record 99000830;
        T99000832: Record 99000832;
        T99000848: Record 99000848;
        T99000849: Record 99000849;
        T5222: Record 5222;
        T5223: Record 5223;
        T5811: Record 5811;
        JobUsageLink: Record "Job Usage Link";
        "FA Depreciation Book": Record "FA Depreciation Book";
        TrecLink: Record "Record Link";
        t2711: Record 2711;
        t929: Record 929;
        tCustomer: Record Customer;
        tVendor: Record Vendor;
        tItem: Record Item;
        tBank: Record "Bank Account";
        tBank2: Record "Bank Account Posting Group";
        tBankVendor: Record "Vendor Bank Account";
        tBankCustomer: Record "Customer Bank Account";
        Clave: Text[30];
        Update: Boolean;
        DeleteMasterData: Boolean;
        DeleteProjects: Boolean;
}

