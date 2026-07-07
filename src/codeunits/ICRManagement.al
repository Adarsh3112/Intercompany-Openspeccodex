codeunit 50100 "ICR Audit Mgt."
{
    procedure LogEvent(RequestNo: Code[20]; EventType: Code[30]; OldValue: Text[100]; NewValue: Text[100]; ReasonCode: Code[20]; Details: Text[250])
    var
        AuditEvent: Record "ICR Recharge Audit Event";
    begin
        AuditEvent.Init();
        AuditEvent."Request No." := RequestNo;
        AuditEvent."Event Type" := EventType;
        AuditEvent."Old Value" := OldValue;
        AuditEvent."New Value" := NewValue;
        AuditEvent."Reason Code" := ReasonCode;
        AuditEvent."User ID" := CopyStr(UserId(), 1, MaxStrLen(AuditEvent."User ID"));
        AuditEvent."Created At" := CurrentDateTime();
        AuditEvent."Company" := CopyStr(CompanyName(), 1, MaxStrLen(AuditEvent."Company"));
        AuditEvent.Details := Details;
        AuditEvent.Insert(true);
    end;

    procedure AddException(RequestNo: Code[20]; PartnerRuleCode: Code[20]; ExceptionType: Code[30]; Severity: Enum "ICR Exception Severity"; MessageText: Text[250]; OwnerRole: Code[30]; RetryEligible: Boolean)
    var
        ExceptionEntry: Record "ICR Recharge Exception";
    begin
        ExceptionEntry.Init();
        ExceptionEntry."Request No." := RequestNo;
        ExceptionEntry."Partner Rule Code" := PartnerRuleCode;
        ExceptionEntry."Exception Type" := ExceptionType;
        ExceptionEntry.Severity := Severity;
        ExceptionEntry.Message := MessageText;
        ExceptionEntry."Owner Role" := OwnerRole;
        ExceptionEntry."Retry Eligible" := RetryEligible;
        ExceptionEntry."Created At" := CurrentDateTime();
        ExceptionEntry.Insert(true);
    end;
}

codeunit 50101 "ICR Recharge Mgt."
{
    procedure ValidateSetup(var Setup: Record "ICR Recharge Setup")
    begin
        Clear(Setup."Last Validation Message");
        if Setup."Source Company" = '' then
            Setup."Last Validation Message" := 'Source Company is required.';
        if Setup."Request Nos." = '' then
            AppendMessage(Setup."Last Validation Message", 'Request Nos. is required.');

        Setup."Setup Valid" := Setup."Last Validation Message" = '';
        Setup.Modify(true);
    end;

    procedure CreateManualRequest(SourceCompany: Code[30]; RechargeType: Code[20]; CostPool: Code[20]; SourceAccount: Code[20]; CurrencyCode: Code[10]; Amount: Decimal; Description: Text[100]): Code[20]
    var
        Request: Record "ICR Recharge Request";
        SourceLine: Record "ICR Recharge Source Line";
        AuditMgt: Codeunit "ICR Audit Mgt.";
    begin
        Request.Init();
        Request."Source Company" := SourceCompany;
        Request."Recharge Type" := RechargeType;
        Request."Cost Pool" := CostPool;
        Request."Source G/L Account" := SourceAccount;
        Request."Currency Code" := CurrencyCode;
        Request."Period Start" := WorkDate();
        Request."Period End" := WorkDate();
        Request.Insert(true);

        SourceLine.Init();
        SourceLine."Request No." := Request."No.";
        SourceLine.Description := Description;
        SourceLine.Amount := Amount;
        SourceLine."Currency Code" := CurrencyCode;
        SourceLine."Source G/L Account" := SourceAccount;
        SourceLine.Insert(true);

        UpdateRequestTotals(Request."No.");
        AuditMgt.LogEvent(Request."No.", 'CREATE', '', Format(Request.Status), '', 'Draft recharge request created.');
        exit(Request."No.");
    end;

    procedure ValidateRequest(RequestNo: Code[20])
    var
        Request: Record "ICR Recharge Request";
        Setup: Record "ICR Recharge Setup";
        Rule: Record "ICR Partner Rule";
        SourceLine: Record "ICR Recharge Source Line";
        DimRule: Record "ICR Dimension Rule";
        AuditMgt: Codeunit "ICR Audit Mgt.";
        HasError: Boolean;
    begin
        Request.Get(RequestNo);
        EnsureCanEdit(Request);
        if not (Request.Status in [Request.Status::Draft, Request.Status::Rejected]) then
            Error('Request %1 cannot be validated from status %2.', Request."No.", Request.Status);

        if not Setup.Get('SETUP') then begin
            HasError := true;
            AuditMgt.AddException(Request."No.", '', 'SETUP', "ICR Exception Severity"::Blocking, 'Recharge setup does not exist.', 'ADMIN', false);
        end else begin
            ValidateSetup(Setup);
            if not Setup."Setup Valid" then begin
                HasError := true;
                AuditMgt.AddException(Request."No.", '', 'SETUP', "ICR Exception Severity"::Blocking, Setup."Last Validation Message", 'ADMIN', false);
            end;
        end;

        SourceLine.SetRange("Request No.", Request."No.");
        if SourceLine.IsEmpty() then begin
            HasError := true;
            AuditMgt.AddException(Request."No.", '', 'SOURCE', "ICR Exception Severity"::Blocking, 'At least one source line is required.', 'ANALYST', false);
        end;

        if not ResolveRule(Request, Rule) then begin
            HasError := true;
            AuditMgt.AddException(Request."No.", '', 'MAPPING', "ICR Exception Severity"::Blocking, 'No active partner rule maps the source company, recharge type, cost pool, and source account.', 'ADMIN', false);
        end else begin
            if Rule."IC Partner Code" = '' then begin
                HasError := true;
                AuditMgt.AddException(Request."No.", Rule."Rule Code", 'PARTNER', "ICR Exception Severity"::Blocking, 'IC partner mapping is missing.', 'ADMIN', false);
            end;
            if Rule."Target IC G/L Account" = '' then begin
                HasError := true;
                AuditMgt.AddException(Request."No.", Rule."Rule Code", 'ACCOUNT', "ICR Exception Severity"::Blocking, 'Target IC G/L account is missing.', 'ADMIN', false);
            end;
            if Rule."Source G/L Account" = '' then begin
                HasError := true;
                AuditMgt.AddException(Request."No.", Rule."Rule Code", 'ACCOUNT', "ICR Exception Severity"::Blocking, 'Source G/L account is missing on the partner rule.', 'ADMIN', false);
            end;
            if (Rule."Source Currency Code" <> '') and (Rule."Target Currency Code" <> '') and (Rule."Source Currency Code" <> Rule."Target Currency Code") and (Rule."Exchange Rate" = 0) then begin
                HasError := true;
                AuditMgt.AddException(Request."No.", Rule."Rule Code", 'CURRENCY', "ICR Exception Severity"::Blocking, 'Exchange rate is required for different source and target currencies.', 'ADMIN', true);
            end;
            if Rule."Dimension Rule Code" <> '' then
                if not DimRule.Get(Rule."Dimension Rule Code", DimRule.Direction::Outbound, '', '') then begin
                    HasError := true;
                    AuditMgt.AddException(Request."No.", Rule."Rule Code", 'DIMENSION', "ICR Exception Severity"::Blocking, 'Required dimension translation is missing.', 'ADMIN', true);
                end;
            if Rule."Auto-Accept" and Rule."Manual Review Required" then begin
                HasError := true;
                AuditMgt.AddException(Request."No.", Rule."Rule Code", 'AUTOACCEPT', "ICR Exception Severity"::Blocking, 'Auto-accept is enabled where manual review is required.', 'ADMIN', false);
            end;
        end;

        if HasError then begin
            Request."Exception Flag" := true;
            Request."Last Error" := 'Validation failed; review exception entries.';
            Request.Modify(true);
            AuditMgt.LogEvent(Request."No.", 'VALIDATE_FAIL', Format(Request.Status), Format(Request.Status), '', Request."Last Error");
            Error(Request."Last Error");
        end;

        Request.Status := Request.Status::Validated;
        Request."Exception Flag" := false;
        Request."Last Error" := '';
        Request.Modify(true);
        AuditMgt.LogEvent(Request."No.", 'VALIDATE', 'Draft', Format(Request.Status), '', 'Request validation completed.');
    end;

    procedure CalculateRequest(RequestNo: Code[20]; Simulation: Boolean)
    var
        Request: Record "ICR Recharge Request";
        SourceLine: Record "ICR Recharge Source Line";
        Rule: Record "ICR Partner Rule";
        AllocationLine: Record "ICR Recharge Allocation Line";
        AuditMgt: Codeunit "ICR Audit Mgt.";
        TotalAllocated: Decimal;
        TotalSource: Decimal;
    begin
        Request.Get(RequestNo);
        EnsureCanEdit(Request);
        if not (Request.Status in [Request.Status::Validated, Request.Status::"Pending Approval", Request.Status::Rejected]) then
            Error('Request %1 must be Validated before calculation.', Request."No.");

        if not ResolveRule(Request, Rule) then
            Error('No partner rule can be resolved for request %1.', Request."No.");

        AllocationLine.SetRange("Request No.", Request."No.");
        AllocationLine.DeleteAll(true);

        SourceLine.SetRange("Request No.", Request."No.");
        if SourceLine.FindSet() then
            repeat
                TotalSource += SourceLine.Amount;
                InsertAllocationLine(Request, SourceLine, Rule, AllocationLine);
                TotalAllocated += AllocationLine."Allocation Amount";
            until SourceLine.Next() = 0;

        if TotalAllocated > TotalSource then begin
            AuditMgt.AddException(Request."No.", Rule."Rule Code", 'ALLOCATION', "ICR Exception Severity"::Blocking, 'Allocation amount exceeds source amount.', 'MANAGER', false);
            Error('Allocation amount exceeds source amount for request %1.', Request."No.");
        end;

        Request."Total Source Amount" := TotalSource;
        Request."Total Allocation Amount" := TotalAllocated;
        Request."Approval Required" := (Rule."Approval Threshold" <> 0) and (Abs(TotalAllocated) > Rule."Approval Threshold");
        Request."Manual Review Required" := Rule."Manual Review Required";
        Request.Modify(true);
        if Simulation then
            AuditMgt.LogEvent(Request."No.", 'SIMULATE', '', Format(TotalAllocated), '', 'Simulation calculated without financial output.')
        else
            AuditMgt.LogEvent(Request."No.", 'CALCULATE', '', Format(TotalAllocated), '', 'Allocation calculation completed.');
    end;

    procedure SubmitForApproval(RequestNo: Code[20])
    var
        Request: Record "ICR Recharge Request";
        AuditMgt: Codeunit "ICR Audit Mgt.";
    begin
        Request.Get(RequestNo);
        if Request.Status <> Request.Status::Validated then
            Error('Only validated requests can be submitted for approval.');
        Request.Status := Request.Status::"Pending Approval";
        Request.Modify(true);
        InsertApprovalHistory(Request, 'SUBMIT', 'Submitted for approval.');
        AuditMgt.LogEvent(Request."No.", 'SUBMIT', 'Validated', Format(Request.Status), '', 'Request submitted for approval.');
    end;

    procedure ApproveRequest(RequestNo: Code[20]; Comment: Text[250])
    var
        Request: Record "ICR Recharge Request";
        AuditMgt: Codeunit "ICR Audit Mgt.";
    begin
        Request.Get(RequestNo);
        if not (Request.Status in [Request.Status::Validated, Request.Status::"Pending Approval"]) then
            Error('Request %1 is not ready for approval.', Request."No.");
        if Request."Requested By" = CopyStr(UserId(), 1, MaxStrLen(Request."Requested By")) then begin
            AuditMgt.AddException(Request."No.", '', 'SOD', "ICR Exception Severity"::Blocking, 'Self-approval is not allowed.', 'MANAGER', false);
            AuditMgt.LogEvent(Request."No.", 'AUTH_FAIL', Format(Request.Status), Format(Request.Status), '', 'Self-approval denied.');
            Error('Self-approval is not allowed for request %1.', Request."No.");
        end;
        Request.Status := Request.Status::Approved;
        Request."Approved By" := CopyStr(UserId(), 1, MaxStrLen(Request."Approved By"));
        Request.Locked := true;
        Request.Modify(true);
        InsertApprovalHistory(Request, 'APPROVE', Comment);
        AuditMgt.LogEvent(Request."No.", 'APPROVE', 'Pending Approval', Format(Request.Status), '', Comment);
    end;

    procedure RejectRequest(RequestNo: Code[20]; Reason: Text[250])
    var
        Request: Record "ICR Recharge Request";
        AuditMgt: Codeunit "ICR Audit Mgt.";
    begin
        Request.Get(RequestNo);
        if not (Request.Status in [Request.Status::Validated, Request.Status::"Pending Approval", Request.Status::Approved]) then
            Error('Request %1 cannot be rejected from status %2.', Request."No.", Request.Status);
        Request.Status := Request.Status::Rejected;
        Request."Rejected By" := CopyStr(UserId(), 1, MaxStrLen(Request."Rejected By"));
        Request."Rejection Reason" := Reason;
        Request.Locked := false;
        Request.Modify(true);
        InsertApprovalHistory(Request, 'REJECT', Reason);
        AuditMgt.LogEvent(Request."No.", 'REJECT', '', Format(Request.Status), '', Reason);
    end;

    procedure ResubmitRequest(RequestNo: Code[20])
    var
        Request: Record "ICR Recharge Request";
        AuditMgt: Codeunit "ICR Audit Mgt.";
    begin
        Request.Get(RequestNo);
        if Request.Status <> Request.Status::Rejected then
            Error('Only rejected requests can be resubmitted.');
        Request."Rejection Reason" := '';
        Request.Status := Request.Status::Draft;
        Request.Modify(true);
        InsertApprovalHistory(Request, 'RESUBMIT', 'Request resubmitted after correction.');
        AuditMgt.LogEvent(Request."No.", 'RESUBMIT', 'Rejected', Format(Request.Status), '', 'Request resubmitted.');
    end;

    procedure PostRequest(RequestNo: Code[20])
    var
        Request: Record "ICR Recharge Request";
        AllocationLine: Record "ICR Recharge Allocation Line";
        Rule: Record "ICR Partner Rule";
        AuditMgt: Codeunit "ICR Audit Mgt.";
        PostedAmount: Decimal;
    begin
        Request.Get(RequestNo);
        if Request.Status <> Request.Status::Approved then begin
            AuditMgt.LogEvent(Request."No.", 'AUTH_FAIL', Format(Request.Status), Format(Request.Status), '', 'Posting denied because request is not approved.');
            Error('Only approved requests can be posted.');
        end;
        if not ResolveRule(Request, Rule) then
            Error('No partner rule can be resolved for request %1.', Request."No.");
        if Rule."Auto-Accept" and Rule."Manual Review Required" then
            Error('Auto-accept is not allowed where manual review is required.');

        AllocationLine.SetRange("Request No.", Request."No.");
        if AllocationLine.FindSet() then
            repeat
                PostedAmount += PostAllocation(Request, AllocationLine, Rule, "ICR Correction Type"::None);
            until AllocationLine.Next() = 0
        else
            Error('No allocation lines exist for request %1.', Request."No.");

        Request.Status := Request.Status::Posted;
        Request."Posted By" := CopyStr(UserId(), 1, MaxStrLen(Request."Posted By"));
        Request."Posted Amount" := PostedAmount;
        Request.Locked := true;
        Request.Modify(true);
        AuditMgt.LogEvent(Request."No.", 'POST', 'Approved', Format(Request.Status), '', 'Intercompany output references generated.');
    end;

    procedure ProcessPartnerResponse(RequestNo: Code[20]; AllocationLineNo: Integer; NewStatus: Enum "ICR Partner Response Status"; InboxTransactionId: Code[50]; Reason: Text[250])
    var
        AllocationLine: Record "ICR Recharge Allocation Line";
        PostingLink: Record "ICR Recharge Posting Link";
        AuditMgt: Codeunit "ICR Audit Mgt.";
    begin
        AllocationLine.Get(RequestNo, AllocationLineNo);
        AllocationLine."Response Status" := NewStatus;
        AllocationLine.Modify(true);

        PostingLink.SetRange("Request No.", RequestNo);
        PostingLink.SetRange("Allocation Line No.", AllocationLineNo);
        if PostingLink.FindFirst() then begin
            PostingLink."Inbox Transaction Id" := InboxTransactionId;
            PostingLink.Modify(true);
        end;

        if NewStatus in [NewStatus::Rejected, NewStatus::"Correction Required"] then
            AuditMgt.AddException(RequestNo, AllocationLine."Partner Rule Code", 'PARTNER_RESPONSE', "ICR Exception Severity"::Error, Reason, 'POSTER', true);
        AuditMgt.LogEvent(RequestNo, 'INBOX', '', Format(NewStatus), '', Reason);
    end;

    procedure ReverseRequest(RequestNo: Code[20]; ReasonCode: Code[20])
    var
        Request: Record "ICR Recharge Request";
        AllocationLine: Record "ICR Recharge Allocation Line";
        Rule: Record "ICR Partner Rule";
        AuditMgt: Codeunit "ICR Audit Mgt.";
    begin
        Request.Get(RequestNo);
        if ReasonCode = '' then
            Error('Reason code is required for reversal.');
        if Request.Status = Request.Status::Reversed then
            Error('Request %1 has already been reversed.', Request."No.");
        if Request.Status <> Request.Status::Posted then
            Error('Only posted requests can be reversed.');
        if not ResolveRule(Request, Rule) then
            Error('No partner rule can be resolved for request %1.', Request."No.");

        AllocationLine.SetRange("Request No.", Request."No.");
        if AllocationLine.FindSet() then
            repeat
                PostAllocation(Request, AllocationLine, Rule, "ICR Correction Type"::Reversal);
                AllocationLine."Response Status" := AllocationLine."Response Status"::Reversed;
                AllocationLine.Modify(true);
            until AllocationLine.Next() = 0;

        Request.Status := Request.Status::Reversed;
        Request."Reversal Reason" := ReasonCode;
        Request.Locked := true;
        Request.Modify(true);
        AuditMgt.LogEvent(Request."No.", 'REVERSE', 'Posted', Format(Request.Status), ReasonCode, 'Full reversal generated.');
    end;

    procedure CorrectAllocation(RequestNo: Code[20]; AllocationLineNo: Integer; CorrectedAmount: Decimal; ReasonCode: Code[20])
    var
        Request: Record "ICR Recharge Request";
        AllocationLine: Record "ICR Recharge Allocation Line";
        Rule: Record "ICR Partner Rule";
        DeltaAmount: Decimal;
        AuditMgt: Codeunit "ICR Audit Mgt.";
    begin
        Request.Get(RequestNo);
        if ReasonCode = '' then
            Error('Reason code is required for correction.');
        if not (Request.Status in [Request.Status::Posted, Request.Status::Reversed]) then
            Error('Only posted or reversed requests can be corrected.');
        AllocationLine.Get(RequestNo, AllocationLineNo);
        DeltaAmount := CorrectedAmount - AllocationLine."Allocation Amount";
        if DeltaAmount = 0 then
            Error('Correction delta is zero.');
        if not ResolveRule(Request, Rule) then
            Error('No partner rule can be resolved for request %1.', Request."No.");

        AllocationLine."Allocation Amount" := CorrectedAmount;
        AllocationLine."Target Amount" := Round(CorrectedAmount * AllocationLine."Exchange Rate", 0.01);
        AllocationLine."Override Reason" := ReasonCode;
        AllocationLine."Manual Override" := true;
        AllocationLine."Calculation Trace" := CopyStr('Correction delta ' + Format(DeltaAmount), 1, MaxStrLen(AllocationLine."Calculation Trace"));
        AllocationLine.Modify(true);

        PostAllocation(Request, AllocationLine, Rule, "ICR Correction Type"::Correction);
        Request."Correction Reason" := ReasonCode;
        Request.Modify(true);
        AuditMgt.LogEvent(Request."No.", 'CORRECT', '', Format(CorrectedAmount), ReasonCode, 'Correction output generated.');
    end;

    procedure ReconcileRequest(RequestNo: Code[20])
    var
        Request: Record "ICR Recharge Request";
        AllocationLine: Record "ICR Recharge Allocation Line";
        PostingLink: Record "ICR Recharge Posting Link";
        Recon: Record "ICR Reconciliation Result";
        AuditMgt: Codeunit "ICR Audit Mgt.";
        AllocationAmount: Decimal;
        PostedAmount: Decimal;
        Residual: Decimal;
        Balanced: Boolean;
    begin
        Request.Get(RequestNo);
        AllocationLine.SetRange("Request No.", Request."No.");
        if AllocationLine.FindSet() then
            repeat
                AllocationAmount += AllocationLine."Allocation Amount";
                Residual += AllocationLine."Rounding Residual";
            until AllocationLine.Next() = 0;
        PostingLink.SetRange("Request No.", Request."No.");
        PostingLink.SetRange(Posted, true);
        if PostingLink.FindSet() then
            repeat
                PostedAmount += PostingLink.Amount;
            until PostingLink.Next() = 0;

        Balanced := (Abs(Request."Total Source Amount" - AllocationAmount) <= GetRoundingTolerance()) and (PostedAmount <> 0);
        if Recon.Get(Request."No.") then
            Recon.Delete(true);
        Recon.Init();
        Recon."Request No." := Request."No.";
        Recon."Source Company" := Request."Source Company";
        Recon."Period Start" := Request."Period Start";
        Recon."Recharge Type" := Request."Recharge Type";
        Recon."Source Currency Code" := Request."Currency Code";
        Recon."Source Amount" := Request."Total Source Amount";
        Recon."Allocation Amount" := AllocationAmount;
        Recon."Posted Amount" := PostedAmount;
        Recon."Rounding Adjustment" := Residual;
        if PostingLink.FindFirst() then begin
            Recon."Posting Reference" := PostingLink."Document No.";
            Recon."IC Partner Code" := GetPartnerFromAllocation(Request."No.");
        end;
        Recon.Balanced := Balanced;
        if Balanced then
            Recon."Result Message" := 'Balanced'
        else begin
            Recon."Result Message" := 'Mismatch';
            AuditMgt.AddException(Request."No.", '', 'RECONCILIATION', "ICR Exception Severity"::Error, 'Reconciliation mismatch detected.', 'POSTER', true);
        end;
        Recon."Calculated At" := CurrentDateTime();
        Recon.Insert(true);

        Request."Reconciliation Status" := CopyStr(Recon."Result Message", 1, MaxStrLen(Request."Reconciliation Status"));
        Request.Modify(true);
        AuditMgt.LogEvent(Request."No.", 'RECONCILE', '', Recon."Result Message", '', 'Reconciliation calculated.');
    end;

    procedure GenerateScheduledRequest(SourceCompany: Code[30]; RechargeType: Code[20]; CostPool: Code[20]; PartnerRuleCode: Code[20]; PeriodStart: Date; PeriodEnd: Date): Code[20]
    var
        Rule: Record "ICR Partner Rule";
        ProcessingUnit: Record "ICR Processing Unit";
        UnitId: Code[100];
    begin
        UnitId := BuildProcessingUnitId(SourceCompany, RechargeType, PartnerRuleCode, PeriodStart);
        if ProcessingUnit.Get(UnitId) then
            if ProcessingUnit.Status = ProcessingUnit.Status::Completed then
                exit(ProcessingUnit."Request No.");

        if not ProcessingUnit.Get(UnitId) then begin
            ProcessingUnit.Init();
            ProcessingUnit."Unit Id" := UnitId;
            ProcessingUnit."Source Company" := SourceCompany;
            ProcessingUnit."Recharge Type" := RechargeType;
            ProcessingUnit."Partner Rule Code" := PartnerRuleCode;
            ProcessingUnit."Period Start" := PeriodStart;
            ProcessingUnit."Period End" := PeriodEnd;
            ProcessingUnit.Status := ProcessingUnit.Status::Pending;
            ProcessingUnit."Created At" := CurrentDateTime();
            ProcessingUnit.Insert(true);
        end;

        Rule.Get(PartnerRuleCode);
        ProcessingUnit.Status := ProcessingUnit.Status::Running;
        ProcessingUnit."Updated At" := CurrentDateTime();
        ProcessingUnit.Modify(true);
        ProcessingUnit."Request No." := CreateManualRequest(SourceCompany, RechargeType, CostPool, Rule."Source G/L Account", Rule."Source Currency Code", Rule."Allocation Amount", 'Scheduled recharge');
        ProcessingUnit.Status := ProcessingUnit.Status::Completed;
        ProcessingUnit."Updated At" := CurrentDateTime();
        ProcessingUnit.Modify(true);
        exit(ProcessingUnit."Request No.");
    end;

    procedure RetryProcessingUnit(UnitId: Code[100])
    var
        ProcessingUnit: Record "ICR Processing Unit";
    begin
        ProcessingUnit.Get(UnitId);
        if ProcessingUnit.Status = ProcessingUnit.Status::Completed then
            exit;
        ProcessingUnit."Retry Count" += 1;
        ProcessingUnit.Status := ProcessingUnit.Status::Retried;
        ProcessingUnit."Updated At" := CurrentDateTime();
        ProcessingUnit.Modify(true);
    end;

    procedure ExportAudit(RequestNo: Code[20])
    var
        AuditMgt: Codeunit "ICR Audit Mgt.";
    begin
        AuditMgt.LogEvent(RequestNo, 'EXPORT', '', '', '', 'Audit and reconciliation export requested.');
    end;

    local procedure InsertAllocationLine(Request: Record "ICR Recharge Request"; SourceLine: Record "ICR Recharge Source Line"; Rule: Record "ICR Partner Rule"; var AllocationLine: Record "ICR Recharge Allocation Line")
    var
        DriverShare: Decimal;
        TargetAmount: Decimal;
    begin
        AllocationLine.Init();
        AllocationLine."Request No." := Request."No.";
        AllocationLine."Source Line No." := SourceLine."Line No.";
        AllocationLine."Partner Rule Code" := Rule."Rule Code";
        AllocationLine."IC Partner Code" := Rule."IC Partner Code";
        AllocationLine."Target Company" := Rule."Target Company";
        AllocationLine."Allocation Basis" := Rule."Allocation Basis";
        AllocationLine."Source Amount" := SourceLine.Amount;
        AllocationLine."Source Currency Code" := SourceLine."Currency Code";
        AllocationLine."Target Currency Code" := Rule."Target Currency Code";
        AllocationLine."Exchange Rate" := Rule."Exchange Rate";
        if AllocationLine."Exchange Rate" = 0 then
            AllocationLine."Exchange Rate" := 1;
        AllocationLine."Rate Date" := WorkDate();
        AllocationLine."Target IC G/L Account" := Rule."Target IC G/L Account";
        AllocationLine."Response Status" := AllocationLine."Response Status"::Pending;

        case Rule."Allocation Basis" of
            Rule."Allocation Basis"::"Fixed Percentage":
                begin
                    AllocationLine."Allocation Percent" := Rule."Allocation Percent";
                    AllocationLine."Allocation Amount" := Round(SourceLine.Amount * Rule."Allocation Percent" / 100, 0.01);
                    AllocationLine."Calculation Trace" := CopyStr('Fixed percent ' + Format(Rule."Allocation Percent") + '% of ' + Format(SourceLine.Amount), 1, MaxStrLen(AllocationLine."Calculation Trace"));
                end;
            Rule."Allocation Basis"::Amount:
                begin
                    AllocationLine."Allocation Amount" := Rule."Allocation Amount";
                    AllocationLine."Allocation Percent" := Round(AllocationLine."Allocation Amount" / SourceLine.Amount * 100, 0.00001);
                    AllocationLine."Calculation Trace" := CopyStr('Configured amount ' + Format(Rule."Allocation Amount"), 1, MaxStrLen(AllocationLine."Calculation Trace"));
                end;
            Rule."Allocation Basis"::Driver:
                begin
                    DriverShare := GetDriverShare(Rule."Driver Code", Request."Period Start", Rule."Rule Code");
                    AllocationLine."Driver Quantity" := DriverShare;
                    AllocationLine."Allocation Percent" := Round(DriverShare * 100, 0.00001);
                    AllocationLine."Allocation Amount" := Round(SourceLine.Amount * DriverShare, 0.01);
                    AllocationLine."Calculation Trace" := CopyStr('Driver share ' + Format(DriverShare), 1, MaxStrLen(AllocationLine."Calculation Trace"));
                end;
            Rule."Allocation Basis"::Dimension:
                begin
                    AllocationLine."Allocation Percent" := Rule."Allocation Percent";
                    AllocationLine."Allocation Amount" := Round(SourceLine.Amount * Rule."Allocation Percent" / 100, 0.01);
                    AllocationLine."Calculation Trace" := CopyStr('Dimension-driven using rule ' + Rule."Dimension Rule Code", 1, MaxStrLen(AllocationLine."Calculation Trace"));
                end;
            Rule."Allocation Basis"::Manual:
                begin
                    AllocationLine."Allocation Amount" := Rule."Allocation Amount";
                    AllocationLine."Manual Override" := true;
                    AllocationLine."Override Reason" := 'MANUAL';
                    AllocationLine."Calculation Trace" := 'Manual configured basis';
                end;
        end;

        TargetAmount := Round(AllocationLine."Allocation Amount" * AllocationLine."Exchange Rate", 0.01);
        AllocationLine."Target Amount" := TargetAmount;
        AllocationLine."Rounding Residual" := (AllocationLine."Allocation Amount" * AllocationLine."Exchange Rate") - TargetAmount;
        AllocationLine."Idempotency Key" := BuildAllocationKey(Request."No.", Rule."Rule Code", SourceLine."Line No.");
        AllocationLine.Insert(true);
    end;

    local procedure PostAllocation(Request: Record "ICR Recharge Request"; AllocationLine: Record "ICR Recharge Allocation Line"; Rule: Record "ICR Partner Rule"; CorrectionType: Enum "ICR Correction Type"): Decimal
    var
        PostingLink: Record "ICR Recharge Posting Link";
        IdempotencyKey: Code[100];
    begin
        IdempotencyKey := BuildPostingKey(Request."No.", AllocationLine."Line No.", CorrectionType);
        PostingLink.SetRange("Idempotency Key", IdempotencyKey);
        if PostingLink.FindFirst() then
            exit(PostingLink.Amount);

        PostingLink.Init();
        PostingLink."Request No." := Request."No.";
        PostingLink."Allocation Line No." := AllocationLine."Line No.";
        PostingLink."Posting Method" := RuleToPostingMethod(Rule);
        PostingLink."Document No." := CopyStr(Request."No." + '-' + Format(AllocationLine."Line No."), 1, MaxStrLen(PostingLink."Document No."));
        PostingLink.Amount := AllocationLine."Allocation Amount";
        if CorrectionType = CorrectionType::Reversal then
            PostingLink.Amount := -PostingLink.Amount;
        PostingLink."Target Amount" := AllocationLine."Target Amount";
        if CorrectionType = CorrectionType::Reversal then
            PostingLink."Target Amount" := -PostingLink."Target Amount";
        PostingLink."Currency Code" := AllocationLine."Target Currency Code";
        PostingLink."Idempotency Key" := IdempotencyKey;
        PostingLink.Posted := true;
        PostingLink."Correction Type" := CorrectionType;
        if Rule."Auto-Send" then
            PostingLink."Outbox Transaction Id" := CopyStr('OUT-' + IdempotencyKey, 1, MaxStrLen(PostingLink."Outbox Transaction Id"));
        PostingLink.Insert(true);

        if Rule."Auto-Send" then
            AllocationLine."Response Status" := AllocationLine."Response Status"::Sent;
        AllocationLine.Modify(true);
        exit(PostingLink.Amount);
    end;

    local procedure ResolveRule(Request: Record "ICR Recharge Request"; var Rule: Record "ICR Partner Rule"): Boolean
    begin
        Rule.Reset();
        Rule.SetRange("Source Company", Request."Source Company");
        Rule.SetRange("Recharge Type", Request."Recharge Type");
        Rule.SetRange("Cost Pool", Request."Cost Pool");
        Rule.SetRange("Source G/L Account", Request."Source G/L Account");
        Rule.SetRange(Active, true);
        if Rule.FindFirst() then begin
            if (Rule."Effective Start Date" <> 0D) and (Request."Period Start" < Rule."Effective Start Date") then
                exit(false);
            if (Rule."Effective End Date" <> 0D) and (Request."Period Start" > Rule."Effective End Date") then
                exit(false);
            exit(true);
        end;
        exit(false);
    end;

    local procedure UpdateRequestTotals(RequestNo: Code[20])
    var
        Request: Record "ICR Recharge Request";
        SourceLine: Record "ICR Recharge Source Line";
        TotalAmount: Decimal;
    begin
        Request.Get(RequestNo);
        SourceLine.SetRange("Request No.", RequestNo);
        if SourceLine.FindSet() then
            repeat
                TotalAmount += SourceLine.Amount;
            until SourceLine.Next() = 0;
        Request."Total Source Amount" := TotalAmount;
        Request.Modify(true);
    end;

    local procedure EnsureCanEdit(Request: Record "ICR Recharge Request")
    begin
        if Request.Locked then
            Error('Request %1 is locked.', Request."No.");
    end;

    local procedure InsertApprovalHistory(Request: Record "ICR Recharge Request"; ActionCode: Code[30]; CommentText: Text[250])
    var
        ApprovalHistory: Record "ICR Approval History";
    begin
        ApprovalHistory.Init();
        ApprovalHistory."Request No." := Request."No.";
        ApprovalHistory.Action := ActionCode;
        ApprovalHistory."Actor User ID" := CopyStr(UserId(), 1, MaxStrLen(ApprovalHistory."Actor User ID"));
        ApprovalHistory.Comment := CommentText;
        ApprovalHistory."Resulting Status" := Request.Status;
        ApprovalHistory."Created At" := CurrentDateTime();
        ApprovalHistory.Insert(true);
    end;

    local procedure GetDriverShare(DriverCode: Code[20]; PeriodStart: Date; PartnerRuleCode: Code[20]): Decimal
    var
        DriverValue: Record "ICR Driver Value";
        PartnerQuantity: Decimal;
        TotalQuantity: Decimal;
    begin
        if DriverCode = '' then
            exit(0);
        DriverValue.SetRange("Driver Code", DriverCode);
        DriverValue.SetRange("Period Start", PeriodStart);
        if DriverValue.FindSet() then
            repeat
                TotalQuantity += DriverValue.Quantity;
                if DriverValue."Partner Rule Code" = PartnerRuleCode then
                    PartnerQuantity := DriverValue.Quantity;
            until DriverValue.Next() = 0;
        if TotalQuantity = 0 then
            exit(0);
        exit(PartnerQuantity / TotalQuantity);
    end;

    local procedure GetRoundingTolerance(): Decimal
    var
        Setup: Record "ICR Recharge Setup";
    begin
        if Setup.Get('SETUP') then
            exit(Setup."Rounding Tolerance");
        exit(0.01);
    end;

    local procedure GetPartnerFromAllocation(RequestNo: Code[20]): Code[20]
    var
        AllocationLine: Record "ICR Recharge Allocation Line";
    begin
        AllocationLine.SetRange("Request No.", RequestNo);
        if AllocationLine.FindFirst() then
            exit(AllocationLine."IC Partner Code");
        exit('');
    end;

    local procedure BuildAllocationKey(RequestNo: Code[20]; RuleCode: Code[20]; SourceLineNo: Integer): Code[100]
    begin
        exit(CopyStr(RequestNo + '|ALLOC|' + RuleCode + '|' + Format(SourceLineNo), 1, 100));
    end;

    local procedure BuildPostingKey(RequestNo: Code[20]; AllocationLineNo: Integer; CorrectionType: Enum "ICR Correction Type"): Code[100]
    begin
        exit(CopyStr(RequestNo + '|POST|' + Format(AllocationLineNo) + '|' + Format(CorrectionType), 1, 100));
    end;

    local procedure BuildProcessingUnitId(SourceCompany: Code[30]; RechargeType: Code[20]; PartnerRuleCode: Code[20]; PeriodStart: Date): Code[100]
    begin
        exit(CopyStr(SourceCompany + '|' + RechargeType + '|' + PartnerRuleCode + '|' + Format(PeriodStart, 0, 9), 1, 100));
    end;

    local procedure RuleToPostingMethod(Rule: Record "ICR Partner Rule"): Enum "ICR Posting Method"
    var
        Setup: Record "ICR Recharge Setup";
    begin
        if Setup.Get('SETUP') then
            exit(Setup."Default Posting Method");
        exit("ICR Posting Method"::Journal);
    end;

    local procedure AppendMessage(var MessageText: Text[250]; Addition: Text[250])
    begin
        if MessageText = '' then
            MessageText := Addition
        else
            MessageText := CopyStr(MessageText + ' ' + Addition, 1, MaxStrLen(MessageText));
    end;
}

codeunit 50102 "ICR Recharge Self Tests"
{
    procedure RunAll()
    begin
        TestVerticalSlice();
        TestDuplicatePosting();
        TestManualOverrideRequiresReason();
        TestProcessingRetry();
    end;

    procedure TestVerticalSlice()
    var
        Request: Record "ICR Recharge Request";
        RechargeMgt: Codeunit "ICR Recharge Mgt.";
        RequestNo: Code[20];
    begin
        RequestNo := SeedVerticalSlice('SELFTEST1');
        RechargeMgt.ValidateRequest(RequestNo);
        RechargeMgt.CalculateRequest(RequestNo, false);
        RechargeMgt.SubmitForApproval(RequestNo);
        Request.Get(RequestNo);
        Request."Requested By" := 'OTHER';
        Request.Modify(true);
        RechargeMgt.ApproveRequest(RequestNo, 'self test approval');
        RechargeMgt.PostRequest(RequestNo);
        RechargeMgt.ReconcileRequest(RequestNo);
        Request.Get(RequestNo);
        if Request.Status <> Request.Status::Posted then
            Error('Expected posted request in vertical slice test.');
        if Request."Reconciliation Status" = '' then
            Error('Expected reconciliation status in vertical slice test.');
    end;

    procedure TestDuplicatePosting()
    var
        PostingLink: Record "ICR Recharge Posting Link";
        RechargeMgt: Codeunit "ICR Recharge Mgt.";
        RequestNo: Code[20];
        CountBefore: Integer;
        CountAfter: Integer;
    begin
        RequestNo := SeedPostedRequest('SELFTEST2');
        PostingLink.SetRange("Request No.", RequestNo);
        CountBefore := PostingLink.Count();
        RechargeMgt.PostRequest(RequestNo);
        CountAfter := PostingLink.Count();
        if CountBefore <> CountAfter then
            Error('Duplicate posting prevention failed.');
    end;

    procedure TestManualOverrideRequiresReason()
    var
        AllocationLine: Record "ICR Recharge Allocation Line";
    begin
        AllocationLine.Init();
        AllocationLine."Request No." := 'TEST';
        AllocationLine."Line No." := 10000;
        AllocationLine."Manual Override" := true;
        asserterror AllocationLine.Modify(true);
    end;

    procedure TestProcessingRetry()
    var
        ProcessingUnit: Record "ICR Processing Unit";
        RechargeMgt: Codeunit "ICR Recharge Mgt.";
    begin
        ProcessingUnit.Init();
        ProcessingUnit."Unit Id" := 'SELFTEST-UNIT';
        ProcessingUnit.Status := ProcessingUnit.Status::Failed;
        if not ProcessingUnit.Insert(true) then;
        RechargeMgt.RetryProcessingUnit(ProcessingUnit."Unit Id");
        ProcessingUnit.Get('SELFTEST-UNIT');
        if ProcessingUnit."Retry Count" = 0 then
            Error('Retry count was not incremented.');
    end;

    local procedure SeedPostedRequest(Suffix: Code[10]): Code[20]
    var
        Request: Record "ICR Recharge Request";
        RechargeMgt: Codeunit "ICR Recharge Mgt.";
        RequestNo: Code[20];
    begin
        RequestNo := SeedVerticalSlice(Suffix);
        RechargeMgt.ValidateRequest(RequestNo);
        RechargeMgt.CalculateRequest(RequestNo, false);
        RechargeMgt.SubmitForApproval(RequestNo);
        Request.Get(RequestNo);
        Request."Requested By" := 'OTHER';
        Request.Modify(true);
        RechargeMgt.ApproveRequest(RequestNo, 'self test approval');
        RechargeMgt.PostRequest(RequestNo);
        exit(RequestNo);
    end;

    local procedure SeedVerticalSlice(Suffix: Code[10]): Code[20]
    var
        Setup: Record "ICR Recharge Setup";
        Rule: Record "ICR Partner Rule";
        RechargeMgt: Codeunit "ICR Recharge Mgt.";
    begin
        if not Setup.Get('SETUP') then begin
            Setup.Init();
            Setup."Primary Key" := 'SETUP';
            Setup.Insert(true);
        end;
        Setup."Source Company" := CopyStr(CompanyName(), 1, MaxStrLen(Setup."Source Company"));
        Setup."Request Nos." := 'ICR';
        Setup."Default Posting Method" := Setup."Default Posting Method"::Journal;
        Setup."Default Currency Rule" := Setup."Default Currency Rule"::"Source Currency";
        Setup."Rounding Tolerance" := 0.01;
        Setup.Modify(true);

        if not Rule.Get(Suffix) then begin
            Rule.Init();
            Rule."Rule Code" := Suffix;
            Rule.Insert(true);
        end;
        Rule."Source Company" := Setup."Source Company";
        Rule."Target Company" := 'TARGET';
        Rule."IC Partner Code" := 'ICP';
        Rule."Recharge Type" := 'IT';
        Rule."Cost Pool" := 'POOL';
        Rule."Allocation Basis" := Rule."Allocation Basis"::"Fixed Percentage";
        Rule."Allocation Percent" := 100;
        Rule."Source G/L Account" := '6000';
        Rule."Target IC G/L Account" := '7000';
        Rule."Source Currency Code" := '';
        Rule."Target Currency Code" := '';
        Rule."Exchange Rate" := 1;
        Rule.Active := true;
        Rule.Modify(true);

        exit(RechargeMgt.CreateManualRequest(Setup."Source Company", 'IT', 'POOL', '6000', '', 100, 'Self test'));
    end;
}
