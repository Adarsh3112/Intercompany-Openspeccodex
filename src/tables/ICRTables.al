table 50100 "ICR Recharge Setup"
{
    Caption = 'Intercompany Recharge Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10]) { Caption = 'Primary Key'; DataClassification = SystemMetadata; }
        field(2; "Source Company"; Code[30]) { Caption = 'Source Company'; DataClassification = CustomerContent; }
        field(3; "Request Nos."; Code[20]) { Caption = 'Request Nos.'; DataClassification = CustomerContent; TableRelation = "No. Series"; }
        field(4; "Default Posting Method"; Enum "ICR Posting Method") { Caption = 'Default Posting Method'; DataClassification = CustomerContent; }
        field(5; "Default Currency Rule"; Enum "ICR Currency Rule") { Caption = 'Default Currency Rule'; DataClassification = CustomerContent; }
        field(6; "Default Approval Threshold"; Decimal) { Caption = 'Default Approval Threshold'; DataClassification = CustomerContent; MinValue = 0; }
        field(7; "Auto-Send Default"; Boolean) { Caption = 'Auto-Send Default'; DataClassification = CustomerContent; }
        field(8; "Auto-Accept Default"; Boolean) { Caption = 'Auto-Accept Default'; DataClassification = CustomerContent; }
        field(9; "Allow Auto Accept Review"; Boolean) { Caption = 'Allow Auto Accept Review'; DataClassification = CustomerContent; }
        field(10; "Rounding Tolerance"; Decimal) { Caption = 'Rounding Tolerance'; DataClassification = CustomerContent; DecimalPlaces = 0 : 5; MinValue = 0; }
        field(11; "Setup Valid"; Boolean) { Caption = 'Setup Valid'; DataClassification = CustomerContent; Editable = false; }
        field(12; "Job Queue Enabled"; Boolean) { Caption = 'Job Queue Enabled'; DataClassification = CustomerContent; }
        field(13; "Last Validation Message"; Text[250]) { Caption = 'Last Validation Message'; DataClassification = CustomerContent; Editable = false; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }

    trigger OnInsert()
    begin
        if "Primary Key" = '' then
            "Primary Key" := 'SETUP';
    end;
}

table 50101 "ICR Partner Rule"
{
    Caption = 'Intercompany Recharge Partner Rule';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Rule Code"; Code[20]) { Caption = 'Rule Code'; DataClassification = CustomerContent; }
        field(2; "Source Company"; Code[30]) { Caption = 'Source Company'; DataClassification = CustomerContent; }
        field(3; "Target Company"; Code[30]) { Caption = 'Target Company'; DataClassification = CustomerContent; }
        field(4; "IC Partner Code"; Code[20]) { Caption = 'IC Partner Code'; DataClassification = CustomerContent; }
        field(5; "Recharge Type"; Code[20]) { Caption = 'Recharge Type'; DataClassification = CustomerContent; }
        field(6; "Cost Pool"; Code[20]) { Caption = 'Cost Pool'; DataClassification = CustomerContent; }
        field(7; "Allocation Basis"; Enum "ICR Allocation Basis") { Caption = 'Allocation Basis'; DataClassification = CustomerContent; }
        field(8; "Allocation Percent"; Decimal) { Caption = 'Allocation Percent'; DataClassification = CustomerContent; DecimalPlaces = 0 : 5; MinValue = 0; MaxValue = 100; }
        field(9; "Allocation Amount"; Decimal) { Caption = 'Allocation Amount'; DataClassification = CustomerContent; }
        field(10; "Driver Code"; Code[20]) { Caption = 'Driver Code'; DataClassification = CustomerContent; }
        field(11; "Source G/L Account"; Code[20]) { Caption = 'Source G/L Account'; DataClassification = CustomerContent; }
        field(12; "Target IC G/L Account"; Code[20]) { Caption = 'Target IC G/L Account'; DataClassification = CustomerContent; }
        field(13; "Dimension Rule Code"; Code[20]) { Caption = 'Dimension Rule Code'; DataClassification = CustomerContent; }
        field(14; "Currency Rule"; Enum "ICR Currency Rule") { Caption = 'Currency Rule'; DataClassification = CustomerContent; }
        field(15; "Source Currency Code"; Code[10]) { Caption = 'Source Currency Code'; DataClassification = CustomerContent; }
        field(16; "Target Currency Code"; Code[10]) { Caption = 'Target Currency Code'; DataClassification = CustomerContent; }
        field(17; "Exchange Rate"; Decimal) { Caption = 'Exchange Rate'; DataClassification = CustomerContent; DecimalPlaces = 0 : 9; MinValue = 0; }
        field(18; "Approval Threshold"; Decimal) { Caption = 'Approval Threshold'; DataClassification = CustomerContent; MinValue = 0; }
        field(19; "Auto-Send"; Boolean) { Caption = 'Auto-Send'; DataClassification = CustomerContent; }
        field(20; "Auto-Accept"; Boolean) { Caption = 'Auto-Accept'; DataClassification = CustomerContent; }
        field(21; "Manual Review Required"; Boolean) { Caption = 'Manual Review Required'; DataClassification = CustomerContent; }
        field(22; Active; Boolean) { Caption = 'Active'; DataClassification = CustomerContent; InitValue = true; }
        field(23; "Effective Start Date"; Date) { Caption = 'Effective Start Date'; DataClassification = CustomerContent; }
        field(24; "Effective End Date"; Date) { Caption = 'Effective End Date'; DataClassification = CustomerContent; }
        field(25; Priority; Integer) { Caption = 'Priority'; DataClassification = CustomerContent; MinValue = 0; }
    }

    keys
    {
        key(PK; "Rule Code") { Clustered = true; }
        key(Resolve; "Source Company", "Recharge Type", "Cost Pool", "Source G/L Account", Active, Priority) { }
    }
}

table 50102 "ICR Dimension Rule"
{
    Caption = 'Intercompany Recharge Dimension Rule';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Rule Code"; Code[20]) { Caption = 'Rule Code'; DataClassification = CustomerContent; }
        field(2; Direction; Option) { Caption = 'Direction'; DataClassification = CustomerContent; OptionMembers = Outbound,Inbound; OptionCaption = 'Outbound,Inbound'; }
        field(3; "Source Dimension Code"; Code[20]) { Caption = 'Source Dimension Code'; DataClassification = CustomerContent; }
        field(4; "Source Dimension Value"; Code[20]) { Caption = 'Source Dimension Value'; DataClassification = CustomerContent; }
        field(5; "Target Dimension Code"; Code[20]) { Caption = 'Target Dimension Code'; DataClassification = CustomerContent; }
        field(6; "Target Dimension Value"; Code[20]) { Caption = 'Target Dimension Value'; DataClassification = CustomerContent; }
        field(7; Required; Boolean) { Caption = 'Required'; DataClassification = CustomerContent; InitValue = true; }
        field(8; Active; Boolean) { Caption = 'Active'; DataClassification = CustomerContent; InitValue = true; }
    }

    keys
    {
        key(PK; "Rule Code", Direction, "Source Dimension Code", "Source Dimension Value") { Clustered = true; }
    }
}

table 50103 "ICR Driver Value"
{
    Caption = 'Intercompany Recharge Driver Value';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Driver Code"; Code[20]) { Caption = 'Driver Code'; DataClassification = CustomerContent; }
        field(2; "Period Start"; Date) { Caption = 'Period Start'; DataClassification = CustomerContent; }
        field(3; "Partner Rule Code"; Code[20]) { Caption = 'Partner Rule Code'; DataClassification = CustomerContent; TableRelation = "ICR Partner Rule"."Rule Code"; }
        field(4; Quantity; Decimal) { Caption = 'Quantity'; DataClassification = CustomerContent; DecimalPlaces = 0 : 5; MinValue = 0; }
    }

    keys
    {
        key(PK; "Driver Code", "Period Start", "Partner Rule Code") { Clustered = true; }
    }
}

table 50104 "ICR Recharge Request"
{
    Caption = 'Intercompany Recharge Request';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20]) { Caption = 'No.'; DataClassification = CustomerContent; }
        field(2; Status; Enum "ICR Recharge Status") { Caption = 'Status'; DataClassification = CustomerContent; Editable = false; }
        field(3; "Source Company"; Code[30]) { Caption = 'Source Company'; DataClassification = CustomerContent; }
        field(4; "Period Start"; Date) { Caption = 'Period Start'; DataClassification = CustomerContent; }
        field(5; "Period End"; Date) { Caption = 'Period End'; DataClassification = CustomerContent; }
        field(6; "Recharge Type"; Code[20]) { Caption = 'Recharge Type'; DataClassification = CustomerContent; }
        field(7; "Cost Pool"; Code[20]) { Caption = 'Cost Pool'; DataClassification = CustomerContent; }
        field(8; "Source G/L Account"; Code[20]) { Caption = 'Source G/L Account'; DataClassification = CustomerContent; }
        field(9; "Currency Code"; Code[10]) { Caption = 'Currency Code'; DataClassification = CustomerContent; }
        field(10; "Total Source Amount"; Decimal) { Caption = 'Total Source Amount'; DataClassification = CustomerContent; Editable = false; }
        field(11; "Total Allocation Amount"; Decimal) { Caption = 'Total Allocation Amount'; DataClassification = CustomerContent; Editable = false; }
        field(12; "Posted Amount"; Decimal) { Caption = 'Posted Amount'; DataClassification = CustomerContent; Editable = false; }
        field(13; "Requested By"; Code[50]) { Caption = 'Requested By'; DataClassification = EndUserIdentifiableInformation; Editable = false; }
        field(14; "Approved By"; Code[50]) { Caption = 'Approved By'; DataClassification = EndUserIdentifiableInformation; Editable = false; }
        field(15; "Posted By"; Code[50]) { Caption = 'Posted By'; DataClassification = EndUserIdentifiableInformation; Editable = false; }
        field(16; "Rejected By"; Code[50]) { Caption = 'Rejected By'; DataClassification = EndUserIdentifiableInformation; Editable = false; }
        field(17; "Locked"; Boolean) { Caption = 'Locked'; DataClassification = CustomerContent; Editable = false; }
        field(18; "Approval Required"; Boolean) { Caption = 'Approval Required'; DataClassification = CustomerContent; Editable = false; }
        field(19; "Exception Flag"; Boolean) { Caption = 'Exception Flag'; DataClassification = CustomerContent; Editable = false; }
        field(20; "Manual Review Required"; Boolean) { Caption = 'Manual Review Required'; DataClassification = CustomerContent; Editable = false; }
        field(21; "Last Error"; Text[250]) { Caption = 'Last Error'; DataClassification = CustomerContent; Editable = false; }
        field(22; "Rejection Reason"; Text[250]) { Caption = 'Rejection Reason'; DataClassification = CustomerContent; }
        field(23; "Correction Reason"; Code[20]) { Caption = 'Correction Reason'; DataClassification = CustomerContent; }
        field(24; "Reversal Reason"; Code[20]) { Caption = 'Reversal Reason'; DataClassification = CustomerContent; }
        field(25; "Idempotency Key"; Code[100]) { Caption = 'Idempotency Key'; DataClassification = SystemMetadata; Editable = false; }
        field(26; "Reconciliation Status"; Text[30]) { Caption = 'Reconciliation Status'; DataClassification = CustomerContent; Editable = false; }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(StatusKey; Status, "Source Company", "Period Start", "Recharge Type") { }
    }

    trigger OnInsert()
    var
        Setup: Record "ICR Recharge Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if "No." = '' then begin
            Setup.Get('SETUP');
            Setup.TestField("Request Nos.");
            "No." := NoSeries.GetNextNo(Setup."Request Nos.");
        end;

        Status := Status::Draft;
        "Requested By" := CopyStr(UserId(), 1, MaxStrLen("Requested By"));
        "Idempotency Key" := CopyStr("No." + '|REQUEST', 1, MaxStrLen("Idempotency Key"));
    end;

    trigger OnModify()
    begin
        if xRec."No." <> '' then
            if xRec.Locked then
                if (Status = xRec.Status) and (("Total Source Amount" <> xRec."Total Source Amount") or ("Total Allocation Amount" <> xRec."Total Allocation Amount") or ("Posted Amount" <> xRec."Posted Amount") or ("Source G/L Account" <> xRec."Source G/L Account") or ("Currency Code" <> xRec."Currency Code")) then
                    Error('Approved or posted recharge request %1 is locked; use reversal or correction.', "No.");
    end;
}

table 50105 "ICR Recharge Source Line"
{
    Caption = 'Intercompany Recharge Source Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Request No."; Code[20]) { Caption = 'Request No.'; DataClassification = CustomerContent; TableRelation = "ICR Recharge Request"."No."; }
        field(2; "Line No."; Integer) { Caption = 'Line No.'; DataClassification = SystemMetadata; }
        field(3; Description; Text[100]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(4; Amount; Decimal) { Caption = 'Amount'; DataClassification = CustomerContent; }
        field(5; "Currency Code"; Code[10]) { Caption = 'Currency Code'; DataClassification = CustomerContent; }
        field(6; "Source G/L Account"; Code[20]) { Caption = 'Source G/L Account'; DataClassification = CustomerContent; }
        field(7; "Dimension Code"; Code[20]) { Caption = 'Dimension Code'; DataClassification = CustomerContent; }
        field(8; "Dimension Value"; Code[20]) { Caption = 'Dimension Value'; DataClassification = CustomerContent; }
        field(9; "Manual Basis"; Boolean) { Caption = 'Manual Basis'; DataClassification = CustomerContent; InitValue = true; }
    }

    keys
    {
        key(PK; "Request No.", "Line No.") { Clustered = true; }
    }

    trigger OnInsert()
    begin
        if "Line No." = 0 then
            "Line No." := GetNextLineNo("Request No.");
    end;

    local procedure GetNextLineNo(RequestNo: Code[20]): Integer
    var
        SourceLine: Record "ICR Recharge Source Line";
    begin
        SourceLine.SetRange("Request No.", RequestNo);
        if SourceLine.FindLast() then
            exit(SourceLine."Line No." + 10000);
        exit(10000);
    end;
}

table 50106 "ICR Recharge Allocation Line"
{
    Caption = 'Intercompany Recharge Allocation Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Request No."; Code[20]) { Caption = 'Request No.'; DataClassification = CustomerContent; TableRelation = "ICR Recharge Request"."No."; }
        field(2; "Line No."; Integer) { Caption = 'Line No.'; DataClassification = SystemMetadata; }
        field(3; "Source Line No."; Integer) { Caption = 'Source Line No.'; DataClassification = CustomerContent; }
        field(4; "Partner Rule Code"; Code[20]) { Caption = 'Partner Rule Code'; DataClassification = CustomerContent; TableRelation = "ICR Partner Rule"."Rule Code"; }
        field(5; "IC Partner Code"; Code[20]) { Caption = 'IC Partner Code'; DataClassification = CustomerContent; }
        field(6; "Target Company"; Code[30]) { Caption = 'Target Company'; DataClassification = CustomerContent; }
        field(7; "Allocation Basis"; Enum "ICR Allocation Basis") { Caption = 'Allocation Basis'; DataClassification = CustomerContent; }
        field(8; "Source Amount"; Decimal) { Caption = 'Source Amount'; DataClassification = CustomerContent; }
        field(9; "Allocation Percent"; Decimal) { Caption = 'Allocation Percent'; DataClassification = CustomerContent; DecimalPlaces = 0 : 5; MinValue = 0; }
        field(10; "Driver Quantity"; Decimal) { Caption = 'Driver Quantity'; DataClassification = CustomerContent; DecimalPlaces = 0 : 5; MinValue = 0; }
        field(11; "Allocation Amount"; Decimal) { Caption = 'Allocation Amount'; DataClassification = CustomerContent; }
        field(12; "Source Currency Code"; Code[10]) { Caption = 'Source Currency Code'; DataClassification = CustomerContent; }
        field(13; "Target Currency Code"; Code[10]) { Caption = 'Target Currency Code'; DataClassification = CustomerContent; }
        field(14; "Exchange Rate"; Decimal) { Caption = 'Exchange Rate'; DataClassification = CustomerContent; DecimalPlaces = 0 : 9; MinValue = 0; }
        field(15; "Rate Date"; Date) { Caption = 'Rate Date'; DataClassification = CustomerContent; }
        field(16; "Target Amount"; Decimal) { Caption = 'Target Amount'; DataClassification = CustomerContent; }
        field(17; "Rounding Residual"; Decimal) { Caption = 'Rounding Residual'; DataClassification = CustomerContent; DecimalPlaces = 0 : 5; }
        field(18; "Target IC G/L Account"; Code[20]) { Caption = 'Target IC G/L Account'; DataClassification = CustomerContent; }
        field(19; "Target Dimension Code"; Code[20]) { Caption = 'Target Dimension Code'; DataClassification = CustomerContent; }
        field(20; "Target Dimension Value"; Code[20]) { Caption = 'Target Dimension Value'; DataClassification = CustomerContent; }
        field(21; "Override Reason"; Code[20]) { Caption = 'Override Reason'; DataClassification = CustomerContent; }
        field(22; "Manual Override"; Boolean) { Caption = 'Manual Override'; DataClassification = CustomerContent; }
        field(23; "Calculation Trace"; Text[250]) { Caption = 'Calculation Trace'; DataClassification = CustomerContent; }
        field(24; "Response Status"; Enum "ICR Partner Response Status") { Caption = 'Response Status'; DataClassification = CustomerContent; }
        field(25; "Idempotency Key"; Code[100]) { Caption = 'Idempotency Key'; DataClassification = SystemMetadata; }
    }

    keys
    {
        key(PK; "Request No.", "Line No.") { Clustered = true; }
        key(Partner; "IC Partner Code", "Response Status") { }
    }

    trigger OnInsert()
    begin
        if "Line No." = 0 then
            "Line No." := GetNextLineNo("Request No.");
    end;

    trigger OnModify()
    begin
        if "Manual Override" and ("Override Reason" = '') then
            Error('Override reason is required for manual allocation overrides.');
    end;

    local procedure GetNextLineNo(RequestNo: Code[20]): Integer
    var
        AllocationLine: Record "ICR Recharge Allocation Line";
    begin
        AllocationLine.SetRange("Request No.", RequestNo);
        if AllocationLine.FindLast() then
            exit(AllocationLine."Line No." + 10000);
        exit(10000);
    end;
}

table 50107 "ICR Recharge Posting Link"
{
    Caption = 'Intercompany Recharge Posting Link';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Request No."; Code[20]) { Caption = 'Request No.'; DataClassification = CustomerContent; TableRelation = "ICR Recharge Request"."No."; }
        field(2; "Line No."; Integer) { Caption = 'Line No.'; DataClassification = SystemMetadata; }
        field(3; "Allocation Line No."; Integer) { Caption = 'Allocation Line No.'; DataClassification = CustomerContent; }
        field(4; "Posting Method"; Enum "ICR Posting Method") { Caption = 'Posting Method'; DataClassification = CustomerContent; }
        field(5; "Document No."; Code[20]) { Caption = 'Document No.'; DataClassification = CustomerContent; }
        field(6; "Journal Template Name"; Code[10]) { Caption = 'Journal Template Name'; DataClassification = CustomerContent; }
        field(7; "Journal Batch Name"; Code[10]) { Caption = 'Journal Batch Name'; DataClassification = CustomerContent; }
        field(8; "Outbox Transaction Id"; Code[50]) { Caption = 'Outbox Transaction Id'; DataClassification = CustomerContent; }
        field(9; "Inbox Transaction Id"; Code[50]) { Caption = 'Inbox Transaction Id'; DataClassification = CustomerContent; }
        field(10; Amount; Decimal) { Caption = 'Amount'; DataClassification = CustomerContent; }
        field(11; "Target Amount"; Decimal) { Caption = 'Target Amount'; DataClassification = CustomerContent; }
        field(12; "Currency Code"; Code[10]) { Caption = 'Currency Code'; DataClassification = CustomerContent; }
        field(13; "Idempotency Key"; Code[100]) { Caption = 'Idempotency Key'; DataClassification = SystemMetadata; }
        field(14; Posted; Boolean) { Caption = 'Posted'; DataClassification = CustomerContent; }
        field(15; "Correction Type"; Enum "ICR Correction Type") { Caption = 'Correction Type'; DataClassification = CustomerContent; }
        field(16; "Original Request No."; Code[20]) { Caption = 'Original Request No.'; DataClassification = CustomerContent; }
        field(17; "Created At"; DateTime) { Caption = 'Created At'; DataClassification = SystemMetadata; Editable = false; }
    }

    keys
    {
        key(PK; "Request No.", "Line No.") { Clustered = true; }
        key(Idempotency; "Idempotency Key") { }
    }

    trigger OnInsert()
    begin
        if "Line No." = 0 then
            "Line No." := GetNextLineNo("Request No.");
        "Created At" := CurrentDateTime();
    end;

    local procedure GetNextLineNo(RequestNo: Code[20]): Integer
    var
        PostingLink: Record "ICR Recharge Posting Link";
    begin
        PostingLink.SetRange("Request No.", RequestNo);
        if PostingLink.FindLast() then
            exit(PostingLink."Line No." + 10000);
        exit(10000);
    end;
}

table 50108 "ICR Recharge Audit Event"
{
    Caption = 'Intercompany Recharge Audit Event';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { Caption = 'Entry No.'; DataClassification = SystemMetadata; AutoIncrement = true; }
        field(2; "Request No."; Code[20]) { Caption = 'Request No.'; DataClassification = CustomerContent; }
        field(3; "Event Type"; Code[30]) { Caption = 'Event Type'; DataClassification = CustomerContent; }
        field(4; "Old Value"; Text[100]) { Caption = 'Old Value'; DataClassification = CustomerContent; }
        field(5; "New Value"; Text[100]) { Caption = 'New Value'; DataClassification = CustomerContent; }
        field(6; "Reason Code"; Code[20]) { Caption = 'Reason Code'; DataClassification = CustomerContent; }
        field(7; "User ID"; Code[50]) { Caption = 'User ID'; DataClassification = EndUserIdentifiableInformation; }
        field(8; "Created At"; DateTime) { Caption = 'Created At'; DataClassification = SystemMetadata; }
        field(9; "Company"; Code[30]) { Caption = 'Company'; DataClassification = CustomerContent; }
        field(10; Details; Text[250]) { Caption = 'Details'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(Request; "Request No.", "Created At") { }
    }
}

table 50109 "ICR Recharge Exception"
{
    Caption = 'Intercompany Recharge Exception';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { Caption = 'Entry No.'; DataClassification = SystemMetadata; AutoIncrement = true; }
        field(2; "Request No."; Code[20]) { Caption = 'Request No.'; DataClassification = CustomerContent; }
        field(3; "Partner Rule Code"; Code[20]) { Caption = 'Partner Rule Code'; DataClassification = CustomerContent; }
        field(4; "Exception Type"; Code[30]) { Caption = 'Exception Type'; DataClassification = CustomerContent; }
        field(5; Severity; Enum "ICR Exception Severity") { Caption = 'Severity'; DataClassification = CustomerContent; }
        field(6; Message; Text[250]) { Caption = 'Message'; DataClassification = CustomerContent; }
        field(7; "Owner Role"; Code[30]) { Caption = 'Owner Role'; DataClassification = CustomerContent; }
        field(8; "Retry Eligible"; Boolean) { Caption = 'Retry Eligible'; DataClassification = CustomerContent; }
        field(9; Resolved; Boolean) { Caption = 'Resolved'; DataClassification = CustomerContent; }
        field(10; "Created At"; DateTime) { Caption = 'Created At'; DataClassification = SystemMetadata; }
        field(11; "Resolved At"; DateTime) { Caption = 'Resolved At'; DataClassification = SystemMetadata; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(Request; "Request No.", Resolved, Severity) { }
    }
}

table 50110 "ICR Approval History"
{
    Caption = 'Intercompany Recharge Approval History';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { Caption = 'Entry No.'; DataClassification = SystemMetadata; AutoIncrement = true; }
        field(2; "Request No."; Code[20]) { Caption = 'Request No.'; DataClassification = CustomerContent; }
        field(3; Action; Code[30]) { Caption = 'Action'; DataClassification = CustomerContent; }
        field(4; "Actor User ID"; Code[50]) { Caption = 'Actor User ID'; DataClassification = EndUserIdentifiableInformation; }
        field(5; Comment; Text[250]) { Caption = 'Comment'; DataClassification = CustomerContent; }
        field(6; "Resulting Status"; Enum "ICR Recharge Status") { Caption = 'Resulting Status'; DataClassification = CustomerContent; }
        field(7; "Created At"; DateTime) { Caption = 'Created At'; DataClassification = SystemMetadata; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(Request; "Request No.", "Created At") { }
    }
}

table 50111 "ICR Processing Unit"
{
    Caption = 'Intercompany Recharge Processing Unit';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Unit Id"; Code[100]) { Caption = 'Unit Id'; DataClassification = SystemMetadata; }
        field(2; "Request No."; Code[20]) { Caption = 'Request No.'; DataClassification = CustomerContent; }
        field(3; "Source Company"; Code[30]) { Caption = 'Source Company'; DataClassification = CustomerContent; }
        field(4; "Recharge Type"; Code[20]) { Caption = 'Recharge Type'; DataClassification = CustomerContent; }
        field(5; "Partner Rule Code"; Code[20]) { Caption = 'Partner Rule Code'; DataClassification = CustomerContent; }
        field(6; "Period Start"; Date) { Caption = 'Period Start'; DataClassification = CustomerContent; }
        field(7; "Period End"; Date) { Caption = 'Period End'; DataClassification = CustomerContent; }
        field(8; Status; Enum "ICR Processing Status") { Caption = 'Status'; DataClassification = CustomerContent; }
        field(9; "Retry Count"; Integer) { Caption = 'Retry Count'; DataClassification = CustomerContent; MinValue = 0; }
        field(10; "Last Error"; Text[250]) { Caption = 'Last Error'; DataClassification = CustomerContent; }
        field(11; "Created At"; DateTime) { Caption = 'Created At'; DataClassification = SystemMetadata; }
        field(12; "Updated At"; DateTime) { Caption = 'Updated At'; DataClassification = SystemMetadata; }
    }

    keys
    {
        key(PK; "Unit Id") { Clustered = true; }
        key(Monitor; "Source Company", "Partner Rule Code", "Period Start", Status) { }
    }
}

table 50112 "ICR Reconciliation Result"
{
    Caption = 'Intercompany Recharge Reconciliation Result';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Request No."; Code[20]) { Caption = 'Request No.'; DataClassification = CustomerContent; TableRelation = "ICR Recharge Request"."No."; }
        field(2; "Source Company"; Code[30]) { Caption = 'Source Company'; DataClassification = CustomerContent; }
        field(3; "IC Partner Code"; Code[20]) { Caption = 'IC Partner Code'; DataClassification = CustomerContent; }
        field(4; "Period Start"; Date) { Caption = 'Period Start'; DataClassification = CustomerContent; }
        field(5; "Recharge Type"; Code[20]) { Caption = 'Recharge Type'; DataClassification = CustomerContent; }
        field(6; "Source Currency Code"; Code[10]) { Caption = 'Source Currency Code'; DataClassification = CustomerContent; }
        field(7; "Target Currency Code"; Code[10]) { Caption = 'Target Currency Code'; DataClassification = CustomerContent; }
        field(8; "Source Amount"; Decimal) { Caption = 'Source Amount'; DataClassification = CustomerContent; }
        field(9; "Allocation Amount"; Decimal) { Caption = 'Allocation Amount'; DataClassification = CustomerContent; }
        field(10; "Posted Amount"; Decimal) { Caption = 'Posted Amount'; DataClassification = CustomerContent; }
        field(11; "Rounding Adjustment"; Decimal) { Caption = 'Rounding Adjustment'; DataClassification = CustomerContent; }
        field(12; "Posting Reference"; Code[50]) { Caption = 'Posting Reference'; DataClassification = CustomerContent; }
        field(13; "Partner Response"; Enum "ICR Partner Response Status") { Caption = 'Partner Response'; DataClassification = CustomerContent; }
        field(14; Balanced; Boolean) { Caption = 'Balanced'; DataClassification = CustomerContent; }
        field(15; "Result Message"; Text[250]) { Caption = 'Result Message'; DataClassification = CustomerContent; }
        field(16; "Calculated At"; DateTime) { Caption = 'Calculated At'; DataClassification = SystemMetadata; }
    }

    keys
    {
        key(PK; "Request No.") { Clustered = true; }
        key(Filters; "Source Company", "IC Partner Code", "Period Start", "Recharge Type", Balanced) { }
    }
}
