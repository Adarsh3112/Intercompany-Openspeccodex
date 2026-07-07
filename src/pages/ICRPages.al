page 50100 "ICR Recharge Setup"
{
    PageType = Card;
    SourceTable = "ICR Recharge Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Intercompany Recharge Setup';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Primary Key"; Rec."Primary Key") { ApplicationArea = All; ToolTip = 'Specifies the singleton setup key.'; }
                field("Source Company"; Rec."Source Company") { ApplicationArea = All; ToolTip = 'Specifies the source company for recharge processing.'; }
                field("Request Nos."; Rec."Request Nos.") { ApplicationArea = All; ToolTip = 'Specifies the number series used for recharge requests.'; }
                field("Default Posting Method"; Rec."Default Posting Method") { ApplicationArea = All; ToolTip = 'Specifies the default intercompany posting method.'; }
                field("Default Currency Rule"; Rec."Default Currency Rule") { ApplicationArea = All; ToolTip = 'Specifies the default currency handling rule.'; }
                field("Default Approval Threshold"; Rec."Default Approval Threshold") { ApplicationArea = All; ToolTip = 'Specifies the default approval threshold.'; }
                field("Rounding Tolerance"; Rec."Rounding Tolerance") { ApplicationArea = All; ToolTip = 'Specifies the reconciliation rounding tolerance.'; }
                field("Setup Valid"; Rec."Setup Valid") { ApplicationArea = All; ToolTip = 'Specifies whether the setup is valid.'; }
                field("Last Validation Message"; Rec."Last Validation Message") { ApplicationArea = All; ToolTip = 'Specifies the latest setup validation message.'; }
            }
            group(Automation)
            {
                field("Auto-Send Default"; Rec."Auto-Send Default") { ApplicationArea = All; ToolTip = 'Specifies whether auto-send is enabled by default.'; }
                field("Auto-Accept Default"; Rec."Auto-Accept Default") { ApplicationArea = All; ToolTip = 'Specifies whether auto-accept is enabled by default.'; }
                field("Allow Auto Accept Review"; Rec."Allow Auto Accept Review") { ApplicationArea = All; ToolTip = 'Specifies whether reviewed auto-accept is allowed.'; }
                field("Job Queue Enabled"; Rec."Job Queue Enabled") { ApplicationArea = All; ToolTip = 'Specifies whether scheduled recharge jobs are enabled.'; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ValidateSetup)
            {
                Caption = 'Validate Setup';
                ApplicationArea = All;
                Image = TestReport;
                ToolTip = 'Validate the recharge setup.';

                trigger OnAction()
                var
                    RechargeMgt: Codeunit "ICR Recharge Mgt.";
                begin
                    RechargeMgt.ValidateSetup(Rec);
                end;
            }
        }
    }
}

page 50101 "ICR Partner Rules"
{
    PageType = List;
    SourceTable = "ICR Partner Rule";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Intercompany Recharge Partner Rules';

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Rule Code"; Rec."Rule Code") { ApplicationArea = All; ToolTip = 'Specifies the partner rule code.'; }
                field("Source Company"; Rec."Source Company") { ApplicationArea = All; ToolTip = 'Specifies the source company.'; }
                field("Target Company"; Rec."Target Company") { ApplicationArea = All; ToolTip = 'Specifies the target company.'; }
                field("IC Partner Code"; Rec."IC Partner Code") { ApplicationArea = All; ToolTip = 'Specifies the intercompany partner code.'; }
                field("Recharge Type"; Rec."Recharge Type") { ApplicationArea = All; ToolTip = 'Specifies the recharge type.'; }
                field("Cost Pool"; Rec."Cost Pool") { ApplicationArea = All; ToolTip = 'Specifies the cost pool.'; }
                field("Allocation Basis"; Rec."Allocation Basis") { ApplicationArea = All; ToolTip = 'Specifies the allocation basis.'; }
                field("Allocation Percent"; Rec."Allocation Percent") { ApplicationArea = All; ToolTip = 'Specifies the allocation percentage.'; }
                field("Allocation Amount"; Rec."Allocation Amount") { ApplicationArea = All; ToolTip = 'Specifies the allocation amount.'; }
                field("Driver Code"; Rec."Driver Code") { ApplicationArea = All; ToolTip = 'Specifies the driver code.'; }
                field("Source G/L Account"; Rec."Source G/L Account") { ApplicationArea = All; ToolTip = 'Specifies the source G/L account.'; }
                field("Target IC G/L Account"; Rec."Target IC G/L Account") { ApplicationArea = All; ToolTip = 'Specifies the target intercompany G/L account.'; }
                field("Dimension Rule Code"; Rec."Dimension Rule Code") { ApplicationArea = All; ToolTip = 'Specifies the dimension mapping rule.'; }
                field("Currency Rule"; Rec."Currency Rule") { ApplicationArea = All; ToolTip = 'Specifies the currency handling rule.'; }
                field("Exchange Rate"; Rec."Exchange Rate") { ApplicationArea = All; ToolTip = 'Specifies the exchange rate.'; }
                field("Approval Threshold"; Rec."Approval Threshold") { ApplicationArea = All; ToolTip = 'Specifies the approval threshold.'; }
                field("Auto-Send"; Rec."Auto-Send") { ApplicationArea = All; ToolTip = 'Specifies whether output is sent automatically.'; }
                field("Auto-Accept"; Rec."Auto-Accept") { ApplicationArea = All; ToolTip = 'Specifies whether partner output is accepted automatically.'; }
                field("Manual Review Required"; Rec."Manual Review Required") { ApplicationArea = All; ToolTip = 'Specifies whether manual partner review is required.'; }
                field(Active; Rec.Active) { ApplicationArea = All; ToolTip = 'Specifies whether the rule is active.'; }
            }
        }
    }
}

page 50102 "ICR Dimension Rules"
{
    PageType = List;
    SourceTable = "ICR Dimension Rule";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Intercompany Recharge Dimension Rules';

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Rule Code"; Rec."Rule Code") { ApplicationArea = All; ToolTip = 'Specifies the dimension rule code.'; }
                field(Direction; Rec.Direction) { ApplicationArea = All; ToolTip = 'Specifies the mapping direction.'; }
                field("Source Dimension Code"; Rec."Source Dimension Code") { ApplicationArea = All; ToolTip = 'Specifies the source dimension code.'; }
                field("Source Dimension Value"; Rec."Source Dimension Value") { ApplicationArea = All; ToolTip = 'Specifies the source dimension value.'; }
                field("Target Dimension Code"; Rec."Target Dimension Code") { ApplicationArea = All; ToolTip = 'Specifies the target dimension code.'; }
                field("Target Dimension Value"; Rec."Target Dimension Value") { ApplicationArea = All; ToolTip = 'Specifies the target dimension value.'; }
                field(Required; Rec.Required) { ApplicationArea = All; ToolTip = 'Specifies whether this mapping is required.'; }
                field(Active; Rec.Active) { ApplicationArea = All; ToolTip = 'Specifies whether the mapping is active.'; }
            }
        }
    }
}

page 50103 "ICR Recharge Requests"
{
    PageType = List;
    SourceTable = "ICR Recharge Request";
    CardPageId = "ICR Recharge Request Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Intercompany Recharge Requests';

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("No."; Rec."No.") { ApplicationArea = All; ToolTip = 'Specifies the recharge request number.'; }
                field(Status; Rec.Status) { ApplicationArea = All; ToolTip = 'Specifies the request status.'; }
                field("Source Company"; Rec."Source Company") { ApplicationArea = All; ToolTip = 'Specifies the source company.'; }
                field("Recharge Type"; Rec."Recharge Type") { ApplicationArea = All; ToolTip = 'Specifies the recharge type.'; }
                field("Cost Pool"; Rec."Cost Pool") { ApplicationArea = All; ToolTip = 'Specifies the cost pool.'; }
                field("Total Source Amount"; Rec."Total Source Amount") { ApplicationArea = All; ToolTip = 'Specifies the total source amount.'; }
                field("Total Allocation Amount"; Rec."Total Allocation Amount") { ApplicationArea = All; ToolTip = 'Specifies the total allocation amount.'; }
                field("Posted Amount"; Rec."Posted Amount") { ApplicationArea = All; ToolTip = 'Specifies the posted amount.'; }
                field("Exception Flag"; Rec."Exception Flag") { ApplicationArea = All; ToolTip = 'Specifies whether the request has exceptions.'; }
                field("Reconciliation Status"; Rec."Reconciliation Status") { ApplicationArea = All; ToolTip = 'Specifies the reconciliation status.'; }
            }
        }
    }
}

page 50104 "ICR Recharge Request Card"
{
    PageType = Card;
    SourceTable = "ICR Recharge Request";
    ApplicationArea = All;
    Caption = 'Intercompany Recharge Request';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.") { ApplicationArea = All; ToolTip = 'Specifies the recharge request number.'; }
                field(Status; Rec.Status) { ApplicationArea = All; ToolTip = 'Specifies the request status.'; }
                field("Source Company"; Rec."Source Company") { ApplicationArea = All; ToolTip = 'Specifies the source company.'; }
                field("Period Start"; Rec."Period Start") { ApplicationArea = All; ToolTip = 'Specifies the period start date.'; }
                field("Period End"; Rec."Period End") { ApplicationArea = All; ToolTip = 'Specifies the period end date.'; }
                field("Recharge Type"; Rec."Recharge Type") { ApplicationArea = All; ToolTip = 'Specifies the recharge type.'; }
                field("Cost Pool"; Rec."Cost Pool") { ApplicationArea = All; ToolTip = 'Specifies the cost pool.'; }
                field("Source G/L Account"; Rec."Source G/L Account") { ApplicationArea = All; ToolTip = 'Specifies the source G/L account.'; }
                field("Currency Code"; Rec."Currency Code") { ApplicationArea = All; ToolTip = 'Specifies the source currency code.'; }
            }
            group(Totals)
            {
                field("Total Source Amount"; Rec."Total Source Amount") { ApplicationArea = All; ToolTip = 'Specifies the total source amount.'; }
                field("Total Allocation Amount"; Rec."Total Allocation Amount") { ApplicationArea = All; ToolTip = 'Specifies the total allocation amount.'; }
                field("Posted Amount"; Rec."Posted Amount") { ApplicationArea = All; ToolTip = 'Specifies the posted amount.'; }
                field("Locked"; Rec.Locked) { ApplicationArea = All; ToolTip = 'Specifies whether the request is locked.'; }
                field("Approval Required"; Rec."Approval Required") { ApplicationArea = All; ToolTip = 'Specifies whether approval is required.'; }
                field("Exception Flag"; Rec."Exception Flag") { ApplicationArea = All; ToolTip = 'Specifies whether exceptions exist.'; }
                field("Last Error"; Rec."Last Error") { ApplicationArea = All; ToolTip = 'Specifies the latest error.'; }
                field("Reconciliation Status"; Rec."Reconciliation Status") { ApplicationArea = All; ToolTip = 'Specifies the reconciliation status.'; }
            }
            part(SourceLines; "ICR Recharge Source Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Request No." = field("No.");
            }
            part(AllocationLines; "ICR Recharge Alloc Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Request No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ValidateRequest)
            {
                Caption = 'Validate';
                ApplicationArea = All;
                Image = ValidateEmailLoggingSetup;
                ToolTip = 'Validate the recharge request.';

                trigger OnAction()
                var
                    RechargeMgt: Codeunit "ICR Recharge Mgt.";
                begin
                    RechargeMgt.ValidateRequest(Rec."No.");
                    CurrPage.Update(false);
                end;
            }
            action(Simulate)
            {
                Caption = 'Simulate';
                ApplicationArea = All;
                Image = Calculate;
                ToolTip = 'Calculate the proposal without posting.';

                trigger OnAction()
                var
                    RechargeMgt: Codeunit "ICR Recharge Mgt.";
                begin
                    RechargeMgt.CalculateRequest(Rec."No.", true);
                    CurrPage.Update(false);
                end;
            }
            action(Calculate)
            {
                Caption = 'Calculate';
                ApplicationArea = All;
                Image = Calculate;
                ToolTip = 'Calculate the recharge allocation.';

                trigger OnAction()
                var
                    RechargeMgt: Codeunit "ICR Recharge Mgt.";
                begin
                    RechargeMgt.CalculateRequest(Rec."No.", false);
                    CurrPage.Update(false);
                end;
            }
            action(Submit)
            {
                Caption = 'Submit';
                ApplicationArea = All;
                Image = SendApprovalRequest;
                ToolTip = 'Submit the request for approval.';

                trigger OnAction()
                var
                    RechargeMgt: Codeunit "ICR Recharge Mgt.";
                begin
                    RechargeMgt.SubmitForApproval(Rec."No.");
                    CurrPage.Update(false);
                end;
            }
            action(Approve)
            {
                Caption = 'Approve';
                ApplicationArea = All;
                Image = Approve;
                ToolTip = 'Approve the recharge request.';

                trigger OnAction()
                var
                    RechargeMgt: Codeunit "ICR Recharge Mgt.";
                begin
                    RechargeMgt.ApproveRequest(Rec."No.", 'Approved from request card.');
                    CurrPage.Update(false);
                end;
            }
            action(Reject)
            {
                Caption = 'Reject';
                ApplicationArea = All;
                Image = Reject;
                ToolTip = 'Reject the recharge request.';

                trigger OnAction()
                var
                    RechargeMgt: Codeunit "ICR Recharge Mgt.";
                begin
                    RechargeMgt.RejectRequest(Rec."No.", Rec."Rejection Reason");
                    CurrPage.Update(false);
                end;
            }
            action(Resubmit)
            {
                Caption = 'Resubmit';
                ApplicationArea = All;
                Image = ReOpen;
                ToolTip = 'Resubmit a rejected recharge request.';

                trigger OnAction()
                var
                    RechargeMgt: Codeunit "ICR Recharge Mgt.";
                begin
                    RechargeMgt.ResubmitRequest(Rec."No.");
                    CurrPage.Update(false);
                end;
            }
            action(Post)
            {
                Caption = 'Post';
                ApplicationArea = All;
                Image = Post;
                ToolTip = 'Post the approved recharge request.';

                trigger OnAction()
                var
                    RechargeMgt: Codeunit "ICR Recharge Mgt.";
                begin
                    RechargeMgt.PostRequest(Rec."No.");
                    CurrPage.Update(false);
                end;
            }
            action(Reconcile)
            {
                Caption = 'Reconcile';
                ApplicationArea = All;
                Image = Reconcile;
                ToolTip = 'Reconcile source, allocation, and posting output.';

                trigger OnAction()
                var
                    RechargeMgt: Codeunit "ICR Recharge Mgt.";
                begin
                    RechargeMgt.ReconcileRequest(Rec."No.");
                    CurrPage.Update(false);
                end;
            }
            action(Reverse)
            {
                Caption = 'Reverse';
                ApplicationArea = All;
                Image = ReverseRegister;
                ToolTip = 'Reverse the posted recharge request.';

                trigger OnAction()
                var
                    RechargeMgt: Codeunit "ICR Recharge Mgt.";
                begin
                    RechargeMgt.ReverseRequest(Rec."No.", Rec."Reversal Reason");
                    CurrPage.Update(false);
                end;
            }
            action(ExportAudit)
            {
                Caption = 'Export Audit';
                ApplicationArea = All;
                Image = Export;
                ToolTip = 'Record an audit export request.';

                trigger OnAction()
                var
                    RechargeMgt: Codeunit "ICR Recharge Mgt.";
                begin
                    RechargeMgt.ExportAudit(Rec."No.");
                end;
            }
        }
    }
}

page 50105 "ICR Recharge Source Lines"
{
    PageType = ListPart;
    SourceTable = "ICR Recharge Source Line";
    ApplicationArea = All;
    Caption = 'Recharge Source Lines';

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Line No."; Rec."Line No.") { ApplicationArea = All; ToolTip = 'Specifies the line number.'; }
                field(Description; Rec.Description) { ApplicationArea = All; ToolTip = 'Specifies the source line description.'; }
                field(Amount; Rec.Amount) { ApplicationArea = All; ToolTip = 'Specifies the source amount.'; }
                field("Currency Code"; Rec."Currency Code") { ApplicationArea = All; ToolTip = 'Specifies the source currency.'; }
                field("Source G/L Account"; Rec."Source G/L Account") { ApplicationArea = All; ToolTip = 'Specifies the source account.'; }
                field("Dimension Code"; Rec."Dimension Code") { ApplicationArea = All; ToolTip = 'Specifies the source dimension code.'; }
                field("Dimension Value"; Rec."Dimension Value") { ApplicationArea = All; ToolTip = 'Specifies the source dimension value.'; }
            }
        }
    }
}

page 50106 "ICR Recharge Alloc Lines"
{
    PageType = ListPart;
    SourceTable = "ICR Recharge Allocation Line";
    ApplicationArea = All;
    Caption = 'Recharge Allocation Lines';

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Line No."; Rec."Line No.") { ApplicationArea = All; ToolTip = 'Specifies the line number.'; }
                field("Partner Rule Code"; Rec."Partner Rule Code") { ApplicationArea = All; ToolTip = 'Specifies the partner rule.'; }
                field("IC Partner Code"; Rec."IC Partner Code") { ApplicationArea = All; ToolTip = 'Specifies the intercompany partner.'; }
                field("Target Company"; Rec."Target Company") { ApplicationArea = All; ToolTip = 'Specifies the target company.'; }
                field("Allocation Basis"; Rec."Allocation Basis") { ApplicationArea = All; ToolTip = 'Specifies the allocation basis.'; }
                field("Source Amount"; Rec."Source Amount") { ApplicationArea = All; ToolTip = 'Specifies the source amount.'; }
                field("Allocation Percent"; Rec."Allocation Percent") { ApplicationArea = All; ToolTip = 'Specifies the allocation percentage.'; }
                field("Driver Quantity"; Rec."Driver Quantity") { ApplicationArea = All; ToolTip = 'Specifies the driver quantity.'; }
                field("Allocation Amount"; Rec."Allocation Amount") { ApplicationArea = All; ToolTip = 'Specifies the allocation amount.'; }
                field("Target Amount"; Rec."Target Amount") { ApplicationArea = All; ToolTip = 'Specifies the target amount.'; }
                field("Exchange Rate"; Rec."Exchange Rate") { ApplicationArea = All; ToolTip = 'Specifies the exchange rate.'; }
                field("Response Status"; Rec."Response Status") { ApplicationArea = All; ToolTip = 'Specifies the partner response status.'; }
                field("Calculation Trace"; Rec."Calculation Trace") { ApplicationArea = All; ToolTip = 'Specifies the calculation trace.'; }
            }
        }
    }
}

page 50107 "ICR Posting Links"
{
    PageType = List;
    SourceTable = "ICR Recharge Posting Link";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Intercompany Recharge Posting Links';

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Request No."; Rec."Request No.") { ApplicationArea = All; ToolTip = 'Specifies the request number.'; }
                field("Line No."; Rec."Line No.") { ApplicationArea = All; ToolTip = 'Specifies the line number.'; }
                field("Allocation Line No."; Rec."Allocation Line No.") { ApplicationArea = All; ToolTip = 'Specifies the allocation line number.'; }
                field("Posting Method"; Rec."Posting Method") { ApplicationArea = All; ToolTip = 'Specifies the posting method.'; }
                field("Document No."; Rec."Document No.") { ApplicationArea = All; ToolTip = 'Specifies the generated document number.'; }
                field("Outbox Transaction Id"; Rec."Outbox Transaction Id") { ApplicationArea = All; ToolTip = 'Specifies the outbox transaction identifier.'; }
                field("Inbox Transaction Id"; Rec."Inbox Transaction Id") { ApplicationArea = All; ToolTip = 'Specifies the inbox transaction identifier.'; }
                field(Amount; Rec.Amount) { ApplicationArea = All; ToolTip = 'Specifies the source amount.'; }
                field("Target Amount"; Rec."Target Amount") { ApplicationArea = All; ToolTip = 'Specifies the target amount.'; }
                field("Idempotency Key"; Rec."Idempotency Key") { ApplicationArea = All; ToolTip = 'Specifies the idempotency key.'; }
                field(Posted; Rec.Posted) { ApplicationArea = All; ToolTip = 'Specifies whether the output is posted.'; }
                field("Correction Type"; Rec."Correction Type") { ApplicationArea = All; ToolTip = 'Specifies the correction type.'; }
            }
        }
    }
}

page 50108 "ICR Audit Events"
{
    PageType = List;
    SourceTable = "ICR Recharge Audit Event";
    ApplicationArea = All;
    UsageCategory = History;
    Caption = 'Intercompany Recharge Audit Events';

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; ToolTip = 'Specifies the entry number.'; }
                field("Request No."; Rec."Request No.") { ApplicationArea = All; ToolTip = 'Specifies the request number.'; }
                field("Event Type"; Rec."Event Type") { ApplicationArea = All; ToolTip = 'Specifies the event type.'; }
                field("Old Value"; Rec."Old Value") { ApplicationArea = All; ToolTip = 'Specifies the previous value.'; }
                field("New Value"; Rec."New Value") { ApplicationArea = All; ToolTip = 'Specifies the new value.'; }
                field("Reason Code"; Rec."Reason Code") { ApplicationArea = All; ToolTip = 'Specifies the reason code.'; }
                field("User ID"; Rec."User ID") { ApplicationArea = All; ToolTip = 'Specifies the user ID.'; }
                field("Created At"; Rec."Created At") { ApplicationArea = All; ToolTip = 'Specifies when the event was created.'; }
                field(Details; Rec.Details) { ApplicationArea = All; ToolTip = 'Specifies event details.'; }
            }
        }
    }
}

page 50109 "ICR Exceptions"
{
    PageType = List;
    SourceTable = "ICR Recharge Exception";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Intercompany Recharge Exceptions';

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; ToolTip = 'Specifies the entry number.'; }
                field("Request No."; Rec."Request No.") { ApplicationArea = All; ToolTip = 'Specifies the request number.'; }
                field("Partner Rule Code"; Rec."Partner Rule Code") { ApplicationArea = All; ToolTip = 'Specifies the partner rule.'; }
                field("Exception Type"; Rec."Exception Type") { ApplicationArea = All; ToolTip = 'Specifies the exception type.'; }
                field(Severity; Rec.Severity) { ApplicationArea = All; ToolTip = 'Specifies the exception severity.'; }
                field(Message; Rec.Message) { ApplicationArea = All; ToolTip = 'Specifies the exception message.'; }
                field("Owner Role"; Rec."Owner Role") { ApplicationArea = All; ToolTip = 'Specifies the owner role.'; }
                field("Retry Eligible"; Rec."Retry Eligible") { ApplicationArea = All; ToolTip = 'Specifies whether retry is allowed.'; }
                field(Resolved; Rec.Resolved) { ApplicationArea = All; ToolTip = 'Specifies whether the exception is resolved.'; }
            }
        }
    }
}

page 50110 "ICR Approval History"
{
    PageType = List;
    SourceTable = "ICR Approval History";
    ApplicationArea = All;
    UsageCategory = History;
    Caption = 'Intercompany Recharge Approval History';

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; ToolTip = 'Specifies the entry number.'; }
                field("Request No."; Rec."Request No.") { ApplicationArea = All; ToolTip = 'Specifies the request number.'; }
                field(Action; Rec.Action) { ApplicationArea = All; ToolTip = 'Specifies the approval action.'; }
                field("Actor User ID"; Rec."Actor User ID") { ApplicationArea = All; ToolTip = 'Specifies the acting user.'; }
                field(Comment; Rec.Comment) { ApplicationArea = All; ToolTip = 'Specifies the comment.'; }
                field("Resulting Status"; Rec."Resulting Status") { ApplicationArea = All; ToolTip = 'Specifies the resulting status.'; }
                field("Created At"; Rec."Created At") { ApplicationArea = All; ToolTip = 'Specifies when the entry was created.'; }
            }
        }
    }
}

page 50111 "ICR Operational Monitor"
{
    PageType = List;
    SourceTable = "ICR Processing Unit";
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'Intercompany Recharge Operational Monitor';

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Unit Id"; Rec."Unit Id") { ApplicationArea = All; ToolTip = 'Specifies the processing unit identifier.'; }
                field("Request No."; Rec."Request No.") { ApplicationArea = All; ToolTip = 'Specifies the request number.'; }
                field("Source Company"; Rec."Source Company") { ApplicationArea = All; ToolTip = 'Specifies the source company.'; }
                field("Recharge Type"; Rec."Recharge Type") { ApplicationArea = All; ToolTip = 'Specifies the recharge type.'; }
                field("Partner Rule Code"; Rec."Partner Rule Code") { ApplicationArea = All; ToolTip = 'Specifies the partner rule.'; }
                field("Period Start"; Rec."Period Start") { ApplicationArea = All; ToolTip = 'Specifies the period start date.'; }
                field(Status; Rec.Status) { ApplicationArea = All; ToolTip = 'Specifies the processing status.'; }
                field("Retry Count"; Rec."Retry Count") { ApplicationArea = All; ToolTip = 'Specifies the retry count.'; }
                field("Last Error"; Rec."Last Error") { ApplicationArea = All; ToolTip = 'Specifies the latest error.'; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Retry)
            {
                Caption = 'Retry';
                ApplicationArea = All;
                Image = Refresh;
                ToolTip = 'Retry this processing unit.';

                trigger OnAction()
                var
                    RechargeMgt: Codeunit "ICR Recharge Mgt.";
                begin
                    RechargeMgt.RetryProcessingUnit(Rec."Unit Id");
                    CurrPage.Update(false);
                end;
            }
        }
    }
}

page 50112 "ICR Reconciliation Results"
{
    PageType = List;
    SourceTable = "ICR Reconciliation Result";
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Intercompany Recharge Reconciliation Results';

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Request No."; Rec."Request No.") { ApplicationArea = All; ToolTip = 'Specifies the request number.'; }
                field("Source Company"; Rec."Source Company") { ApplicationArea = All; ToolTip = 'Specifies the source company.'; }
                field("IC Partner Code"; Rec."IC Partner Code") { ApplicationArea = All; ToolTip = 'Specifies the intercompany partner.'; }
                field("Period Start"; Rec."Period Start") { ApplicationArea = All; ToolTip = 'Specifies the period start date.'; }
                field("Recharge Type"; Rec."Recharge Type") { ApplicationArea = All; ToolTip = 'Specifies the recharge type.'; }
                field("Source Currency Code"; Rec."Source Currency Code") { ApplicationArea = All; ToolTip = 'Specifies the source currency.'; }
                field("Target Currency Code"; Rec."Target Currency Code") { ApplicationArea = All; ToolTip = 'Specifies the target currency.'; }
                field("Source Amount"; Rec."Source Amount") { ApplicationArea = All; ToolTip = 'Specifies the source amount.'; }
                field("Allocation Amount"; Rec."Allocation Amount") { ApplicationArea = All; ToolTip = 'Specifies the allocation amount.'; }
                field("Posted Amount"; Rec."Posted Amount") { ApplicationArea = All; ToolTip = 'Specifies the posted amount.'; }
                field("Rounding Adjustment"; Rec."Rounding Adjustment") { ApplicationArea = All; ToolTip = 'Specifies the rounding adjustment.'; }
                field("Posting Reference"; Rec."Posting Reference") { ApplicationArea = All; ToolTip = 'Specifies the posting reference.'; }
                field("Partner Response"; Rec."Partner Response") { ApplicationArea = All; ToolTip = 'Specifies the partner response.'; }
                field(Balanced; Rec.Balanced) { ApplicationArea = All; ToolTip = 'Specifies whether reconciliation balanced.'; }
                field("Result Message"; Rec."Result Message") { ApplicationArea = All; ToolTip = 'Specifies the reconciliation result message.'; }
            }
        }
    }
}
